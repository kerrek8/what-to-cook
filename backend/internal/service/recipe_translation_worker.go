package service

import (
	"context"
	"encoding/json"
	"errors"
	"log"
	"strings"
	"time"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

type RecipeSyncer interface {
	SyncFromProvider(ctx context.Context, query string) (dto.RecipeSyncResponse, error)
}

type RecipeTranslationWorker struct {
	queries         store.Querier
	translator      TranslationService
	syncer          RecipeSyncer
	stop            chan struct{}
	ingestIndex     int
	ingestCompleted bool
}

func NewRecipeTranslationWorker(queries store.Querier, translator TranslationService, syncer RecipeSyncer) *RecipeTranslationWorker {
	return &RecipeTranslationWorker{
		queries:    queries,
		translator: translator,
		syncer:     syncer,
		stop:       make(chan struct{}),
	}
}

func (w *RecipeTranslationWorker) Start() {
	go func() {
		log.Printf("[RecipeTranslationWorker] Starting translation worker (Groq enabled: %v)...", w.translator.IsGroqEnabled())

		initCtx, initCancel := context.WithTimeout(context.Background(), 10*time.Second)
		_ = w.queries.ResetStaleTranslationRetries(initCtx)
		_ = w.queries.ResetStalledTranslatingRecipes(initCtx)
		if pending, err := w.queries.CountPendingRecipeTranslations(initCtx); err == nil {
			log.Printf("[RecipeTranslationWorker] Queue status: %d recipe(s) waiting for translation", pending)
		}
		initCancel()

		wasIdle := false
		batchCount := 0
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
						log.Println("[RecipeTranslationWorker] All pending recipes translated. Worker idle and waiting for new recipes...")
						wasIdle = true
					}
					batchCount = 0
					select {
					case <-w.stop:
						return
					case <-time.After(15 * time.Second):
					}
					continue
				}

				wasIdle = false
				batchCount = 0

				if isDaily, waitDuration := ParseDailyLimitError(err); isDaily {
					log.Printf("[RecipeTranslationWorker] ⚠️ Groq daily quota reached (TPD/RPD). Pausing worker for %v (resuming at %s)...",
						waitDuration.Round(time.Second),
						time.Now().Add(waitDuration).Format("15:04:05"),
					)
					select {
					case <-w.stop:
						return
					case <-time.After(waitDuration):
					}
					continue
				}

				log.Printf("[RecipeTranslationWorker] Translation error: %v. Pausing queue for 80s before next attempt...", err)
				select {
				case <-w.stop:
					return
				case <-time.After(80 * time.Second):
				}
				continue
			}

			wasIdle = false
			batchCount++

			if batchCount >= 3 {
				log.Println("[RecipeTranslationWorker] 3 recipes processed. Pausing for 80 seconds to respect Groq rate limits (8K TPM)...")
				batchCount = 0
				select {
				case <-w.stop:
					return
				case <-time.After(80 * time.Second):
				}
			} else {
				select {
				case <-w.stop:
					return
				case <-time.After(2 * time.Second):
				}
			}
		}
	}()
}

func (w *RecipeTranslationWorker) Stop() {
	close(w.stop)
}

var ingestQueries = []string{
	"chicken", "beef", "pork", "pasta", "salad", "fish", "soup", "curry", "pie", "cake",
	"lamb", "rice", "cheese", "potato", "bread", "dessert", "breakfast", "vegetarian",
	"a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
	"n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
}

func (w *RecipeTranslationWorker) ingestBatch(ctx context.Context) int {
	totalSynced := 0

	for w.ingestIndex < len(ingestQueries) && totalSynced < 50 {
		query := ingestQueries[w.ingestIndex]
		w.ingestIndex++

		resp, err := w.syncer.SyncFromProvider(ctx, query)
		if err != nil {
			log.Printf("[RecipeTranslationWorker] Ingest query %q error: %v", query, err)
			continue
		}

		if resp.SyncedCount > 0 {
			totalSynced += resp.SyncedCount
			log.Printf("[RecipeTranslationWorker] Ingested %d recipes for query %q (batch progress: %d/50)", resp.SyncedCount, query, totalSynced)
		}
	}

	if w.ingestIndex >= len(ingestQueries) {
		w.ingestCompleted = true
		log.Printf("[RecipeTranslationWorker] All available recipes from external provider have been ingested. Transitioning to idle mode.")
	}

	return totalSynced
}

func (w *RecipeTranslationWorker) translateNext(ctx context.Context) error {
	recipe, err := w.queries.ClaimPendingRecipeTranslation(ctx)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			totalCount, countErr := w.queries.CountTotalRecipes(ctx)
			if countErr == nil && totalCount < 1000 && !w.ingestCompleted && w.syncer != nil {
				synced := w.ingestBatch(ctx)
				if synced > 0 {
					return w.translateNext(ctx)
				}
			}
		}
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

	if !w.translator.IsGroqEnabled() {
		_ = w.queries.RetryRecipeTranslation(ctx, recipe.ID)
		return errors.New("groq api key is not configured")
	}

	return w.translateViaGroq(ctx, recipe, instructions, ingredients, startTime)
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
		if ing.NameEn.Valid && ing.NameEn.String != "" {
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

	for _, ing := range translated.Ingredients {
		russianName := strings.ToLower(strings.TrimSpace(ing.RussianName))
		if russianName != "" {
			existing, err := w.queries.GetIngredientByNameCaseInsensitive(ctx, russianName)
			if err == nil && existing.ID != ing.ID {
				_ = w.queries.ReassignRecipeIngredient(ctx, store.ReassignRecipeIngredientParams{
					RecipeID:             recipe.ID,
					TargetIngredientID:   existing.ID,
					DisplayText:          pgtype.Text{String: ing.LocalizedDisplayText, Valid: true},
					LocalizedDisplayText: pgtype.Text{String: ing.LocalizedDisplayText, Valid: true},
					Criticality:          "desirable",
				})
				_ = w.queries.DeleteRecipeIngredientLink(ctx, store.DeleteRecipeIngredientLinkParams{
					RecipeID:     recipe.ID,
					IngredientID: ing.ID,
				})
				_ = w.queries.DeleteUnusedIngredient(ctx, ing.ID)
				continue
			}

			_ = w.queries.UpdateIngredientRussianName(ctx, store.UpdateIngredientRussianNameParams{
				ID:   ing.ID,
				Name: russianName,
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
