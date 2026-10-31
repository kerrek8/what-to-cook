package provider_test

import (
	"bytes"
	"context"
	"io"
	"net/http"
	"testing"
	"time"

	"github.com/kerrek8/what-to-cook/backend/internal/provider"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type roundTripFunc func(req *http.Request) *http.Response

func (f roundTripFunc) RoundTrip(req *http.Request) (*http.Response, error) {
	return f(req), nil
}

func TestTheMealDBClient_SearchRecipes(t *testing.T) {
	mockJSON := `{
		"meals": [
			{
				"idMeal": "52772",
				"strMeal": "Teriyaki Chicken Casserole",
				"strCategory": "Chicken",
				"strInstructions": "Step 1: Preheat oven\r\n\r\nStep 2: Bake",
				"strMealThumb": "https://www.themealdb.com/images/media/meals/chicken.jpg",
				"strIngredient1": "soy sauce",
				"strMeasure1": "3/4 cup",
				"strIngredient2": "water",
				"strMeasure2": "1/2 cup",
				"strIngredient3": ""
			}
		]
	}`

	client := provider.NewTheMealDBClient("https://themealdb.test", 2*time.Second)
	client.SetTransport(roundTripFunc(func(req *http.Request) *http.Response {
		assert.Equal(t, "/search.php", req.URL.Path)
		assert.Equal(t, "chicken", req.URL.Query().Get("s"))
		return &http.Response{
			StatusCode: http.StatusOK,
			Body:       io.NopCloser(bytes.NewBufferString(mockJSON)),
			Header:     make(http.Header),
		}
	}))

	recipes, err := client.SearchRecipes(context.Background(), "chicken")

	require.NoError(t, err)
	require.Len(t, recipes, 1)
	assert.Equal(t, "52772", recipes[0].ExternalID)
	assert.Equal(t, "Teriyaki Chicken Casserole", recipes[0].Title)
	assert.Equal(t, "Chicken", recipes[0].Category)
	assert.Len(t, recipes[0].Instructions, 2)
	assert.Equal(t, "Step 1: Preheat oven", recipes[0].Instructions[0])
	assert.Len(t, recipes[0].Ingredients, 2)
	assert.Equal(t, "soy sauce", recipes[0].Ingredients[0].Name)
	assert.Equal(t, "3/4 cup", recipes[0].Ingredients[0].Measure)
}

func TestTheMealDBClient_GetRecipeByID_NotFound(t *testing.T) {
	mockJSON := `{"meals": null}`

	client := provider.NewTheMealDBClient("https://themealdb.test", 2*time.Second)
	client.SetTransport(roundTripFunc(func(req *http.Request) *http.Response {
		return &http.Response{
			StatusCode: http.StatusOK,
			Body:       io.NopCloser(bytes.NewBufferString(mockJSON)),
			Header:     make(http.Header),
		}
	}))

	_, err := client.GetRecipeByID(context.Background(), "99999")
	require.ErrorIs(t, err, provider.ErrMealNotFound)
}

func TestTheMealDBClient_ServerError(t *testing.T) {
	client := provider.NewTheMealDBClient("https://themealdb.test", 2*time.Second)
	client.SetTransport(roundTripFunc(func(req *http.Request) *http.Response {
		return &http.Response{
			StatusCode: http.StatusInternalServerError,
			Body:       io.NopCloser(bytes.NewBufferString("server error")),
			Header:     make(http.Header),
		}
	}))

	_, err := client.GetRandomRecipe(context.Background())
	require.Error(t, err)
	assert.Contains(t, err.Error(), "status: 500")
}
