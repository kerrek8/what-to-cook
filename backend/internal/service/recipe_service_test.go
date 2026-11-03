package service_test

import (
	"context"
	"encoding/json"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/provider"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockRecipeQuerier struct {
	store.Querier
	getUserFunc      func(ctx context.Context, id pgtype.UUID) (store.User, error)
	listInvFunc      func(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error)
	listRecipesFunc  func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error)
	countRecipesFunc func(ctx context.Context, arg store.CountRecipesParams) (int64, error)
	getRecipeFunc    func(ctx context.Context, id int32) (store.Recipe, error)
	getRecipeIngFunc func(ctx context.Context, id int32) ([]store.GetRecipeIngredientsRow, error)
	getAllIngFunc    func(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error)
	listFavFunc      func(ctx context.Context, id pgtype.UUID) ([]int32, error)
	isFavFunc        func(ctx context.Context, arg store.IsRecipeFavoriteParams) (bool, error)
	addFavFunc       func(ctx context.Context, arg store.AddRecipeFavoriteParams) error
	removeFavFunc    func(ctx context.Context, arg store.RemoveRecipeFavoriteParams) error
	upsertRecipeFunc func(ctx context.Context, arg store.UpsertRecipeParams) (store.Recipe, error)
	searchIngFunc    func(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error)
	createIngFunc    func(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error)
	addRecipeIngFunc func(ctx context.Context, arg store.AddRecipeIngredientParams) (store.RecipeIngredient, error)
}

func (m *mockRecipeQuerier) GetUserByID(ctx context.Context, id pgtype.UUID) (store.User, error) {
	if m.getUserFunc != nil {
		return m.getUserFunc(ctx, id)
	}
	return store.User{}, pgx.ErrNoRows
}

func (m *mockRecipeQuerier) ListInventoryItemsByUserID(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
	if m.listInvFunc != nil {
		return m.listInvFunc(ctx, id)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) ListRecipes(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
	if m.listRecipesFunc != nil {
		return m.listRecipesFunc(ctx, arg)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) CountRecipes(ctx context.Context, arg store.CountRecipesParams) (int64, error) {
	if m.countRecipesFunc != nil {
		return m.countRecipesFunc(ctx, arg)
	}
	return 0, nil
}

func (m *mockRecipeQuerier) CountPendingRecipeTranslations(ctx context.Context) (int64, error) {
	return 0, nil
}

func (m *mockRecipeQuerier) GetRecipeByID(ctx context.Context, id int32) (store.Recipe, error) {
	if m.getRecipeFunc != nil {
		return m.getRecipeFunc(ctx, id)
	}
	return store.Recipe{}, pgx.ErrNoRows
}

func (m *mockRecipeQuerier) GetRecipeIngredients(ctx context.Context, id int32) ([]store.GetRecipeIngredientsRow, error) {
	if m.getRecipeIngFunc != nil {
		return m.getRecipeIngFunc(ctx, id)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) GetAllRecipeIngredientsWithDetails(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error) {
	if m.getAllIngFunc != nil {
		return m.getAllIngFunc(ctx)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) ListUserFavoriteRecipeIDs(ctx context.Context, id pgtype.UUID) ([]int32, error) {
	if m.listFavFunc != nil {
		return m.listFavFunc(ctx, id)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) IsRecipeFavorite(ctx context.Context, arg store.IsRecipeFavoriteParams) (bool, error) {
	if m.isFavFunc != nil {
		return m.isFavFunc(ctx, arg)
	}
	return false, nil
}

func (m *mockRecipeQuerier) AddRecipeFavorite(ctx context.Context, arg store.AddRecipeFavoriteParams) error {
	if m.addFavFunc != nil {
		return m.addFavFunc(ctx, arg)
	}
	return nil
}

func (m *mockRecipeQuerier) RemoveRecipeFavorite(ctx context.Context, arg store.RemoveRecipeFavoriteParams) error {
	if m.removeFavFunc != nil {
		return m.removeFavFunc(ctx, arg)
	}
	return nil
}

func (m *mockRecipeQuerier) UpsertRecipe(ctx context.Context, arg store.UpsertRecipeParams) (store.Recipe, error) {
	if m.upsertRecipeFunc != nil {
		return m.upsertRecipeFunc(ctx, arg)
	}
	return store.Recipe{ID: 1}, nil
}

func (m *mockRecipeQuerier) SearchIngredients(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error) {
	if m.searchIngFunc != nil {
		return m.searchIngFunc(ctx, arg)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) CreateIngredient(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error) {
	if m.createIngFunc != nil {
		return m.createIngFunc(ctx, arg)
	}
	return store.Ingredient{ID: 2}, nil
}

func (m *mockRecipeQuerier) AddRecipeIngredient(ctx context.Context, arg store.AddRecipeIngredientParams) (store.RecipeIngredient, error) {
	if m.addRecipeIngFunc != nil {
		return m.addRecipeIngFunc(ctx, arg)
	}
	return store.RecipeIngredient{}, nil
}

type mockProvider struct {
	recipes []provider.ExternalRecipe
}

func (p *mockProvider) SearchRecipes(ctx context.Context, query string) ([]provider.ExternalRecipe, error) {
	return p.recipes, nil
}

func (p *mockProvider) GetRecipeByID(ctx context.Context, id string) (*provider.ExternalRecipe, error) {
	if len(p.recipes) > 0 {
		return &p.recipes[0], nil
	}
	return nil, provider.ErrMealNotFound
}

func (p *mockProvider) FetchByCategory(ctx context.Context, category string) ([]provider.ExternalRecipe, error) {
	return p.recipes, nil
}

func (p *mockProvider) GetRandomRecipe(ctx context.Context) (*provider.ExternalRecipe, error) {
	if len(p.recipes) > 0 {
		return &p.recipes[0], nil
	}
	return nil, provider.ErrMealNotFound
}

func TestRecipeService_List(t *testing.T) {
	uid := uuid.New()
	mockStore := &mockRecipeQuerier{
		listRecipesFunc: func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
			return []store.Recipe{
				{
					ID:                 1,
					Title:              "Борщ",
					CookingTimeMinutes: 60,
					Difficulty:         "medium",
					CreatedAt:          pgtype.Timestamptz{Time: time.Now(), Valid: true},
					UpdatedAt:          pgtype.Timestamptz{Time: time.Now(), Valid: true},
				},
			}, nil
		},
		countRecipesFunc: func(ctx context.Context, arg store.CountRecipesParams) (int64, error) {
			return 1, nil
		},
		listFavFunc: func(ctx context.Context, id pgtype.UUID) ([]int32, error) {
			return []int32{1}, nil
		},
	}

	svc := service.NewRecipeService(mockStore, nil)
	res, err := svc.List(context.Background(), &uid, dto.RecipeQuery{})

	require.NoError(t, err)
	assert.Equal(t, 1, res.Total)
	require.Len(t, res.Items, 1)
	assert.Equal(t, "Борщ", res.Items[0].Title)
	assert.True(t, res.Items[0].IsFavorite)
}

func TestRecipeService_GetByID_Success(t *testing.T) {
	uid := uuid.New()
	mockStore := &mockRecipeQuerier{
		getRecipeFunc: func(ctx context.Context, id int32) (store.Recipe, error) {
			instr, _ := json.Marshal([]string{"Варить 30 минут"})
			return store.Recipe{
				ID:           id,
				Title:        "Омлет",
				Instructions: instr,
				CreatedAt:    pgtype.Timestamptz{Time: time.Now(), Valid: true},
				UpdatedAt:    pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}, nil
		},
		getRecipeIngFunc: func(ctx context.Context, id int32) ([]store.GetRecipeIngredientsRow, error) {
			return []store.GetRecipeIngredientsRow{
				{
					IngredientID:   1,
					IngredientName: "Яйца",
					Criticality:    "critical",
				},
			}, nil
		},
		isFavFunc: func(ctx context.Context, arg store.IsRecipeFavoriteParams) (bool, error) {
			return true, nil
		},
	}

	svc := service.NewRecipeService(mockStore, nil)
	r, err := svc.GetByID(context.Background(), &uid, 5)

	require.NoError(t, err)
	require.NotNil(t, r)
	assert.Equal(t, "Омлет", r.Title)
	assert.True(t, r.IsFavorite)
	require.Len(t, r.Ingredients, 1)
	assert.Equal(t, "Яйца", r.Ingredients[0].Name)
}

func TestRecipeService_Match(t *testing.T) {
	uid := uuid.New()

	// Recipe 1 (ID: 1): Chicken (ID: 10) + Salt (ID: 11, is_pantry_essential)
	// Recipe 2 (ID: 2): Chicken (ID: 10) + Cheese (ID: 12)
	// Recipe 3 (ID: 3): Mushroom (ID: 99 - Allergen!) + Cream (ID: 13)

	mockStore := &mockRecipeQuerier{
		getUserFunc: func(ctx context.Context, id pgtype.UUID) (store.User, error) {
			return store.User{
				ID:                    id,
				ExcludedIngredientIds: []int32{99}, // Allergen: Mushroom
			}, nil
		},
		listInvFunc: func(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
			return []store.ListInventoryItemsByUserIDRow{
				{
					IngredientID: pgtype.Int4{Int32: 10, Valid: true}, // Chicken in fridge
					InStock:      true,
				},
			}, nil
		},
		listRecipesFunc: func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
			return []store.Recipe{
				{ID: 1, Title: "Курица с солью", CookingTimeMinutes: 20},
				{ID: 2, Title: "Курица с сыром", CookingTimeMinutes: 25},
				{ID: 3, Title: "Грибной суп", CookingTimeMinutes: 30},
			}, nil
		},
		getAllIngFunc: func(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error) {
			return []store.GetAllRecipeIngredientsWithDetailsRow{
				{RecipeID: 1, IngredientID: 10, IngredientName: "Курица", IsPantryEssential: false},
				{RecipeID: 1, IngredientID: 11, IngredientName: "Соль", IsPantryEssential: true}, // Pantry essential!
				{RecipeID: 2, IngredientID: 10, IngredientName: "Курица", IsPantryEssential: false},
				{RecipeID: 2, IngredientID: 12, IngredientName: "Сыр", IsPantryEssential: false},   // Missing!
				{RecipeID: 3, IngredientID: 99, IngredientName: "Грибы", IsPantryEssential: false}, // Allergen!
				{RecipeID: 3, IngredientID: 13, IngredientName: "Сливки", IsPantryEssential: false},
			}, nil
		},
	}

	svc := service.NewRecipeService(mockStore, nil)
	res, err := svc.Match(context.Background(), uid)

	require.NoError(t, err)
	// Recipe 3 must be excluded due to allergen!
	assert.Equal(t, 2, res.Total)
	require.Len(t, res.Items, 2)

	// Recipe 1 should be ranked #1 (100% match, CanCookNow = true)
	assert.Equal(t, "Курица с солью", res.Items[0].Recipe.Title)
	assert.Equal(t, 100, res.Items[0].MatchPercentage)
	assert.True(t, res.Items[0].CanCookNow)
	assert.Empty(t, res.Items[0].MissingIngredients)
	assert.Len(t, res.Items[0].UsedIngredients, 2)

	// Recipe 2 should be ranked #2 (50% match, missing cheese)
	assert.Equal(t, "Курица с сыром", res.Items[1].Recipe.Title)
	assert.Equal(t, 50, res.Items[1].MatchPercentage)
	assert.False(t, res.Items[1].CanCookNow)
	assert.Len(t, res.Items[1].MissingIngredients, 1)
	assert.Equal(t, "Сыр", res.Items[1].MissingIngredients[0].Name)
}

func TestRecipeService_SetFavorite(t *testing.T) {
	uid := uuid.New()
	added := false
	removed := false

	mockStore := &mockRecipeQuerier{
		getRecipeFunc: func(ctx context.Context, id int32) (store.Recipe, error) {
			return store.Recipe{ID: id}, nil
		},
		addFavFunc: func(ctx context.Context, arg store.AddRecipeFavoriteParams) error {
			added = true
			return nil
		},
		removeFavFunc: func(ctx context.Context, arg store.RemoveRecipeFavoriteParams) error {
			removed = true
			return nil
		},
	}

	svc := service.NewRecipeService(mockStore, nil)

	err := svc.SetFavorite(context.Background(), uid, 1, true)
	require.NoError(t, err)
	assert.True(t, added)

	err = svc.SetFavorite(context.Background(), uid, 1, false)
	require.NoError(t, err)
	assert.True(t, removed)
}

func TestRecipeService_SyncFromProvider(t *testing.T) {
	prov := &mockProvider{
		recipes: []provider.ExternalRecipe{
			{
				ExternalID:   "52772",
				Title:        "Teriyaki Chicken",
				Category:     "Chicken",
				Instructions: []string{"Cook chicken"},
				Ingredients: []provider.ExternalRecipeIngredient{
					{Name: "Soy Sauce", Measure: "2 tbsp"},
				},
			},
		},
	}

	mockStore := &mockRecipeQuerier{
		upsertRecipeFunc: func(ctx context.Context, arg store.UpsertRecipeParams) (store.Recipe, error) {
			assert.Equal(t, "52772", arg.ExternalID.String)
			return store.Recipe{ID: 1}, nil
		},
		searchIngFunc: func(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error) {
			return nil, nil // not found, will create
		},
		createIngFunc: func(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error) {
			assert.Equal(t, "Soy Sauce", arg.Name)
			return store.Ingredient{ID: 10}, nil
		},
		addRecipeIngFunc: func(ctx context.Context, arg store.AddRecipeIngredientParams) (store.RecipeIngredient, error) {
			assert.Equal(t, int32(1), arg.RecipeID)
			assert.Equal(t, int32(10), arg.IngredientID)
			return store.RecipeIngredient{}, nil
		},
	}

	svc := service.NewRecipeService(mockStore, prov)
	res, err := svc.SyncFromProvider(context.Background(), "chicken")

	require.NoError(t, err)
	assert.Equal(t, 1, res.SyncedCount)
}
