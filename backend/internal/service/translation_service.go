package service

import (
	"encoding/json"
	"errors"
	"fmt"
	"html"
	"net/http"
	"net/url"
	"strings"
	"sync"
	"time"

	"github.com/bregydoc/gtranslate"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"golang.org/x/text/language"
)

type TranslationService interface {
	Translate(request dto.TranslateRequest) (dto.TranslateResponse, error)
}

type translationService struct {
	mu              sync.Mutex
	cache           map[string]string
	lastRequestTime time.Time
	httpClient      *http.Client
}

func NewTranslationService() TranslationService {
	return &translationService{
		cache:      make(map[string]string),
		httpClient: &http.Client{Timeout: 6 * time.Second},
	}
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
	for index, text := range request.Texts {
		trimmed := strings.TrimSpace(text)
		if trimmed == "" {
			result.Translations[index] = text
			continue
		}

		key := request.Source + ":" + request.Target + ":" + trimmed

		s.mu.Lock()
		translated, ok := s.cache[key]
		if !ok {
			lower := strings.ToLower(trimmed)
			if request.Source == "en" && request.Target == "ru" {
				if dictVal, found := culinaryDictEnRu[lower]; found {
					translated = dictVal
					s.cache[key] = translated
				} else if !hasLatinChars(trimmed) {
					translated = trimmed
					s.cache[key] = translated
				}
			} else if request.Source == "ru" && request.Target == "en" {
				if dictVal, found := culinaryDictRuEn[lower]; found {
					translated = dictVal
					s.cache[key] = translated
				} else if !hasRussianChars(trimmed) {
					translated = trimmed
					s.cache[key] = translated
				}
			}

			if translated == "" {
				if wait := time.Until(s.lastRequestTime.Add(400 * time.Millisecond)); wait > 0 {
					time.Sleep(wait)
				}
				s.lastRequestTime = time.Now()
				var err error
				translated, err = s.translateSafely(trimmed, request.Source, request.Target)
				if err != nil {
					s.mu.Unlock()
					return dto.TranslateResponse{}, fmt.Errorf("translate text: %w", err)
				}
				if len(s.cache) >= 5000 {
					s.cache = make(map[string]string)
				}
				s.cache[key] = translated
			}
		}
		s.mu.Unlock()

		if translated == "" && trimmed != "" {
			return dto.TranslateResponse{}, errors.New("translation returned an empty result")
		}
		result.Translations[index] = translated
	}

	return result, nil
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
