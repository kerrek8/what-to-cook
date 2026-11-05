package service

import (
	"bytes"
	"context"
	"crypto/rand"
	"crypto/sha256"
	"crypto/tls"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"log"
	"net/http"
	"net/url"
	"regexp"
	"strconv"
	"strings"
	"sync"
	"time"

	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/config"
	"github.com/kerrek8/what-to-cook/backend/internal/storage"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var imgTagRegex = regexp.MustCompile(`<img[^>]+src="([a-f0-9\-]+)"`)

type RecipeWorker struct {
	queries        store.Querier
	gigaChatCfg    config.GigaChatConfig
	workerCfg      config.RecipeWorkerConfig
	storage        storage.Storage
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
	ImagePrompt        string                       `json:"image_prompt"`
	Ingredients        []normalizedRecipeIngredient `json:"ingredients"`
}

func RecipeImageFilename(title string) string {
	h := sha256.Sum256([]byte(strings.ToLower(strings.TrimSpace(title))))
	return fmt.Sprintf("recipe_%x.jpg", h[:8])
}

func NewRecipeWorker(queries store.Querier, gigaChatCfg config.GigaChatConfig, workerCfg config.RecipeWorkerConfig, store storage.Storage) *RecipeWorker {
	if store == nil {
		store = storage.NewLocalStorage("./uploads", "/uploads")
	}
	tr := &http.Transport{
		TLSClientConfig:   &tls.Config{InsecureSkipVerify: !gigaChatCfg.VerifySSL},
		DisableKeepAlives: true,
	}
	return &RecipeWorker{
		queries:     queries,
		gigaChatCfg: gigaChatCfg,
		workerCfg:   workerCfg,
		storage:     store,
		httpClient: &http.Client{
			Transport: tr,
			Timeout:   150 * time.Second,
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
		if int(count) >= w.workerCfg.TargetTotal {
			log.Printf("[RecipeWorker] Target total reached (%d/%d). Sleeping for 1 hour...", count, w.workerCfg.TargetTotal)
			if !w.sleepInterruptible(1 * time.Hour) {
				return
			}
			continue
		}

		needed := w.workerCfg.TargetTotal - int(count)
		fetchLimit := w.workerCfg.ChunkSize
		if fetchLimit > needed {
			fetchLimit = needed
		}

		log.Printf("[RecipeWorker] Fetching chunk of up to %d candidate recipes (offset: %d)...", fetchLimit, currentOffset)
		candidates, nextOffset := w.fetchCandidatesChunk(ctx, currentOffset, fetchLimit)
		if len(candidates) == 0 {
			log.Printf("[RecipeWorker] No new candidates found or end of dataset reached. Resetting offset to 1 and pausing 15 min...")
			currentOffset = 1
			if !w.sleepInterruptible(15 * time.Minute) {
				return
			}
			continue
		}

		currentOffset = nextOffset
		log.Printf("[RecipeWorker] Found %d valid candidates to process. Starting sub-batches...", len(candidates))

		subBatchCount := 0
		for idx, candidate := range candidates {
			select {
			case <-w.stopChan:
				return
			default:
			}

			log.Printf("[RecipeWorker] Processing candidate %d/%d: '%s'...", idx+1, len(candidates), candidate.Title)
			saved, err := w.processAndSaveRecipe(ctx, candidate)
			if err != nil {
				var rle *rateLimitError
				if errors.As(err, &rle) {
					log.Printf("[RecipeWorker] Rate limit or quota reached (%d): %s. Pausing worker for %v...", rle.StatusCode, rle.Message, w.workerCfg.RateLimitPause)
					if !w.sleepInterruptible(w.workerCfg.RateLimitPause) {
						return
					}
					continue
				}
				log.Printf("[RecipeWorker] Failed to process recipe '%s': %v. Skipping to retry later.", candidate.Title, err)
				continue
			}

			if saved {
				log.Printf("[RecipeWorker] Successfully saved recipe '%s'", candidate.Title)
				subBatchCount++
				if subBatchCount >= w.workerCfg.SubBatchSize {
					log.Printf("[RecipeWorker] Finished sub-batch of %d recipes. Pausing for %v to respect rate limits...", subBatchCount, w.workerCfg.SubBatchPause)
					subBatchCount = 0
					if !w.sleepInterruptible(w.workerCfg.SubBatchPause) {
						return
					}
				} else {
					if !w.sleepInterruptible(50 * time.Second) {
						return
					}
				}
			}
		}

		log.Printf("[RecipeWorker] Finished chunk. Checking total count again...")
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

func (w *RecipeWorker) fetchCandidatesChunk(ctx context.Context, startOffset, limit int) ([]rawCandidateRecipe, int) {
	var candidates []rawCandidateRecipe
	offset := startOffset

	for len(candidates) < limit {
		select {
		case <-w.stopChan:
			return candidates, offset
		default:
		}

		fileNum := offset
		offset++
		urlStr := fmt.Sprintf("https://raw.githubusercontent.com/chipslays/russian-recipes-parser/master/recipes/%d.json", fileNum)

		req, err := http.NewRequestWithContext(ctx, "GET", urlStr, nil)
		if err != nil {
			continue
		}

		resp, err := w.httpClient.Do(req)
		if err != nil {
			continue
		}

		if resp.StatusCode == 404 {
			resp.Body.Close()
			break
		}

		if resp.StatusCode != http.StatusOK {
			resp.Body.Close()
			continue
		}

		var raw rawCandidateRecipe
		err = json.NewDecoder(resp.Body).Decode(&raw)
		resp.Body.Close()
		if err != nil {
			continue
		}

		raw.Title = strings.TrimSpace(raw.Title)
		if raw.Title == "" {
			continue
		}

		instructions := parseRawInstructions(raw.Instruction)
		if len(instructions) == 0 {
			continue
		}

		totalIngs := 0
		for _, g := range raw.Ingredients {
			totalIngs += len(g.List)
		}
		if totalIngs < 3 {
			continue
		}

		_, err = w.queries.GetRecipeByTitle(ctx, raw.Title)
		if err == nil {
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

	now := time.Now().UnixMilli()
	exp := w.tokenExpiresAt
	if exp < 10_000_000_000 {
		exp *= 1000
	}
	if w.token != "" && exp > now+60_000 {
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

	if resp.StatusCode == 401 {
		w.mu.Lock()
		w.token = ""
		w.mu.Unlock()
		body, _ := io.ReadAll(resp.Body)
		return "", fmt.Errorf("gigachat auth expired (401): %s", string(body))
	}

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
  "image_prompt": <детальный кулинарный промпт на английском языке для генерации обложки блюда нейросетью FLUX, например "Close-up gourmet food photography of freshly baked pineapple upside down cake with caramelized pineapple rings and cherries, golden fluffy crumb, restaurant dessert plate, warm soft morning sunlight, shallow depth of field, 8k, professional food styling">,
  "ingredients": [
    {
      "name": <каноническое название продукта в нижнем регистре на русском, например "картофель", "морковь", "куриное филе">,
      "category": <одна из: "Овощи и зелень" | "Фрукты и ягоды" | "Мясо и птица" | "Рыба и морепродукты" | "Молочные продукты" | "Бакалея" | "Соусы и приправы" | "Выпечка и десерты" | "Напитки" | "Другое">,
      "amount": <число или null>,
      "unit": <единица измерения или null>,
      "display_text": <исходный читаемый текст, например "2 шт", "300 г", "по вкусу">,
      "criticality": <"основной" | "важный" | "опциональный">
    }
  ]
}

Название: %s
Категория: %s
Исходная сложность: %s
Исходное время: %s
Ингредиенты:
%s
Инструкции:
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
				Content: "Ты шеф-повар и гастрономический фотограф WhatCook. Отвечай ТОЛЬКО валидным JSON без markdown-разметки.",
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

	if resp.StatusCode == 401 {
		w.mu.Lock()
		w.token = ""
		w.mu.Unlock()
		body, _ := io.ReadAll(resp.Body)
		return nil, fmt.Errorf("gigachat auth expired (401): %s", string(body))
	}

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

func cleanTitleForImagePrompt(title string) string {
	t := strings.TrimSpace(title)
	t = strings.ReplaceAll(t, "«", "")
	t = strings.ReplaceAll(t, "»", "")
	t = strings.ReplaceAll(t, "\"", "")
	t = strings.ReplaceAll(t, "'", "")
	return t
}

var curatedRecipeImages = map[string]string{
	"скумбрия с лимоном на решетке на углях":                        "https://images.unsplash.com/photo-1534482421-64566f976cfa?auto=format&fit=crop&w=800&q=80",
	"цыпленок в чесночно-масляном маринаде на углях":                "https://images.unsplash.com/photo-1598103442097-8b74394b95c6?auto=format&fit=crop&w=800&q=80",
	"очень вкусные креветки под сливочным соусом":                   "https://images.unsplash.com/photo-1559742811-822873691df8?auto=format&fit=crop&w=800&q=80",
	"сочное куриное филе на скорую руку":                            "https://images.unsplash.com/photo-1604908176997-125f25cc6f3d?auto=format&fit=crop&w=800&q=80",
	"курица с ананасом в кисло-сладком соусе":                       "https://images.unsplash.com/photo-1525755662778-989d0524087e?auto=format&fit=crop&w=800&q=80",
	"свинина в сливочно-грибном соусе со специями":                  "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2d/Pork_Chop_with_sweet_potato_mash_and_mushrooms_in_a_demerara_sauce._%2836249946845%29.jpg/800px-Pork_Chop_with_sweet_potato_mash_and_mushrooms_in_a_demerara_sauce._%2836249946845%29.jpg",
	"азу из филе индейки в сметанном соусе":                         "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=800&q=80",
	"азу из индейки со сметаной и соевым соусом":                    "https://images.unsplash.com/photo-1512058564366-18510be2db19?auto=format&fit=crop&w=800&q=80",
	"говядина сигурени по-японски":                                  "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=800&q=80",
	"лазанья болоньезе с мясным фаршем и соусом бешамель":          "https://images.unsplash.com/photo-1574894709920-11b28e7367e3?auto=format&fit=crop&w=800&q=80",
	"испанский омлет тортилья с картошкой и луком":                  "https://upload.wikimedia.org/wikipedia/commons/thumb/6/6d/Tortilla_espa%C3%B1ola_con_patatas_y_cebolla.jpg/800px-Tortilla_espa%C3%B1ola_con_patatas_y_cebolla.jpg",
	"весенний салат из молодой капусты, огурца и зелени":            "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d5/CabbageSalad.jpg/800px-CabbageSalad.jpg",
	"салат грибная поляна с шампиньонами и отварной курицей":        "https://images.unsplash.com/photo-1540420773420-3366772f4999?auto=format&fit=crop&w=800&q=80",
	"салат «нежность» с куриным филе и грибами":                     "https://images.unsplash.com/photo-1505253758473-96b3d5eb926f?auto=format&fit=crop&w=800&q=80",
	"салат «изумрудный» с ветчиной и сыром":                         "https://images.unsplash.com/photo-1546793665-c74683f339c1?auto=format&fit=crop&w=800&q=80",
	"салат из куриной грудки с кукурузой и морковью по-корейски":   "https://images.unsplash.com/photo-1550304943-4f24f54ddde9?auto=format&fit=crop&w=800&q=80",
	"салат красное море с крабовыми палочками и болгарским перцем": "https://images.unsplash.com/photo-1543339308-43e59d6b73a6?auto=format&fit=crop&w=800&q=80",
	"праздничный слоеный салат с курицей, грибами, сыром и яйцом":  "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=800&q=80",
	"сырный рулет со свиным фаршем":                                 "https://images.unsplash.com/photo-1628294895950-9805252327bc?auto=format&fit=crop&w=800&q=80",
	"домашние чипсы с зеленью в духовке":                            "https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=800&q=80",
	"торт из говяжьей печени с зеленью":                             "https://images.unsplash.com/photo-1584947921538-261657523910?auto=format&fit=crop&w=800&q=80",
	"торт из говяжьей печени с грибной начинкой":                    "https://images.unsplash.com/photo-1504674900247-0877df9cc836?auto=format&fit=crop&w=800&q=80",
	"торт из говяжьей печени с плавленым сыром":                     "https://images.unsplash.com/photo-1541544741938-0af808871cc0?auto=format&fit=crop&w=800&q=80",
	"рогалики из дрожжевого теста на молоке с повидлом":             "https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=800&q=80",
	"японский чизкейк с повидлом":                                   "https://images.unsplash.com/photo-1524351199678-941a58a3df50?auto=format&fit=crop&w=800&q=80",
	"рогалики из дрожжевого теста с замороженной вишней":            "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=800&q=80",
	"классические рогалики из дрожжевого теста с маком":             "https://images.unsplash.com/photo-1608198093002-ad4e005484ec?auto=format&fit=crop&w=800&q=80",
	"маршмеллоу из сахара, желатина и воды":                         "https://images.unsplash.com/photo-1582293041079-7814c2f12063?auto=format&fit=crop&w=800&q=80",
	"шоколадная паста «нутелла» с орехами":                          "https://images.unsplash.com/photo-1589733955941-5eeaf752f6dd?auto=format&fit=crop&w=800&q=80",
	"рисовый пудинг с орехами, изюмом и специями":                   "https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?auto=format&fit=crop&w=800&q=80",
	"суп с мини-фрикадельками из индейки":                           "https://images.unsplash.com/photo-1603105037880-880cd4edfb0d?auto=format&fit=crop&w=800&q=80",
	"венгерский суп гуляш бограч с говядиной":                       "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8f/Gulasch_wp.JPG/800px-Gulasch_wp.JPG",
	"борщ на свиных косточках в казане на костре":                   "https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=800&q=80",
	"рассольник с перловой крупой без мяса":                         "https://images.unsplash.com/photo-1578020190125-f4f7c18bc9cb?auto=format&fit=crop&w=800&q=80",
	"японский мисо-суп с зеленью":                                   "https://images.unsplash.com/photo-1555126634-323283e090fa?auto=format&fit=crop&w=800&q=80",
	"мисо-суп со свининой и грибами":                                "https://images.unsplash.com/photo-1569718212165-3a8278d5f624?auto=format&fit=crop&w=800&q=80",
	"простой мисо-суп с вакаме и тофу":                              "https://images.unsplash.com/photo-1617093727343-374698b1b08d?auto=format&fit=crop&w=800&q=80",
}

var recipeSearchQueries = map[string]string{
	"скумбрия с лимоном на решетке на углях":                        "Grilled mackerel with lemon",
	"цыпленок в чесночно-масляном маринаде на углях":                "Grilled chicken garlic",
	"очень вкусные креветки под сливочным соусом":                   "Shrimp in creamy sauce",
	"сочное куриное филе на скорую руку":                            "Pan seared chicken breast",
	"курица с ананасом в кисло-сладком соусе":                       "Sweet and sour chicken with pineapple",
	"свинина в сливочно-грибном соусе со специями":                  "Pork Chop with sweet potato mash and mushrooms",
	"азу из филе индейки в сметанном соусе":                         "Turkey stew in sauce",
	"азу из индейки со сметаной и соевым соусом":                    "Stir fry turkey dish",
	"говядина сигурени по-японски":                                  "Gyudon beef bowl",
	"лазанья болоньезе с мясным фаршем и соусом бешамель":          "Lasagne bolognese",
	"испанский омлет тортилья с картошкой и луком":                  "Tortilla española con patatas y cebolla",
	"весенний салат из молодой капусты, огурца и зелени":            "Cabbage salad",
	"салат грибная поляна с шампиньонами и отварной курицей":        "Layered salad with mushrooms",
	"салат «нежность» с куриным филе и грибами":                     "Chicken and mushroom salad",
	"салат «изумрудный» с ветчиной и сыром":                         "Ham and cheese salad cucumber",
	"салат из куриной грудки с кукурузой и морковью по-корейски":   "Chicken and sweet corn salad",
	"салат красное море с крабовыми палочками и болгарским перцем": "Crab stick salad",
	"праздничный слоеный салат с курицей, грибами, сыром и яйцом":  "Layered chicken salad",
	"сырный рулет со свиным фаршем":                                 "Meatloaf with cheese filling",
	"домашние чипсы с зеленью в духовке":                            "Potato chips bowl",
	"торт из говяжьей печени с зеленью":                             "Liver cake layered",
	"торт из говяжьей печени с грибной начинкой":                    "Savory liver pate with mushrooms",
	"торт из говяжьей печени с плавленым сыром":                     "Savory liver terrine",
	"рогалики из дрожжевого теста на молоке с повидлом":             "Rugelach pastry",
	"японский чизкейк с повидлом":                                   "Japanese souffle cheesecake",
	"рогалики из дрожжевого теста с замороженной вишней":            "Cherry croissant pastry",
	"классические рогалики из дрожжевого теста с маком":             "Poppy seed pastry roll",
	"маршмеллоу из сахара, желатина и воды":                         "Marshmallows bowl",
	"шоколадная паста «нутелла» с орехами":                          "Chocolate hazelnut spread jar",
	"рисовый пудинг с орехами, изюмом и специями":                   "Rice pudding with raisins and nuts",
	"суп с мини-фрикадельками из индейки":                           "Meatball soup bowl",
	"венгерский суп гуляш бограч с говядиной":                       "Goulash soup in bowl",
	"борщ на свиных косточках в казане на костре":                   "Borscht soup in bowl with sour cream",
	"рассольник с перловой крупой без мяса":                         "Rassolnik soup bowl",
	"японский мисо-суп с зеленью":                                   "Miso soup with green onion",
	"мисо-суп со свининой и грибами":                                "Tonjiru pork miso soup",
	"простой мисо-суп с вакаме и тофу":                              "Miso soup with tofu and wakame",
}

func getSearchQueryForRecipe(title string) string {
	clean := strings.ToLower(cleanTitleForImagePrompt(title))
	if q, ok := recipeSearchQueries[clean]; ok {
		return q
	}
	return cleanTitleForImagePrompt(title)
}

func searchWikimediaImage(ctx context.Context, client *http.Client, title string) string {
	query := getSearchQueryForRecipe(title)
	apiURL := fmt.Sprintf("https://commons.wikimedia.org/w/api.php?action=query&generator=search&gsrsearch=%s&gsrnamespace=6&gsrlimit=3&prop=imageinfo&iiprop=url|mime&iiurlwidth=800&format=json",
		url.QueryEscape(query+" filetype:bitmap"))

	req, err := http.NewRequestWithContext(ctx, "GET", apiURL, nil)
	if err != nil {
		return ""
	}
	req.Header.Set("User-Agent", "WhatCookBot/1.0 (contact@whatcook.app)")

	resp, err := client.Do(req)
	if err != nil {
		return ""
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return ""
	}

	var wikiResp struct {
		Query struct {
			Pages map[string]struct {
				ImageInfo []struct {
					URL      string `json:"url"`
					ThumbURL string `json:"thumburl"`
					Mime     string `json:"mime"`
				} `json:"imageinfo"`
			} `json:"pages"`
		} `json:"query"`
	}

	if err := json.NewDecoder(resp.Body).Decode(&wikiResp); err != nil {
		return ""
	}

	for _, page := range wikiResp.Query.Pages {
		if len(page.ImageInfo) > 0 {
			info := page.ImageInfo[0]
			u := info.ThumbURL
			if u == "" {
				u = info.URL
			}
			if u != "" && !strings.HasSuffix(u, ".svg") && !strings.Contains(u, ".pdf") {
				return u
			}
		}
	}
	return ""
}

// FetchRecipeImage searches for authentic food photography via Wikimedia Commons API (or curated fallback)
// and optimizes it to 512x512 JPEG at 75 quality to save >65% disk space.
func (w *RecipeWorker) FetchRecipeImage(ctx context.Context, title string) ([]byte, error) {
	imgURL := searchWikimediaImage(ctx, w.httpClient, title)
	if imgURL == "" {
		imgURL = GetCuratedRecipeImage(title, "")
	}

	req, err := http.NewRequestWithContext(ctx, "GET", imgURL, nil)
	if err != nil {
		return nil, err
	}
	req.Header.Set("User-Agent", "WhatCookBot/1.0 (contact@whatcook.app)")

	resp, err := w.httpClient.Do(req)
	if err != nil {
		return nil, fmt.Errorf("failed to download recipe image: %w", err)
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("downloading recipe image failed (%d)", resp.StatusCode)
	}

	rawImgBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("failed to read recipe image body: %w", err)
	}

	optBytes, err := storage.OptimizeRecipeImage(rawImgBytes)
	if err != nil {
		return nil, fmt.Errorf("failed to optimize recipe image: %w", err)
	}

	return optBytes, nil
}

// GenerateFluxImage generates a high-definition food photograph using the FLUX.1 engine (with fallback to curated/Wikimedia photos)
// and optimizes it to a 512x512 JPEG at 75 quality to save >65% disk space.
func (w *RecipeWorker) GenerateFluxImage(ctx context.Context, title, imagePrompt string) ([]byte, error) {
	prompt := strings.TrimSpace(imagePrompt)
	if prompt == "" {
		prompt = fmt.Sprintf("Close-up gourmet food photography of appetizing %s, beautifully plated, restaurant setting, soft warm directional lighting, depth of field, high resolution", cleanTitleForImagePrompt(title))
	}

	fluxURL := fmt.Sprintf("https://image.pollinations.ai/prompt/%s?model=flux&width=512&height=512&nologo=true", url.PathEscape(prompt))

	req, err := http.NewRequestWithContext(ctx, "GET", fluxURL, nil)
	if err == nil {
		req.Header.Set("User-Agent", "WhatCookBot/1.0 (contact@whatcook.app)")
		req.Header.Set("Accept", "image/jpeg, image/png, */*")

		resp, err := w.httpClient.Do(req)
		if err == nil {
			defer resp.Body.Close()
			if resp.StatusCode == http.StatusOK {
				rawImgBytes, err := io.ReadAll(resp.Body)
				if err == nil && len(rawImgBytes) > 0 {
					optBytes, err := storage.OptimizeRecipeImage(rawImgBytes)
					if err == nil {
						return optBytes, nil
					}
					log.Printf("[RecipeWorker] Warning: failed to optimize FLUX image for '%s': %v", title, err)
				}
			} else {
				log.Printf("[RecipeWorker] Warning: FLUX generation returned status %d for '%s', falling back", resp.StatusCode, title)
			}
		} else {
			log.Printf("[RecipeWorker] Warning: FLUX request failed for '%s': %v, falling back", title, err)
		}
	}

	return w.FetchRecipeImage(ctx, title)
}

// GenerateKandinskyImage is maintained for backwards compatibility and delegates to GenerateFluxImage.
func (w *RecipeWorker) GenerateKandinskyImage(ctx context.Context, title string) ([]byte, error) {
	return w.GenerateFluxImage(ctx, title, "")
}

func (w *RecipeWorker) processAndSaveRecipe(ctx context.Context, raw rawCandidateRecipe) (bool, error) {
	instructions := parseRawInstructions(raw.Instruction)
	if len(instructions) == 0 {
		return false, errors.New("empty instructions")
	}

	// 1. Call GigaChat to normalize and generate image prompt
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

	// 3. Generate image via FLUX (or fallback) using GigaChat's prompt
	imgBytes, err := w.GenerateFluxImage(ctx, raw.Title, norm.ImagePrompt)
	if err != nil {
		return false, fmt.Errorf("failed to generate image for '%s': %w", raw.Title, err)
	}

	fileName := RecipeImageFilename(raw.Title)
	imageURL, err := w.storage.Save(ctx, "recipes/"+fileName, imgBytes)
	if err != nil {
		return false, fmt.Errorf("failed to save recipe image: %w", err)
	}

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
		ImageUrl:           pgtype.Text{String: imageURL, Valid: true},
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
			dbIng, err = w.queries.CreateIngredient(ctx, store.CreateIngredientParams{
				Name:              name,
				Category:          cat,
				DefaultUnit:       defUnit,
				IsPantryEssential: false,
			})
			if err != nil {
				dbIng, _ = w.queries.GetIngredientByNameCaseInsensitive(ctx, name)
			}
		}

		var amt pgtype.Numeric
		if ing.Amount != nil {
			_ = amt.Scan(strconv.FormatFloat(*ing.Amount, 'f', -1, 64))
		}
		var unitText pgtype.Text
		if ing.Unit != nil {
			unitText = pgtype.Text{String: *ing.Unit, Valid: true}
		}
		dispText := pgtype.Text{String: ing.DisplayText, Valid: true}

		crit := strings.ToLower(strings.TrimSpace(ing.Criticality))
		if crit != "основной" && crit != "важный" && crit != "опциональный" {
			crit = "важный"
		}

		_, err = w.queries.AddRecipeIngredient(ctx, store.AddRecipeIngredientParams{
			RecipeID:     dbRecipe.ID,
			IngredientID: dbIng.ID,
			Amount:       amt,
			Unit:         unitText,
			DisplayText:  dispText,
			Criticality:  crit,
		})
		if err != nil {
			log.Printf("[RecipeWorker] Warning: failed to link ingredient '%s' to recipe '%s': %v", name, raw.Title, err)
		}
	}

	return true, nil
}

func parseRawInstructions(raw json.RawMessage) []string {
	if len(raw) == 0 {
		return nil
	}

	var steps []string
	var objSteps []struct {
		Text string `json:"text"`
	}
	if err := json.Unmarshal(raw, &objSteps); err == nil && len(objSteps) > 0 {
		for _, s := range objSteps {
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

// GetCuratedRecipeImage assigns a reliable, high-resolution food image matching the exact recipe essence.
func GetCuratedRecipeImage(title, category string) string {
	cleanTitle := strings.ToLower(cleanTitleForImagePrompt(title))
	if img, ok := curatedRecipeImages[cleanTitle]; ok {
		return img
	}

	t := strings.ToLower(title)
	c := strings.ToLower(category)

	switch {
	// Specific pastries & sweets
	case strings.Contains(t, "ананас") && (strings.Contains(t, "пирог") || strings.Contains(t, "торт")):
		return "https://images.unsplash.com/photo-1519869325930-281384150729?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "шарлотк") || (strings.Contains(t, "яблочн") && strings.Contains(t, "пирог")):
		return "https://images.unsplash.com/photo-1568571780765-9276ac8b75a2?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "чизкейк"):
		return "https://images.unsplash.com/photo-1524351199678-941a58a3df50?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "маршмеллоу"):
		return "https://images.unsplash.com/photo-1582293041079-7814c2f12063?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "нутелл") || (strings.Contains(t, "шоколадн") && strings.Contains(t, "паста")):
		return "https://images.unsplash.com/photo-1589733955941-5eeaf752f6dd?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "пудинг"):
		return "https://images.unsplash.com/photo-1541783245831-57d6fb0926d3?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "чипс"):
		return "https://images.unsplash.com/photo-1566478989037-eec170784d0b?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "рогалик") || strings.Contains(t, "круассан"):
		return "https://images.unsplash.com/photo-1555507036-ab1f4038808a?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "пицц"):
		return "https://images.unsplash.com/photo-1513104890138-7c749659a591?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "бургер"):
		return "https://images.unsplash.com/photo-1568901346375-23c9450c58cd?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "блин") || strings.Contains(t, "оладь") || strings.Contains(t, "панкейк"):
		return "https://images.unsplash.com/photo-1528207776546-365bb710ee93?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "сырник"):
		return "https://images.unsplash.com/photo-1589301760014-d929f3979dbc?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "пирог") || strings.Contains(t, "кекс") || strings.Contains(c, "выпечк"):
		return "https://images.unsplash.com/photo-1509440159596-0249088772ff?auto=format&fit=crop&w=660&q=80"

	// Soups
	case strings.Contains(t, "борщ"):
		return "https://images.unsplash.com/photo-1547592180-85f173990554?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "мисо") || strings.Contains(t, "рамен"):
		return "https://images.unsplash.com/photo-1555126634-323283e090fa?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "рассольник"):
		return "https://images.unsplash.com/photo-1578020190125-f4f7c18bc9cb?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "суп") || strings.Contains(t, "солянк") || strings.Contains(c, "суп"):
		return "https://images.unsplash.com/photo-1547592166-23ac45744acd?auto=format&fit=crop&w=660&q=80"

	// Seafood & Fish
	case strings.Contains(t, "креветк"):
		return "https://images.unsplash.com/photo-1559742811-822873691df8?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "рыб") || strings.Contains(t, "скумбри") || strings.Contains(t, "горбуш") || strings.Contains(t, "лосос") || strings.Contains(c, "рыб"):
		return "https://images.unsplash.com/photo-1519708227418-c8fd9a32b7a2?auto=format&fit=crop&w=660&q=80"

	// Poultry
	case strings.Contains(t, "куриц") || strings.Contains(t, "курин") || strings.Contains(t, "цыпленок") || strings.Contains(t, "индейк"):
		return "https://images.unsplash.com/photo-1598515214211-89d3c73ae83b?auto=format&fit=crop&w=660&q=80"

	// Meat & Stews
	case strings.Contains(t, "печен"):
		return "https://images.unsplash.com/photo-1584947921538-261657523910?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "лазань"):
		return "https://images.unsplash.com/photo-1574894709920-11b28e7367e3?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "паст") || strings.Contains(t, "макарон") || strings.Contains(t, "спагетти"):
		return "https://images.unsplash.com/photo-1551183053-bf91a1d81141?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "говядин") || strings.Contains(t, "свинин") || strings.Contains(t, "мяс") || strings.Contains(t, "гуляш") || strings.Contains(t, "азу"):
		return "https://images.unsplash.com/photo-1544025162-d76694265947?auto=format&fit=crop&w=660&q=80"

	// Salads & Breakfast
	case strings.Contains(t, "салат") || strings.Contains(c, "салат"):
		return "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?auto=format&fit=crop&w=660&q=80"
	case strings.Contains(t, "рулет") || strings.Contains(t, "омлет") || strings.Contains(c, "закуск"):
		return "https://images.unsplash.com/photo-1525351484163-7529414344d8?auto=format&fit=crop&w=660&q=80"

	default:
		return "https://images.unsplash.com/photo-1498837167922-ddd27525d352?auto=format&fit=crop&w=660&q=80"
	}
}
