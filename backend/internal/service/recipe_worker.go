package service

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"os"
	"path/filepath"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

type RecipeWorker struct {
	queries        store.Querier
	gigaChatCfg    config.GigaChatConfig
	workerCfg      config.RecipeWorkerConfig
	httpClient     *http.Client
	token          string
	tokenExpiresAt int64
	stopChan       chan struct{}
	running        bool
	mu             sync.Mutex
}

type rawCandidateRecipe struct {
	Title       string          `json:"title"`
	Category    string          `json:"category"`
	Poster      string          `json:"poster"`
	Difficulty  *string         `json:"difficulty"`
	CookTime    *string         `json:"cooktime"`
	Instruction json.RawMessage `json:"instruction"`
	Ingredients []struct {
		Name string `json:"name"`
		List []struct {
			Name  string  `json:"name"`
			Value *string `json:"value"`
			Type  *string `json:"type"`
		} `json:"list"`
	} `json:"ingredients"`
}

type normalizedRecipeIngredient struct {
	Name        string   `json:"name"`
	Category    string   `json:"category"`
	Amount      *float64 `json:"amount"`
	Unit        *string  `json:"unit"`
	DisplayText string   `json:"display_text"`
	Criticality string   `json:"criticality"`
}

type normalizedRecipeOutput struct {
	CookingTimeMinutes int                          `json:"cooking_time_minutes"`
	Difficulty         string                       `json:"difficulty"`
	Ingredients        []normalizedRecipeIngredient `json:"ingredients"`
}

func NewRecipeWorker(queries store.Querier, gigaChatCfg config.GigaChatConfig, workerCfg config.RecipeWorkerConfig) *RecipeWorker {
	tr := &http.Transport{
		TLSClientConfig: &tls.Config{InsecureSkipVerify: !gigaChatCfg.VerifySSL},
	}
	return &RecipeWorker{
		queries:     queries,
		gigaChatCfg: gigaChatCfg,
		workerCfg:   workerCfg,
		httpClient: &http.Client{
			Transport: tr,
			Timeout:   60 * time.Second,
		},
		stopChan: make(chan struct{}),
	}
}

func (w *RecipeWorker) Start() {
	w.mu.Lock()
	defer w.mu.Unlock()

	if w.running {
		return
	}

	if !w.workerCfg.Enabled {
		log.Printf("[RecipeWorker] Worker is disabled (RECIPE_WORKER_ENABLED=false)")
		return
	}

	w.running = true
	log.Printf("[RecipeWorker] Initialized (target: %d recipes, chunk: %d, sub-batch: %d, pause: %v)",
		w.workerCfg.TargetTotal, w.workerCfg.ChunkSize, w.workerCfg.SubBatchSize, w.workerCfg.SubBatchPause)

	go w.runLoop()
}

func (w *RecipeWorker) Stop() {
	w.mu.Lock()
	defer w.mu.Unlock()

	if !w.running {
		return
	}

	log.Printf("[RecipeWorker] Stopping background worker...")
	close(w.stopChan)
	w.running = false
	log.Printf("[RecipeWorker] Stopped")
}

func (w *RecipeWorker) runLoop() {
	ctx := context.Background()

	// Initial delay before starting import loop to allow server to fully bind
	select {
	case <-w.stopChan:
		return
	case <-time.After(2 * time.Second):
	}

	currentOffset := 1
	for {
		select {
		case <-w.stopChan:
			return
		default:
		}

		count, err := w.queries.CountTotalRecipes(ctx)
		if err != nil {
			log.Printf("[RecipeWorker] [ERROR] Failed to count recipes in database: %v", err)
			if !w.sleepInterruptible(10 * time.Second) {
				return
			}
			continue
		}

		log.Printf("[RecipeWorker] Current database state: %d/%d recipes", count, w.workerCfg.TargetTotal)

		if count >= int64(w.workerCfg.TargetTotal) {
			log.Printf("[RecipeWorker] Target goal achieved (%d recipes in database). Worker entering idle standby.", count)
			if !w.sleepInterruptible(1 * time.Hour) {
				return
			}
			continue
		}

		// 1. Fetch next chunk of candidate recipes
		log.Printf("[RecipeWorker] Fetching chunk of up to %d candidate raw recipes (starting from offset %d)...", w.workerCfg.ChunkSize, currentOffset)
		candidates, nextOffset := w.fetchCandidatesChunk(ctx, currentOffset, w.workerCfg.ChunkSize)
		currentOffset = nextOffset

		if len(candidates) == 0 {
			log.Printf("[RecipeWorker] No new candidates found in current range. Advancing offset...")
			if !w.sleepInterruptible(30 * time.Second) {
				return
			}
			continue
		}

		log.Printf("[RecipeWorker] Found %d new candidate recipes to process.", len(candidates))

		// 2. Process in sub-batches of SubBatchSize (3)
		subBatchCount := 0
		for _, raw := range candidates {
			select {
			case <-w.stopChan:
				return
			default:
			}

			// Check total count before each recipe
			curCount, _ := w.queries.CountTotalRecipes(ctx)
			if curCount >= int64(w.workerCfg.TargetTotal) {
				log.Printf("[RecipeWorker] Target goal achieved (%d/%d recipes). Stopping processing.", curCount, w.workerCfg.TargetTotal)
				break
			}

			log.Printf("[RecipeWorker] Processing candidate: %q...", raw.Title)
			saved, err := w.processAndSaveRecipe(ctx, raw)
			if err != nil {
				var rateLimitErr *rateLimitError
				if errors.As(err, &rateLimitErr) {
					log.Printf("[RecipeWorker] [RATE_LIMIT] GigaChat limit reached: %v. Pausing worker for %v...", err, w.workerCfg.RateLimitPause)
					if !w.sleepInterruptible(w.workerCfg.RateLimitPause) {
						return
					}
					// Retry this recipe after pause
					saved, err = w.processAndSaveRecipe(ctx, raw)
				}
				if err != nil {
					log.Printf("[RecipeWorker] [WARN] Failed to process %q: %v. Skipping.", raw.Title, err)
					continue
				}
			}

			if saved {
				subBatchCount++
				updatedCount, _ := w.queries.CountTotalRecipes(ctx)
				log.Printf("[RecipeWorker] [DB] Successfully saved %q. Total in DB: %d/%d", raw.Title, updatedCount, w.workerCfg.TargetTotal)
			}

			if subBatchCount >= w.workerCfg.SubBatchSize {
				log.Printf("[RecipeWorker] Sub-batch of %d recipes processed. Pausing for %v to respect API rate limits...",
					subBatchCount, w.workerCfg.SubBatchPause)
				subBatchCount = 0
				if !w.sleepInterruptible(w.workerCfg.SubBatchPause) {
					return
				}
			}
		}

		log.Printf("[RecipeWorker] Chunk processing finished. Preparing next cycle...")
		if !w.sleepInterruptible(5 * time.Second) {
			return
		}
	}
}

func (w *RecipeWorker) sleepInterruptible(d time.Duration) bool {
	select {
	case <-w.stopChan:
		return false
	case <-time.After(d):
		return true
	}
}

func (w *RecipeWorker) fetchCandidatesChunk(ctx context.Context, startOffset, chunkSize int) ([]rawCandidateRecipe, int) {
	var candidates []rawCandidateRecipe
	offset := startOffset
	maxAttempts := chunkSize * 5 // allow searching through gaps

	for len(candidates) < chunkSize && offset < startOffset+maxAttempts {
		select {
		case <-w.stopChan:
			return candidates, offset
		default:
		}

		recipeID := 10000 + offset
		folderID := recipeID / 100
		offset++

		// 1. Try local file if repository clone exists
		var data []byte
		localPath := filepath.Join("tmp", "recipes-repo", "storage", "recipes", strconv.Itoa(folderID), fmt.Sprintf("%d.json", recipeID))
		if fData, err := os.ReadFile(localPath); err == nil {
			data = fData
		} else {
			// Try parent directory
			localPath = filepath.Join("..", "tmp", "recipes-repo", "storage", "recipes", strconv.Itoa(folderID), fmt.Sprintf("%d.json", recipeID))
			if fData, err := os.ReadFile(localPath); err == nil {
				data = fData
			}
		}

		// 2. Fall back to GitHub raw URL
		if len(data) == 0 {
			url := fmt.Sprintf("https://raw.githubusercontent.com/chipslays/russian-recipes-parser/master/storage/recipes/%d/%d.json", folderID, recipeID)
			req, err := http.NewRequestWithContext(ctx, "GET", url, nil)
			if err != nil {
				continue
			}
			resp, err := w.httpClient.Do(req)
			if err != nil || resp.StatusCode != http.StatusOK {
				if resp != nil {
					_ = resp.Body.Close()
				}
				continue
			}
			data, _ = io.ReadAll(resp.Body)
			_ = resp.Body.Close()
		}

		if len(data) == 0 {
			continue
		}

		var raw rawCandidateRecipe
		if err := json.Unmarshal(data, &raw); err != nil {
			continue
		}

		raw.Title = strings.TrimSpace(raw.Title)
		if raw.Title == "" {
			continue
		}

		totalIngs := 0
		for _, g := range raw.Ingredients {
			totalIngs += len(g.List)
		}
		if totalIngs < 3 {
			continue
		}

		// Check if recipe already exists in database
		_, err := w.queries.GetRecipeByTitle(ctx, raw.Title)
		if err == nil {
			// already in DB, skip
			continue
		}

		candidates = append(candidates, raw)
	}

	return candidates, offset
}

type rateLimitError struct {
	StatusCode int
	Message    string
}

func (e *rateLimitError) Error() string {
	return fmt.Sprintf("rate limit / quota exceeded (%d): %s", e.StatusCode, e.Message)
}

func (w *RecipeWorker) ensureGigaChatToken() (string, error) {
	w.mu.Lock()
	defer w.mu.Unlock()

	now := time.Now().Unix()
	if w.token != "" && w.tokenExpiresAt > now+60 {
		return w.token, nil
	}

	if w.gigaChatCfg.AuthKey == "" {
		return "", errors.New("GIGACHAT_AUTH_KEY is not configured")
	}

	form := url.Values{}
	form.Set("scope", w.gigaChatCfg.Scope)

	req, err := http.NewRequest("POST", "https://ngw.devices.sberbank.ru:9443/api/v2/oauth", strings.NewReader(form.Encode()))
	if err != nil {
		return "", err
	}
	req.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	req.Header.Set("Accept", "application/json")
	req.Header.Set("RqUID", generateUUID())
	req.Header.Set("Authorization", "Basic "+w.gigaChatCfg.AuthKey)

	resp, err := w.httpClient.Do(req)
	if err != nil {
		return "", fmt.Errorf("oauth request failed: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode == 429 || resp.StatusCode == 402 {
		body, _ := io.ReadAll(resp.Body)
		return "", &rateLimitError{StatusCode: resp.StatusCode, Message: string(body)}
	}

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("oauth failed (%d): %s", resp.StatusCode, string(body))
	}

	var authResp struct {
		AccessToken string `json:"access_token"`
		ExpiresAt   int64  `json:"expires_at"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&authResp); err != nil {
		return "", err
	}

	w.token = authResp.AccessToken
	w.tokenExpiresAt = authResp.ExpiresAt
	return w.token, nil
}

func (w *RecipeWorker) normalizeRecipeWithGigaChat(ctx context.Context, raw *rawCandidateRecipe, instructions []string) (*normalizedRecipeOutput, error) {
	token, err := w.ensureGigaChatToken()
	if err != nil {
		return nil, err
	}

	var ingLines []string
	for _, grp := range raw.Ingredients {
		for _, item := range grp.List {
			val := ""
			if item.Value != nil {
				val = *item.Value
			}
			unit := ""
			if item.Type != nil {
				unit = *item.Type
			}
			ingLines = append(ingLines, fmt.Sprintf("- %s: %s %s", item.Name, val, unit))
		}
	}

	rawTime := ""
	if raw.CookTime != nil {
		rawTime = *raw.CookTime
	}
	rawDiff := ""
	if raw.Difficulty != nil {
		rawDiff = *raw.Difficulty
	}

	prompt := fmt.Sprintf(`Нормализуй рецепт в JSON для базы данных:
{
  "cooking_time_minutes": <целое число минут>,
  "difficulty": <"легко" | "средне" | "сложно">,
  "ingredients": [
    {
      "name": <каноническое название продукта в нижнем регистре на русском языке, например "картофель", "куриное филе", "соль">,
      "category": <"Овощи и зелень" | "Мясо и птица" | "Рыба и морепродукты" | "Молочные продукты" | "Крупы и мука" | "Специи" | "Бакалея и соусы" | "Фрукты и ягоды" | "Другое">,
      "amount": <число или null>,
      "unit": <строка или null, например "г", "мл", "шт", "ст. л.">,
      "display_text": <красивый текст количества, например "500 г", "2 шт.", "по вкусу">,
      "criticality": <"основной" | "важный" | "опциональный">
    }
  ]
}

Рецепт:
Название: %s
Категория: %s
Сложность: %s
Время: %s
Ингредиенты:
%s
Шаги:
%s`, raw.Title, raw.Category, rawDiff, rawTime, strings.Join(ingLines, "\n"), strings.Join(instructions, "\n"))

	reqBody := struct {
		Model       string `json:"model"`
		Messages    []struct {
			Role    string `json:"role"`
			Content string `json:"content"`
		} `json:"messages"`
		Temperature float64 `json:"temperature"`
	}{
		Model: w.gigaChatCfg.Model,
		Messages: []struct {
			Role    string `json:"role"`
			Content string `json:"content"`
		}{
			{
				Role:    "system",
				Content: "Ты кулинарный эксперт WhatCook. Отвечай ТОЛЬКО валидным JSON без markdown-разметки.",
			},
			{
				Role:    "user",
				Content: prompt,
			},
		},
		Temperature: 0.1,
	}

	jsonBytes, err := json.Marshal(reqBody)
	if err != nil {
		return nil, err
	}

	req, err := http.NewRequestWithContext(ctx, "POST", "https://gigachat.devices.sberbank.ru/api/v1/chat/completions", bytes.NewReader(jsonBytes))
	if err != nil {
		return nil, err
	}
	req.Header.Set("Content-Type", "application/json")
	req.Header.Set("Accept", "application/json")
	req.Header.Set("Authorization", "Bearer "+token)

	resp, err := w.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode == 429 || resp.StatusCode == 402 {
		body, _ := io.ReadAll(resp.Body)
		return nil, &rateLimitError{StatusCode: resp.StatusCode, Message: string(body)}
	}

	if resp.StatusCode != http.StatusOK {
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("gigachat completion failed (%d): %s", resp.StatusCode, string(body))
	}

	var compResp struct {
		Choices []struct {
			Message struct {
				Content string `json:"content"`
			} `json:"message"`
		} `json:"choices"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&compResp); err != nil {
		return nil, err
	}

	if len(compResp.Choices) == 0 {
		return nil, errors.New("empty response from gigachat")
	}

	rawJSON := cleanJSONResponse(compResp.Choices[0].Message.Content)
	var output normalizedRecipeOutput
	if err := json.Unmarshal([]byte(rawJSON), &output); err != nil {
		return nil, fmt.Errorf("failed to parse gigachat json: %w", err)
	}

	return &output, nil
}

func (w *RecipeWorker) processAndSaveRecipe(ctx context.Context, raw rawCandidateRecipe) (bool, error) {
	instructions := parseRawInstructions(raw.Instruction)
	if len(instructions) == 0 {
		return false, errors.New("empty instructions")
	}

	// 1. Call GigaChat to normalize
	norm, err := w.normalizeRecipeWithGigaChat(ctx, &raw, instructions)
	if err != nil {
		return false, err
	}

	// 2. Sanitize difficulty and cooking time
	diff := strings.ToLower(strings.TrimSpace(norm.Difficulty))
	if diff != "легко" && diff != "средне" && diff != "сложно" {
		diff = "средне"
	}

	cookTime := norm.CookingTimeMinutes
	if cookTime <= 0 {
		cookTime = 30
	}

	// 3. Assign reliable curated image URL
	curatedImage := GetCuratedRecipeImage(raw.Title, raw.Category)

	// 4. Save recipe to database
	instrJSON, err := json.Marshal(instructions)
	if err != nil {
		return false, err
	}

	categoryDesc := strings.TrimSpace(raw.Category)
	if categoryDesc == "" {
		categoryDesc = "Вторые блюда"
	}

	dbRecipe, err := w.queries.CreateRecipe(ctx, store.CreateRecipeParams{
		Title:              raw.Title,
		Description:        pgtype.Text{String: categoryDesc, Valid: true},
		Instructions:       instrJSON,
		CookingTimeMinutes: int32(cookTime),
		Difficulty:         diff,
		ImageUrl:           pgtype.Text{String: curatedImage, Valid: true},
	})
	if err != nil {
		return false, fmt.Errorf("failed to insert recipe: %w", err)
	}

	// 5. Ensure ingredients exist and link them
	seenIngs := make(map[string]bool)
	for _, ing := range norm.Ingredients {
		name := strings.ToLower(strings.TrimSpace(ing.Name))
		if name == "" || seenIngs[name] {
			continue
		}
		seenIngs[name] = true

		cat := strings.TrimSpace(ing.Category)
		if cat == "" {
			cat = "Другое"
		}
		defUnit := "г"
		if ing.Unit != nil && strings.TrimSpace(*ing.Unit) != "" {
			defUnit = strings.TrimSpace(*ing.Unit)
		}

		dbIng, err := w.queries.GetIngredientByNameCaseInsensitive(ctx, name)
		if err != nil {
			// Doesn't exist, create it
			dbIng, err = w.queries.CreateIngredient(ctx, store.CreateIngredientParams{
				Name:              name,
				Category:          cat,
				DefaultUnit:       defUnit,
				IsPantryEssential: false,
			})
			if err != nil {
				// Could have been inserted concurrently, retry lookup
				dbIng, _ = w.queries.GetIngredientByNameCaseInsensitive(ctx, name)
			}
		}

		if dbIng.ID == 0 {
			continue
		}

		var amountNumeric pgtype.Numeric
		if ing.Amount != nil {
			_ = amountNumeric.Scan(strconv.FormatFloat(*ing.Amount, 'f', -1, 64))
		}

		var unitText pgtype.Text
		if ing.Unit != nil && strings.TrimSpace(*ing.Unit) != "" {
			unitText = pgtype.Text{String: strings.TrimSpace(*ing.Unit), Valid: true}
		}

		displayText := strings.TrimSpace(ing.DisplayText)
		if displayText == "" {
			displayText = "по вкусу"
		}

		crit := strings.ToLower(strings.TrimSpace(ing.Criticality))
		if crit != "основной" && crit != "важный" && crit != "опциональный" {
			crit = "важный"
		}

		_, _ = w.queries.AddRecipeIngredient(ctx, store.AddRecipeIngredientParams{
			RecipeID:     dbRecipe.ID,
			IngredientID: dbIng.ID,
			Amount:       amountNumeric,
			Unit:         unitText,
			DisplayText:  pgtype.Text{String: displayText, Valid: true},
			Criticality:  crit,
		})
	}

	return true, nil
}

func parseRawInstructions(raw json.RawMessage) []string {
	var steps []string
	var stepObjs []struct {
		Text string `json:"text"`
	}
	if err := json.Unmarshal(raw, &stepObjs); err == nil && len(stepObjs) > 0 {
		for _, s := range stepObjs {
			txt := strings.TrimSpace(s.Text)
			if txt != "" {
				steps = append(steps, txt)
			}
		}
		if len(steps) > 0 {
			return steps
		}
	}

	var strSteps []string
	if err := json.Unmarshal(raw, &strSteps); err == nil && len(strSteps) > 0 {
		for _, s := range strSteps {
			txt := strings.TrimSpace(s)
			if txt != "" {
				steps = append(steps, txt)
			}
		}
	}
	return steps
}

func cleanJSONResponse(raw string) string {
	raw = strings.TrimSpace(raw)
	if idx := strings.Index(raw, "{"); idx != -1 {
		if lastIdx := strings.LastIndex(raw, "}"); lastIdx != -1 && lastIdx > idx {
			raw = raw[idx : lastIdx+1]
		}
	}
	return strings.TrimSpace(raw)
}

func generateUUID() string {
	b := make([]byte, 16)
	_, _ = rand.Read(b)
	b[6] = (b[6] & 0x0f) | 0x40
	b[8] = (b[8] & 0x3f) | 0x80
	return fmt.Sprintf("%08x-%04x-%04x-%04x-%012x", b[0:4], b[4:6], b[6:8], b[8:10], b[10:16])
}

// GetCuratedRecipeImage assigns a reliable, high-resolution food image from Unsplash Food CDN.
func GetCuratedRecipeImage(title, category string) string {
	t := strings.ToLower(title)
	c := strings.ToLower(category)

	switch {
	case strings.Contains(t, "борщ"):
		return "https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "суп") || strings.Contains(t, "солянк") || strings.Contains(t, "рассольник") || strings.Contains(c, "суп"):
		return "https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "рыб") || strings.Contains(t, "скумбри") || strings.Contains(t, "горбуш") || strings.Contains(t, "лосос") || strings.Contains(t, "креветк"):
		return "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "куриц") || strings.Contains(t, "курин") || strings.Contains(t, "цыпленок") || strings.Contains(t, "индейк"):
		return "https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "говядин") || strings.Contains(t, "свинин") || strings.Contains(t, "мяс") || strings.Contains(t, "гуляш") || strings.Contains(t, "печен"):
		return "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "лазань") || strings.Contains(t, "паст") || strings.Contains(t, "макарон"):
		return "https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "салат") || strings.Contains(c, "салат"):
		return "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "сырник") || strings.Contains(t, "чипс") || strings.Contains(t, "рулет") || strings.Contains(t, "омлет") || strings.Contains(c, "закуск"):
		return "https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "рогалик") || strings.Contains(t, "пирог") || strings.Contains(t, "хлеб") || strings.Contains(c, "выпечк"):
		return "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "чизкейк") || strings.Contains(t, "пудинг") || strings.Contains(t, "маршмеллоу") || strings.Contains(t, "нутелл") || strings.Contains(c, "десерт"):
		return "https://images.unsplash.com/photo-1587314168485-3236d6710814?auto=format&fit=crop&w=660&q=80"
	default:
		return "https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=660&q=80"
	}
}
