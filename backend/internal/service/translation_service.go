package service

import (
	"bytes"
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"regexp"
	"strings"
	"time"
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
	TranslateRecipeGroq(ctx context.Context, req GroqRecipeTranslateRequest) (*GroqRecipeTranslateResponse, error)
	IsGroqEnabled() bool
}

type translationService struct {
	httpClient *http.Client
	groqAPIKey string
	groqModel  string
}

func NewTranslationService(groqAPIKey, groqModel string) TranslationService {
	if groqModel == "" {
		groqModel = "llama-3.3-70b-versatile"
	}
	return &translationService{
		httpClient: &http.Client{Timeout: 45 * time.Second},
		groqAPIKey: strings.TrimSpace(groqAPIKey),
		groqModel:  strings.TrimSpace(groqModel),
	}
}

func (s *translationService) IsGroqEnabled() bool {
	return s.groqAPIKey != ""
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
	MaxTokens      int                 `json:"max_tokens,omitempty"`
	ResponseFormat *groqResponseFormat `json:"response_format,omitempty"`
}

type groqChatResponse struct {
	Choices []struct {
		Message struct {
			Content string `json:"message"`
		} `json:"message"`
	} `json:"choices"`
	Error *struct {
		Message string `json:"message"`
		Type    string `json:"type"`
	} `json:"error,omitempty"`
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
3. "localized_instructions": Array of step-by-step instructions in natural Russian. Translate measurements and temperatures to metric (e.g., 350°F -> 180°C).
4. "cooking_time_minutes": MANDATORY positive integer between 15 and 240 representing realistic preparation + cooking time. NEVER 0, NEVER null.
5. "difficulty": MANDATORY exactly one of "easy", "medium", or "hard". NEVER empty.
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
		MaxTokens:      2500,
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
		translated.CookingTimeMinutes = estimateCookingTime(req.Instructions)
	}
	switch translated.Difficulty {
	case "easy", "medium", "hard":
	default:
		translated.Difficulty = estimateDifficulty(translated.CookingTimeMinutes, len(req.Instructions))
	}

	return &translated, nil
}

var timePattern = regexp.MustCompile(`(?i)(\d+)\s*(?:min|minute|mins|minutes|мин|минут|минуты|час|часа|часов|hour|hours)`)

func estimateCookingTime(instructions []string) int32 {
	var maxFound int32
	for _, step := range instructions {
		matches := timePattern.FindAllStringSubmatch(step, -1)
		for _, m := range matches {
			if len(m) > 1 {
				var val int32
				if _, err := fmt.Sscanf(m[1], "%d", &val); err == nil && val > 0 {
					if strings.Contains(strings.ToLower(m[0]), "час") || strings.Contains(strings.ToLower(m[0]), "hour") {
						val *= 60
					}
					if val > maxFound && val <= 300 {
						maxFound = val
					}
				}
			}
		}
	}
	if maxFound >= 15 {
		return maxFound
	}
	steps := len(instructions)
	if steps <= 3 {
		return 20
	} else if steps <= 6 {
		return 30
	}
	return 45
}

func estimateDifficulty(mins int32, stepsCount int) string {
	if mins <= 25 && stepsCount <= 4 {
		return "easy"
	}
	if mins > 60 || stepsCount >= 8 {
		return "hard"
	}
	return "medium"
}

var dailyLimitRegex = regexp.MustCompile(`(?i)Please try again in\s+([0-9hms\.]+)`)

func ParseDailyLimitError(err error) (bool, time.Duration) {
	if err == nil {
		return false, 0
	}
	msg := err.Error()
	msgLower := strings.ToLower(msg)

	isDaily := strings.Contains(msgLower, "tokens per day") ||
		strings.Contains(msgLower, "(tpd)") ||
		strings.Contains(msgLower, "requests per day") ||
		strings.Contains(msgLower, "(rpd)")

	if !isDaily {
		return false, 0
	}

	matches := dailyLimitRegex.FindStringSubmatch(msg)
	if len(matches) > 1 {
		durStr := strings.TrimRight(matches[1], ".")
		if d, parseErr := time.ParseDuration(durStr); parseErr == nil && d > 0 {
			return true, d + 10*time.Second
		}
	}

	return true, 15 * time.Minute
}
