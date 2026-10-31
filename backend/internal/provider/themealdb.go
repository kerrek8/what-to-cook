package provider

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"net/url"
	"strings"
	"time"
)

var (
	ErrMealNotFound = errors.New("meal not found in provider")
)

type TheMealDBClient struct {
	baseURL    string
	httpClient *http.Client
}

func NewTheMealDBClient(baseURL string, timeout time.Duration) *TheMealDBClient {
	if baseURL == "" {
		baseURL = "https://www.themealdb.com/api/json/v1/1"
	}
	if timeout <= 0 {
		timeout = 10 * time.Second
	}
	return &TheMealDBClient{
		baseURL: strings.TrimRight(baseURL, "/"),
		httpClient: &http.Client{
			Timeout: timeout,
		},
	}
}

func (c *TheMealDBClient) SetTransport(tr http.RoundTripper) {
	c.httpClient.Transport = tr
}

type mealDBResponse struct {
	Meals []map[string]any `json:"meals"`
}

func (c *TheMealDBClient) SearchRecipes(ctx context.Context, query string) ([]ExternalRecipe, error) {
	reqURL := fmt.Sprintf("%s/search.php?s=%s", c.baseURL, url.QueryEscape(query))
	return c.fetchMeals(ctx, reqURL)
}

func (c *TheMealDBClient) GetRecipeByID(ctx context.Context, id string) (*ExternalRecipe, error) {
	reqURL := fmt.Sprintf("%s/lookup.php?i=%s", c.baseURL, url.QueryEscape(id))
	meals, err := c.fetchMeals(ctx, reqURL)
	if err != nil {
		return nil, err
	}
	if len(meals) == 0 {
		return nil, ErrMealNotFound
	}
	return &meals[0], nil
}

func (c *TheMealDBClient) FetchByCategory(ctx context.Context, category string) ([]ExternalRecipe, error) {
	reqURL := fmt.Sprintf("%s/filter.php?c=%s", c.baseURL, url.QueryEscape(category))
	return c.fetchMeals(ctx, reqURL)
}

func (c *TheMealDBClient) GetRandomRecipe(ctx context.Context) (*ExternalRecipe, error) {
	reqURL := fmt.Sprintf("%s/random.php", c.baseURL)
	meals, err := c.fetchMeals(ctx, reqURL)
	if err != nil {
		return nil, err
	}
	if len(meals) == 0 {
		return nil, ErrMealNotFound
	}
	return &meals[0], nil
}

func (c *TheMealDBClient) fetchMeals(ctx context.Context, targetURL string) ([]ExternalRecipe, error) {
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, targetURL, nil)
	if err != nil {
		return nil, err
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, fmt.Errorf("themealdb returned status: %d", resp.StatusCode)
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, err
	}

	var res mealDBResponse
	if err := json.Unmarshal(body, &res); err != nil {
		return nil, err
	}

	recipes := make([]ExternalRecipe, 0, len(res.Meals))
	for _, raw := range res.Meals {
		if raw == nil {
			continue
		}
		recipe := parseMeal(raw)
		if recipe.Title != "" {
			recipes = append(recipes, recipe)
		}
	}

	return recipes, nil
}

func parseMeal(raw map[string]any) ExternalRecipe {
	getString := func(key string) string {
		if val, ok := raw[key]; ok && val != nil {
			if s, ok := val.(string); ok {
				return strings.TrimSpace(s)
			}
		}
		return ""
	}

	extID := getString("idMeal")
	title := getString("strMeal")
	category := getString("strCategory")
	imageURL := getString("strMealThumb")
	instructionsRaw := getString("strInstructions")

	var instructions []string
	if instructionsRaw != "" {
		lines := strings.Split(strings.ReplaceAll(instructionsRaw, "\r\n", "\n"), "\n")
		for _, l := range lines {
			trimmed := strings.TrimSpace(l)
			if trimmed != "" {
				instructions = append(instructions, trimmed)
			}
		}
	}

	var ingredients []ExternalRecipeIngredient
	for i := 1; i <= 20; i++ {
		ingName := getString(fmt.Sprintf("strIngredient%d", i))
		measure := getString(fmt.Sprintf("strMeasure%d", i))
		if ingName != "" {
			ingredients = append(ingredients, ExternalRecipeIngredient{
				Name:    ingName,
				Measure: measure,
			})
		}
	}

	return ExternalRecipe{
		ExternalID:   extID,
		Title:        title,
		Category:     category,
		Instructions: instructions,
		ImageURL:     imageURL,
		Ingredients:  ingredients,
	}
}
