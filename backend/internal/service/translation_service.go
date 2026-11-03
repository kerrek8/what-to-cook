package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"html"
	"log"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"

	"github.com/bregydoc/gtranslate"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"golang.org/x/text/language"
)

type GroqRecipeIngredient struct {
	ID          int32  `json:"id"`
	Name        string `json:"name"`
	DisplayText string `json:"display_text"`
}

type GroqRecipeTranslateRequest struct {
	Title        string                 `json:"title"`
	Description  string                 `json:"description,omitempty"`
	Instructions []string               `json:"instructions"`
	Ingredients  []GroqRecipeIngredient `json:"ingredients"`
}

type GroqRecipeIngredientResponse struct {
	ID                   int32  `json:"id"`
	RussianName          string `json:"russian_name"`
	LocalizedDisplayText string `json:"localized_display_text"`
}

type GroqRecipeTranslateResponse struct {
	LocalizedTitle        string                         `json:"localized_title"`
	LocalizedDescription  string                         `json:"localized_description"`
	LocalizedInstructions []string                       `json:"localized_instructions"`
	CookingTimeMinutes    int32                          `json:"cooking_time_minutes"`
	Difficulty            string                         `json:"difficulty"`
	Ingredients           []GroqRecipeIngredientResponse `json:"ingredients"`
}

type TranslationService interface {
	Translate(request dto.TranslateRequest) (dto.TranslateResponse, error)
	TranslateRecipeGroq(ctx context.Context, req GroqRecipeTranslateRequest) (*GroqRecipeTranslateResponse, error)
	IsGroqEnabled() bool
}

type translationService struct {
	mu              sync.Mutex
	cache           map[string]string
	lastRequestTime time.Time
	httpClient      *http.Client
	groqAPIKey      string
	groqModel       string
}

func NewTranslationService(groqAPIKey, groqModel string) TranslationService {
	if groqModel == "" {
		groqModel = "llama-3.3-70b-versatile"
	}
	return &translationService{
		cache:      make(map[string]string),
		httpClient: &http.Client{Timeout: 30 * time.Second},
		groqAPIKey: strings.TrimSpace(groqAPIKey),
		groqModel:  strings.TrimSpace(groqModel),
	}
}

func (s *translationService) IsGroqEnabled() bool {
	return s.groqAPIKey != ""
}

var culinaryDictEnRu = map[string]string{
	"salt":              "соль",
	"sugar":             "сахар",
	"water":             "вода",
	"black pepper":      "черный перец",
	"pepper":            "перец",
	"olive oil":         "оливковое масло",
	"vegetable oil":     "растительное масло",
	"oil":               "растительное масло",
	"butter":            "сливочное масло",
	"garlic":            "чеснок",
	"onion":             "лук",
	"onions":            "лук",
	"red onion":         "красный лук",
	"egg":               "яйцо",
	"eggs":              "яйца",
	"flour":             "мука",
	"all-purpose flour": "мука",
	"milk":              "молоко",
	"chicken":           "курица",
	"chicken breast":    "куриная грудка",
	"chicken thighs":    "куриные бедра",
	"beef":              "говядина",
	"pork":              "свинина",
	"ground beef":       "фарш говяжий",
	"minced beef":       "фарш говяжий",
	"bacon":             "бекон",
	"potato":            "картофель",
	"potatoes":          "картофель",
	"tomato":            "помидор",
	"tomatoes":          "помидоры",
	"carrot":            "морковь",
	"carrots":           "морковь",
	"cucumber":          "огурец",
	"cucumbers":         "огурцы",
	"lemon":             "лимон",
	"lemon juice":       "лимонный сок",
	"lime":              "лайм",
	"lime juice":        "сок лайма",
	"rice":              "рис",
	"pasta":             "паста",
	"spaghetti":         "спагетти",
	"cheese":            "сыр",
	"parmesan":          "пармезан",
	"cheddar":           "чеддер",
	"mozzarella":        "моцарелла",
	"soy sauce":         "соевый соус",
	"honey":             "мед",
	"ginger":            "имбирь",
	"cream":             "сливки",
	"heavy cream":       "жирные сливки",
	"sour cream":        "сметана",
	"mayonnaise":        "майонез",
	"mustard":           "горчица",
	"vinegar":           "уксус",
	"parsley":           "петрушка",
	"dill":              "укроп",
	"basil":             "базилик",
	"oregano":           "орегано",
	"thyme":             "тимьян",
	"rosemary":          "розмарин",
	"paprika":           "паприка",
	"cinnamon":          "корица",
	"bread":             "хлеб",
	"mushrooms":         "грибы",
	"mushroom":          "грибы",
	"salmon":            "лосось",
	"tuna":              "тунец",
	"shrimp":            "креветки",
	"prawns":            "креветки",
	"fish":              "рыба",
	"baking powder":     "разрыхлитель",
	"yeast":             "дрожжи",
	"vanilla extract":   "экстракт ванили",
}

var culinaryDictRuEn = map[string]string{
	"курица":         "chicken",
	"куриная грудка": "chicken breast",
	"говядина":       "beef",
	"свинина":        "pork",
	"рыба":           "fish",
	"паста":          "pasta",
	"макароны":       "pasta",
	"спагетти":       "spaghetti",
	"рис":            "rice",
	"суп":            "soup",
	"салат":          "salad",
	"десерт":         "dessert",
	"завтрак":        "breakfast",
	"картофель":      "potato",
	"картошка":       "potato",
	"яйца":           "eggs",
	"яйцо":           "egg",
	"сыр":            "cheese",
	"помидоры":       "tomatoes",
	"помидор":        "tomato",
	"томаты":         "tomatoes",
	"огурцы":         "cucumbers",
	"морковь":        "carrots",
	"грибы":          "mushrooms",
	"креветки":       "shrimp",
	"молоко":         "milk",
	"хлеб":           "bread",
	"яблоко":         "apple",
	"яблоки":         "apples",
	"банан":          "banana",
	"бананы":         "bananas",
	"выпечка":        "dessert",
	"мясо":           "meat",
	"фарш":           "ground beef",
	"пирог":          "pie",
	"торт":           "cake",
	"пицца":          "pizza",
}

func (s *translationService) Translate(request dto.TranslateRequest) (dto.TranslateResponse, error) {
	if request.Source == request.Target {
		return dto.TranslateResponse{Translations: request.Texts}, nil
	}

	result := dto.TranslateResponse{Translations: make([]string, len(request.Texts))}
	var uncachedIndices []int
	var uncachedTexts []string

	s.mu.Lock()
	for index, text := range request.Texts {
		trimmed := strings.TrimSpace(text)
		if trimmed == "" {
			result.Translations[index] = text
			continue
		}

		key := request.Source + ":" + request.Target + ":" + trimmed
		if translated, ok := s.cache[key]; ok {
			result.Translations[index] = translated
			continue
		}

		lower := strings.ToLower(trimmed)
		if request.Source == "en" && request.Target == "ru" {
			if dictVal, found := culinaryDictEnRu[lower]; found {
				result.Translations[index] = dictVal
				s.cache[key] = dictVal
				continue
			} else if !hasLatinChars(trimmed) {
				result.Translations[index] = trimmed
				s.cache[key] = trimmed
				continue
			}
		} else if request.Source == "ru" && request.Target == "en" {
			if dictVal, found := culinaryDictRuEn[lower]; found {
				result.Translations[index] = dictVal
				s.cache[key] = dictVal
				continue
			} else if !hasRussianChars(trimmed) {
				result.Translations[index] = trimmed
				s.cache[key] = trimmed
				continue
			}
		}

		uncachedIndices = append(uncachedIndices, index)
		uncachedTexts = append(uncachedTexts, trimmed)
	}
	s.mu.Unlock()

	if len(uncachedTexts) == 0 {
		return result, nil
	}

	if s.IsGroqEnabled() {
		groqTranslations, err := s.translateGroqTexts(uncachedTexts, request.Source, request.Target)
		if err == nil && len(groqTranslations) == len(uncachedTexts) {
			s.mu.Lock()
			for i, idx := range uncachedIndices {
				trans := groqTranslations[i]
				result.Translations[idx] = trans
				key := request.Source + ":" + request.Target + ":" + uncachedTexts[i]
				s.cache[key] = trans
			}
			s.mu.Unlock()
			return result, nil
		}
		log.Printf("[TranslationService] Groq batch translation failed: %v. Falling back to default providers.", err)
	}

	for i, idx := range uncachedIndices {
		txt := uncachedTexts[i]
		key := request.Source + ":" + request.Target + ":" + txt

		s.mu.Lock()
		if wait := time.Until(s.lastRequestTime.Add(400 * time.Millisecond)); wait > 0 {
			time.Sleep(wait)
		}
		s.lastRequestTime = time.Now()
		s.mu.Unlock()

		translated, err := s.translateSafely(txt, request.Source, request.Target)
		if err != nil {
			return dto.TranslateResponse{}, fmt.Errorf("translate text: %w", err)
		}
		if translated == "" {
			return dto.TranslateResponse{}, errors.New("translation returned an empty result")
		}

		s.mu.Lock()
		if len(s.cache) >= 5000 {
			s.cache = make(map[string]string)
		}
		s.cache[key] = translated
		s.mu.Unlock()

		result.Translations[idx] = translated
	}

	return result, nil
}

type groqMessage struct {
	Role    string `json:"role"`
	Content string `json:"content"`
}

type groqResponseFormat struct {
	Type string `json:"type"`
}

type groqChatRequest struct {
	Model          string              `json:"model"`
	Messages       []groqMessage       `json:"messages"`
	Temperature    float32             `json:"temperature"`
	ResponseFormat *groqResponseFormat `json:"response_format,omitempty"`
}

type groqChatResponse struct {
	Choices []struct {
		Message struct {
			Content string `json:"content"`
		} `json:"message"`
	} `json:"choices"`
	Error *struct {
		Message string `json:"message"`
		Type    string `json:"type"`
	} `json:"error,omitempty"`
}

func (s *translationService) translateGroqTexts(texts []string, source, target string) ([]string, error) {
	if len(texts) == 0 {
		return nil, nil
	}

	systemPrompt := fmt.Sprintf("You are a professional culinary translator. Translate texts from %s to %s with natural culinary terminology. Return a JSON object with key \"translations\" containing array of translated strings in identical order.", source, target)

	reqPayload := groqChatRequest{
		Model: s.groqModel,
		Messages: []groqMessage{
			{Role: "system", Content: systemPrompt},
			{Role: "user", Content: func() string {
				b, _ := json.Marshal(map[string]any{"texts": texts})
				return string(b)
			}()},
		},
		Temperature:    0.1,
		ResponseFormat: &groqResponseFormat{Type: "json_object"},
	}

	body, err := json.Marshal(reqPayload)
	if err != nil {
		return nil, err
	}

	ctx, cancel := context.WithTimeout(context.Background(), 20*time.Second)
	defer cancel()

	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.groq.com/openai/v1/chat/completions", bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	httpReq.Header.Set("Authorization", "Bearer "+s.groqAPIKey)
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := s.httpClient.Do(httpReq)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var groqResp groqChatResponse
	if err := json.NewDecoder(resp.Body).Decode(&groqResp); err != nil {
		return nil, err
	}

	if resp.StatusCode != http.StatusOK {
		errMsg := fmt.Sprintf("groq status %d", resp.StatusCode)
		if groqResp.Error != nil && groqResp.Error.Message != "" {
			errMsg += ": " + groqResp.Error.Message
		}
		return nil, errors.New(errMsg)
	}

	if len(groqResp.Choices) == 0 {
		return nil, errors.New("empty response choices from groq")
	}

	var parsed struct {
		Translations []string `json:"translations"`
	}
	if err := json.Unmarshal([]byte(groqResp.Choices[0].Message.Content), &parsed); err != nil {
		return nil, fmt.Errorf("decode groq json: %w", err)
	}

	if len(parsed.Translations) != len(texts) {
		return nil, fmt.Errorf("groq returned %d translations for %d inputs", len(parsed.Translations), len(texts))
	}

	return parsed.Translations, nil
}

func (s *translationService) TranslateRecipeGroq(ctx context.Context, req GroqRecipeTranslateRequest) (*GroqRecipeTranslateResponse, error) {
	if !s.IsGroqEnabled() {
		return nil, errors.New("groq api key is not configured")
	}

	systemPrompt := `You are an expert chef and professional culinary translator.
Translate the culinary recipe into natural, high-quality Russian.
Requirements:
1. "localized_title": Russian recipe name (e.g. "Запеканка с курицей терияки", "Паста Карбонара").
2. "localized_description": Russian category or short culinary description (e.g. "Блюдо из курицы", "Итальянская кухня").
3. "localized_instructions": Array of step-by-step instructions in natural Russian. Translate measurements and temperatures to metric where appropriate (e.g., 350°F -> 180°C).
4. "cooking_time_minutes": Integer representing realistic total preparation + cooking time in minutes (between 10 and 240).
5. "difficulty": Exactly one of "easy", "medium", or "hard".
6. "ingredients": Array of objects matching input IDs:
   - "id": integer ID from input
   - "russian_name": standard lower-case ingredient name in Russian (e.g. "соевый соус", "куриное филе", "чеснок")
   - "localized_display_text": Russian measurement and ingredient (e.g. "3/4 стакана соевого соуса", "2 зубчика чеснока")

Output MUST be a valid JSON object matching this structure with no markdown code blocks.`

	inputJSON, err := json.Marshal(req)
	if err != nil {
		return nil, err
	}

	reqPayload := groqChatRequest{
		Model: s.groqModel,
		Messages: []groqMessage{
			{Role: "system", Content: systemPrompt},
			{Role: "user", Content: string(inputJSON)},
		},
		Temperature:    0.2,
		ResponseFormat: &groqResponseFormat{Type: "json_object"},
	}

	body, err := json.Marshal(reqPayload)
	if err != nil {
		return nil, err
	}

	httpReq, err := http.NewRequestWithContext(ctx, http.MethodPost, "https://api.groq.com/openai/v1/chat/completions", bytes.NewReader(body))
	if err != nil {
		return nil, err
	}
	httpReq.Header.Set("Authorization", "Bearer "+s.groqAPIKey)
	httpReq.Header.Set("Content-Type", "application/json")

	resp, err := s.httpClient.Do(httpReq)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	var groqResp groqChatResponse
	if err := json.NewDecoder(resp.Body).Decode(&groqResp); err != nil {
		return nil, err
	}

	if resp.StatusCode != http.StatusOK {
		errMsg := fmt.Sprintf("groq status %d", resp.StatusCode)
		if groqResp.Error != nil && groqResp.Error.Message != "" {
			errMsg += ": " + groqResp.Error.Message
		}
		return nil, errors.New(errMsg)
	}

	if len(groqResp.Choices) == 0 {
		return nil, errors.New("empty response choices from groq")
	}

	content := strings.TrimSpace(groqResp.Choices[0].Message.Content)
	content = strings.TrimPrefix(content, "```json")
	content = strings.TrimPrefix(content, "```")
	content = strings.TrimSuffix(content, "```")
	content = strings.TrimSpace(content)

	var translated GroqRecipeTranslateResponse
	if err := json.Unmarshal([]byte(content), &translated); err != nil {
		return nil, fmt.Errorf("parse groq recipe json: %w", err)
	}

	if translated.LocalizedTitle == "" {
		return nil, errors.New("groq returned empty localized_title")
	}
	if len(translated.LocalizedInstructions) == 0 {
		translated.LocalizedInstructions = req.Instructions
	}
	if translated.CookingTimeMinutes <= 0 {
		translated.CookingTimeMinutes = int32(max(15, len(req.Instructions)*5+len(req.Ingredients)*2))
	}
	switch translated.Difficulty {
	case "easy", "medium", "hard":
	default:
		translated.Difficulty = "medium"
	}

	return &translated, nil
}

func (s *translationService) translateSafely(text, source, target string) (string, error) {
	if translated, err := s.translateGoogleDirect(text, source, target); err == nil && translated != "" {
		return translated, nil
	}

	if translated, err := s.translateMyMemory(text, source, target); err == nil && translated != "" {
		return translated, nil
	}

	var fallbackTrans string
	var fallbackErr error
	func() {
		defer func() {
			if r := recover(); r != nil {
				fallbackTrans = ""
				fallbackErr = fmt.Errorf("gtranslate panic: %v", r)
			}
		}()
		fallbackTrans, fallbackErr = gtranslate.Translate(text, language.Make(source), language.Make(target))
	}()
	if fallbackErr == nil && fallbackTrans != "" {
		return fallbackTrans, nil
	}

	return "", fmt.Errorf("all translation providers failed: %w", fallbackErr)
}

func (s *translationService) translateGoogleDirect(text, source, target string) (string, error) {
	reqURL := fmt.Sprintf(
		"https://translate.googleapis.com/translate_a/single?client=gtx&sl=%s&tl=%s&dt=t&ie=UTF-8&oe=UTF-8&q=%s",
		url.QueryEscape(source),
		url.QueryEscape(target),
		url.QueryEscape(text),
	)

	req, err := http.NewRequest(http.MethodGet, reqURL, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36")
	req.Header.Set("Accept", "*/*")

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("google translate status %d", resp.StatusCode)
	}

	var raw []json.RawMessage
	if err := json.NewDecoder(resp.Body).Decode(&raw); err != nil {
		return "", err
	}
	if len(raw) == 0 {
		return "", errors.New("empty response from google translate")
	}

	var segments [][]json.RawMessage
	if err := json.Unmarshal(raw[0], &segments); err != nil {
		return "", err
	}

	var sb strings.Builder
	for _, seg := range segments {
		if len(seg) > 0 {
			var part string
			if err := json.Unmarshal(seg[0], &part); err == nil {
				sb.WriteString(part)
			}
		}
	}

	result := strings.TrimSpace(sb.String())
	if result == "" {
		return "", errors.New("empty translated string")
	}
	return result, nil
}

func (s *translationService) translateMyMemory(text, source, target string) (string, error) {
	reqURL := fmt.Sprintf(
		"https://api.mymemory.translated.net/get?q=%s&langpair=%s|%s",
		url.QueryEscape(text),
		url.QueryEscape(source),
		url.QueryEscape(target),
	)

	req, err := http.NewRequest(http.MethodGet, reqURL, nil)
	if err != nil {
		return "", err
	}
	req.Header.Set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64)")

	resp, err := s.httpClient.Do(req)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("mymemory status %d", resp.StatusCode)
	}

	var payload struct {
		ResponseData struct {
			TranslatedText string `json:"translatedText"`
		} `json:"responseData"`
		ResponseStatus int `json:"responseStatus"`
	}
	if err := json.NewDecoder(resp.Body).Decode(&payload); err != nil {
		return "", err
	}

	result := strings.TrimSpace(payload.ResponseData.TranslatedText)
	if result == "" {
		return "", errors.New("empty translated text from mymemory")
	}
	result = html.UnescapeString(result)
	return result, nil
}

func hasLatinChars(s string) bool {
	for _, r := range s {
		if (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') {
			return true
		}
	}
	return false
}

func hasRussianChars(s string) bool {
	for _, r := range s {
		if (r >= 'а' && r <= 'я') || (r >= 'А' && r <= 'Я') || r == 'ё' || r == 'Ё' {
			return true
		}
	}
	return false
}
