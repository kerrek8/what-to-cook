package service

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"strings"
	"time"
	"unicode"
	"unicode/utf8"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

type RecipeTranslationWorker struct {
	queries    store.Querier
	translator TranslationService
	stop       chan struct{}
}

func NewRecipeTranslationWorker(queries store.Querier, translator TranslationService) *RecipeTranslationWorker {
	return &RecipeTranslationWorker{queries: queries, translator: translator, stop: make(chan struct{})}
}

func (w *RecipeTranslationWorker) Start() {
	go func() {
		for {
			select {
			case <-w.stop:
				return
			default:
			}

			ctx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
			err := w.translateNext(ctx)
			cancel()
			if err != nil && !errors.Is(err, pgx.ErrNoRows) {
				log.Printf("recipe translation worker: %v", err)
			}
			if err != nil {
				delay := 5 * time.Second
				if !errors.Is(err, pgx.ErrNoRows) {
					delay = 30 * time.Second
				}
				select {
				case <-w.stop:
					return
				case <-time.After(delay):
				}
			}
		}
	}()
}

func (w *RecipeTranslationWorker) Stop() {
	close(w.stop)
}

func (w *RecipeTranslationWorker) translateNext(ctx context.Context) error {
	recipe, err := w.queries.ClaimPendingRecipeTranslation(ctx)
	if err != nil {
		return err
	}
	ingredients, err := w.queries.GetRecipeTranslationIngredients(ctx, recipe.ID)
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	instructions := make([]string, 0)
	if err := json.Unmarshal(recipe.Instructions, &instructions); err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	texts := []string{recipe.Title}
	descriptionIndex := -1
	if recipe.Description.Valid && strings.TrimSpace(recipe.Description.String) != "" {
		descriptionIndex = len(texts)
		texts = append(texts, recipe.Description.String)
	}
	instructionIndices := make([]int, len(instructions))
	for i, instruction := range instructions {
		instructionIndices[i] = len(texts)
		texts = append(texts, instruction)
	}
	ingredientNames := make([]int, len(ingredients))
	displayTexts := make([]int, len(ingredients))
	for i, ingredient := range ingredients {
		name := ingredient.Name
		if !hasRussian(name) && ingredient.NameEn.Valid && ingredient.NameEn.String != "" {
			name = ingredient.NameEn.String
		}
		ingredientNames[i] = -1
		if !hasRussian(name) {
			ingredientNames[i] = len(texts)
			texts = append(texts, name)
		}
		displayTexts[i] = -1
		if ingredient.DisplayText.Valid && strings.TrimSpace(ingredient.DisplayText.String) != "" {
			displayTexts[i] = len(texts)
			texts = append(texts, ingredient.DisplayText.String)
		}
	}

	translated, err := w.translateAll(texts)
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	title := translated[0]
	var description pgtype.Text
	if descriptionIndex >= 0 {
		description = pgtype.Text{String: translated[descriptionIndex], Valid: true}
	}
	localizedInstructions := make([]string, len(instructionIndices))
	for i, index := range instructionIndices {
		localizedInstructions[i] = translated[index]
	}
	instructionsJSON, err := json.Marshal(localizedInstructions)
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	for i, ingredient := range ingredients {
		if ingredientNames[i] >= 0 {
			if err := w.queries.UpdateIngredientRussianName(ctx, store.UpdateIngredientRussianNameParams{
				ID: ingredient.IngredientID, Name: translated[ingredientNames[i]],
			}); err != nil {
				_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
				return err
			}
		}
		if displayTexts[i] >= 0 {
			if err := w.queries.UpdateRecipeIngredientTranslation(ctx, store.UpdateRecipeIngredientTranslationParams{
				RecipeID: recipe.ID, IngredientID: ingredient.IngredientID,
				LocalizedDisplayText: pgtype.Text{String: translated[displayTexts[i]], Valid: true},
			}); err != nil {
				_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
				return err
			}
		}
	}

	return w.queries.UpdateRecipeTranslation(ctx, store.UpdateRecipeTranslationParams{
		ID: recipe.ID, LocalizedTitle: pgtype.Text{String: title, Valid: true},
		LocalizedDescription: description, LocalizedInstructions: instructionsJSON,
	})
}

func (w *RecipeTranslationWorker) translateAll(texts []string) ([]string, error) {
	var chunks []string
	chunkIndices := make([][]int, len(texts))
	for i, text := range texts {
		for _, chunk := range splitTranslationText(text) {
			chunkIndices[i] = append(chunkIndices[i], len(chunks))
			chunks = append(chunks, chunk)
		}
	}
	translatedChunks := make([]string, len(chunks))
	for start := 0; start < len(chunks); start += 10 {
		end := min(start+10, len(chunks))
		result, err := w.translator.Translate(dto.TranslateRequest{Texts: chunks[start:end], Source: "en", Target: "ru"})
		if err != nil {
			return nil, err
		}
		copy(translatedChunks[start:end], result.Translations)
	}
	translated := make([]string, len(texts))
	for i, indices := range chunkIndices {
		parts := make([]string, len(indices))
		for j, index := range indices {
			parts[j] = translatedChunks[index]
		}
		translated[i] = strings.Join(parts, " ")
	}
	return translated, nil
}

func splitTranslationText(text string) []string {
	text = strings.TrimSpace(text)
	if text == "" {
		return nil
	}
	const maxBytes = 1200
	if len(text) <= maxBytes {
		return []string{text}
	}

	var sentences []string
	start := 0
	for offset := 0; offset < len(text); {
		r, size := utf8.DecodeRuneInString(text[offset:])
		end := offset + size
		split := r == '\n' || r == '.' || r == '!' || r == '?'
		next, _ := utf8.DecodeRuneInString(text[end:])
		if split && (end == len(text) || unicode.IsSpace(next)) {
			if sentence := strings.TrimSpace(text[start:end]); sentence != "" {
				sentences = append(sentences, sentence)
			}
			start = end
		}
		offset = end
	}
	if tail := strings.TrimSpace(text[start:]); tail != "" {
		sentences = append(sentences, tail)
	}

	var chunks []string
	for _, sentence := range sentences {
		for len(sentence) > maxBytes {
			cut := maxBytes
			for cut > 0 && !utf8.RuneStart(sentence[cut]) {
				cut--
			}
			if whitespace := strings.LastIndexAny(sentence[:cut], " \t"); whitespace > cut/2 {
				cut = whitespace
			}
			chunks = append(chunks, strings.TrimSpace(sentence[:cut]))
			sentence = strings.TrimSpace(sentence[cut:])
		}
		chunks = append(chunks, sentence)
	}
	return chunks
}

func hasRussian(text string) bool {
	for _, char := range text {
		if char >= 'А' && char <= 'я' || char == 'Ё' || char == 'ё' {
			return true
		}
	}
	return false
}
