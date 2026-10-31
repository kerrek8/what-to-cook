package provider

import "context"

type ExternalRecipeIngredient struct {
	Name    string
	Measure string
}

type ExternalRecipe struct {
	ExternalID   string
	Title        string
	Category     string
	Instructions []string
	ImageURL     string
	Ingredients  []ExternalRecipeIngredient
}

type RecipeProvider interface {
	SearchRecipes(ctx context.Context, query string) ([]ExternalRecipe, error)
	GetRecipeByID(ctx context.Context, id string) (*ExternalRecipe, error)
	FetchByCategory(ctx context.Context, category string) ([]ExternalRecipe, error)
	GetRandomRecipe(ctx context.Context) (*ExternalRecipe, error)
}
