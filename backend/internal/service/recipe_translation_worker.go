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
		log.Printf("[RecipeTranslationWorker] Starting translation worker (Groq enabled: %v)...", w.translator.IsGroqEnabled())

		// Reset any previously postponed retries and stalled translations so pending queue runs immediately
		initCtx, initCancel := context.WithTimeout(context.Background(), 10*time.Second)
		_ = w.queries.ResetStaleTranslationRetries(initCtx)
		_ = w.queries.ResetStalledTranslatingRecipes(initCtx)
		if pending, err := w.queries.CountPendingRecipeTranslations(initCtx); err == nil {
			log.Printf("[RecipeTranslationWorker] Queue status: %d recipe(s) waiting for translation", pending)
		}
		initCancel()

		wasIdle := false
		for {
			select {
			case <-w.stop:
				log.Println("[RecipeTranslationWorker] Stopping translation worker...")
				return
			default:
			}

			ctx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
			err := w.translateNext(ctx)
			cancel()

			if err != nil {
				if errors.Is(err, pgx.ErrNoRows) {
					if !wasIdle {
						log.Println("[RecipeTranslationWorker] All recipes translated. Worker idle and waiting for new recipes...")
						wasIdle = true
					}
					select {
					case <-w.stop:
						return
					case <-time.After(10 * time.Second):
					}
					continue
				}

				wasIdle = false
				log.Printf("[RecipeTranslationWorker] Translation error: %v. Pausing queue for 15s before next attempt...", err)
				select {
				case <-w.stop:
					return
				case <-time.After(15 * time.Second):
				}
				continue
			}

			wasIdle = false
			// Small 300ms pause between recipes to be gentle on CPU and network
			select {
			case <-w.stop:
				return
			case <-time.After(300 * time.Millisecond):
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

	startTime := time.Now()
	log.Printf("[RecipeTranslationWorker] Claimed recipe #%d: %q", recipe.ID, recipe.Title)

	ingredients, err := w.queries.GetRecipeTranslationIngredients(ctx, recipe.ID)
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		log.Printf("[RecipeTranslationWorker] Recipe #%d: failed to fetch ingredients: %v", recipe.ID, err)
		return err
	}

	instructions := make([]string, 0)
	if err := json.Unmarshal(recipe.Instructions, &instructions); err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		log.Printf("[RecipeTranslationWorker] Recipe #%d: invalid instructions JSON: %v", recipe.ID, err)
		return err
	}

	if w.translator.IsGroqEnabled() {
		err := w.translateViaGroq(ctx, recipe, instructions, ingredients, startTime)
		if err == nil {
			return nil
		}
		log.Printf("[RecipeTranslationWorker] Recipe #%d: Groq translation failed (%v), falling back to standard providers", recipe.ID, err)
	}

	return w.translateViaFallback(ctx, recipe, instructions, ingredients, startTime)
}

func (w *RecipeTranslationWorker) translateViaGroq(
	ctx context.Context,
	recipe store.ClaimPendingRecipeTranslationRow,
	instructions []string,
	ingredients []store.GetRecipeTranslationIngredientsRow,
	startTime time.Time,
) error {
	groqIngredients := make([]GroqRecipeIngredient, len(ingredients))
	for i, ing := range ingredients {
		name := ing.Name
		if !hasRussian(name) && ing.NameEn.Valid && ing.NameEn.String != "" {
			name = ing.NameEn.String
		}
		displayTxt := ""
		if ing.DisplayText.Valid {
			displayTxt = ing.DisplayText.String
		}
		groqIngredients[i] = GroqRecipeIngredient{
			ID:          ing.IngredientID,
			Name:        name,
			DisplayText: displayTxt,
		}
	}

	var descStr string
	if recipe.Description.Valid {
		descStr = recipe.Description.String
	}

	translated, err := w.translator.TranslateRecipeGroq(ctx, GroqRecipeTranslateRequest{
		Title:        recipe.Title,
		Description:  descStr,
		Instructions: instructions,
		Ingredients:  groqIngredients,
	})
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	instructionsJSON, err := json.Marshal(translated.LocalizedInstructions)
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	var localizedDesc pgtype.Text
	if translated.LocalizedDescription != "" {
		localizedDesc = pgtype.Text{String: translated.LocalizedDescription, Valid: true}
	}

	// Update translated ingredients
	for _, ing := range translated.Ingredients {
		if ing.RussianName != "" {
			_ = w.queries.UpdateIngredientRussianName(ctx, store.UpdateIngredientRussianNameParams{
				ID: ing.ID, Name: strings.ToLower(strings.TrimSpace(ing.RussianName)),
			})
		}
		if ing.LocalizedDisplayText != "" {
			_ = w.queries.UpdateRecipeIngredientTranslation(ctx, store.UpdateRecipeIngredientTranslationParams{
				RecipeID:             recipe.ID,
				IngredientID:         ing.ID,
				LocalizedDisplayText: pgtype.Text{String: ing.LocalizedDisplayText, Valid: true},
			})
		}
	}

	err = w.queries.UpdateRecipeTranslationWithDetails(ctx, store.UpdateRecipeTranslationWithDetailsParams{
		ID:                    recipe.ID,
		LocalizedTitle:        pgtype.Text{String: translated.LocalizedTitle, Valid: true},
		LocalizedDescription:  localizedDesc,
		LocalizedInstructions: instructionsJSON,
		CookingTimeMinutes:    translated.CookingTimeMinutes,
		Difficulty:            translated.Difficulty,
	})
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	pendingCount, _ := w.queries.CountPendingRecipeTranslations(ctx)
	log.Printf("[RecipeTranslationWorker] Successfully translated recipe #%d in %v via Groq: %q -> %q (time: %dm, diff: %s, steps: %d, ingredients: %d). Remaining: %d",
		recipe.ID,
		time.Since(startTime).Round(time.Millisecond),
		recipe.Title,
		translated.LocalizedTitle,
		translated.CookingTimeMinutes,
		translated.Difficulty,
		len(translated.LocalizedInstructions),
		len(translated.Ingredients),
		pendingCount,
	)

	return nil
}

func (w *RecipeTranslationWorker) translateViaFallback(
	ctx context.Context,
	recipe store.ClaimPendingRecipeTranslationRow,
	instructions []string,
	ingredients []store.GetRecipeTranslationIngredientsRow,
	startTime time.Time,
) error {
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
			_ = w.queries.UpdateIngredientRussianName(ctx, store.UpdateIngredientRussianNameParams{
				ID: ingredient.IngredientID, Name: translated[ingredientNames[i]],
			})
		}
		if displayTexts[i] >= 0 {
			_ = w.queries.UpdateRecipeIngredientTranslation(ctx, store.UpdateRecipeIngredientTranslationParams{
				RecipeID: recipe.ID, IngredientID: ingredient.IngredientID,
				LocalizedDisplayText: pgtype.Text{String: translated[displayTexts[i]], Valid: true},
			})
		}
	}

	err = w.queries.UpdateRecipeTranslation(ctx, store.UpdateRecipeTranslationParams{
		ID: recipe.ID, LocalizedTitle: pgtype.Text{String: title, Valid: true},
		LocalizedDescription: description, LocalizedInstructions: instructionsJSON,
	})
	if err != nil {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return err
	}

	pendingCount, _ := w.queries.CountPendingRecipeTranslations(ctx)
	log.Printf("[RecipeTranslationWorker] Successfully translated recipe #%d in %v via fallback: %q -> %q. Remaining: %d",
		recipe.ID,
		time.Since(startTime).Round(time.Millisecond),
		recipe.Title,
		title,
		pendingCount,
	)

	return nil
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
