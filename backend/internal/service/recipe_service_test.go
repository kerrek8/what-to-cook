package service_test

import (
	"context"
	"testing"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockRecipeQuerier struct {
	store.Querier
	getUserFunc             func(ctx context.Context, id pgtype.UUID) (store.User, error)
	listInvFunc             func(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error)
	listRecipesFunc         func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error)
	countRecipesFunc        func(ctx context.Context, arg store.CountRecipesParams) (int64, error)
	getRecipeFunc           func(ctx context.Context, id int32) (store.Recipe, error)
	getRecipeIngFunc        func(ctx context.Context, id int32) ([]store.GetRecipeIngredientsRow, error)
	getAllIngFunc           func(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error)
	listFavoriteRecipesFunc func(ctx context.Context, userID pgtype.UUID) ([]store.Recipe, error)
	listFavFunc             func(ctx context.Context, id pgtype.UUID) ([]int32, error)
	isFavFunc               func(ctx context.Context, arg store.IsRecipeFavoriteParams) (bool, error)
	addFavFunc              func(ctx context.Context, arg store.AddRecipeFavoriteParams) error
	removeFavFunc           func(ctx context.Context, arg store.RemoveRecipeFavoriteParams) error
	listExcludedFunc        func(ctx context.Context, userID pgtype.UUID) ([]int32, error)
	listPantryFunc          func(ctx context.Context, userID pgtype.UUID) ([]int32, error)
	getRecipeStepsFunc      func(ctx context.Context, recipeID int32) ([]store.GetRecipeStepsRow, error)
	getAllStepsFunc         func(ctx context.Context) ([]store.GetAllRecipeStepsRow, error)
}

func (m *mockRecipeQuerier) ListUserExcludedIngredientIDs(ctx context.Context, userID pgtype.UUID) ([]int32, error) {
	if m.listExcludedFunc != nil {
		return m.listExcludedFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) ListUserPantryIngredientIDs(ctx context.Context, userID pgtype.UUID) ([]int32, error) {
	if m.listPantryFunc != nil {
		return m.listPantryFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) GetRecipeSteps(ctx context.Context, recipeID int32) ([]store.GetRecipeStepsRow, error) {
	if m.getRecipeStepsFunc != nil {
		return m.getRecipeStepsFunc(ctx, recipeID)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) GetAllRecipeSteps(ctx context.Context) ([]store.GetAllRecipeStepsRow, error) {
	if m.getAllStepsFunc != nil {
		return m.getAllStepsFunc(ctx)
	}
	return nil, nil
}

func (m *mockRecipeQuerier) ListAllRecipesForMatch(ctx context.Context) ([]store.Recipe, error) {
	if m.listRecipesFunc != nil {
		return m.listRecipesFunc(ctx, store.ListRecipesParams{LimitVal: 1000})
	}
	return nil, nil
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

func (m *mockRecipeQuerier) ListFavoriteRecipes(ctx context.Context, userID pgtype.UUID) ([]store.Recipe, error) {
	if m.listFavoriteRecipesFunc != nil {
		return m.listFavoriteRecipesFunc(ctx, userID)
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

func TestRecipeService_List(t *testing.T) {
	mockStore := &mockRecipeQuerier{
		listRecipesFunc: func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
			assert.Equal(t, int32(20), arg.LimitVal)
			assert.Equal(t, int32(0), arg.OffsetVal)
			return []store.Recipe{
				{ID: 1, Title: "Борщ", Description: pgtype.Text{String: "Супы", Valid: true}},
				{ID: 2, Title: "Сырники", Description: pgtype.Text{String: "Завтраки", Valid: true}},
			}, nil
		},
		countRecipesFunc: func(ctx context.Context, arg store.CountRecipesParams) (int64, error) {
			return 2, nil
		},
	}

	svc := service.NewRecipeService(mockStore)
	res, err := svc.List(context.Background(), nil, dto.RecipeQuery{})

	require.NoError(t, err)
	assert.Equal(t, 2, res.Total)
	require.Len(t, res.Items, 2)
	assert.Equal(t, "Борщ", res.Items[0].Title)
}

func TestRecipeService_GetByID(t *testing.T) {
	uid := uuid.New()
	mockStore := &mockRecipeQuerier{
		getRecipeFunc: func(ctx context.Context, id int32) (store.Recipe, error) {
			if id == 1 {
				return store.Recipe{
					ID:                 1,
					Title:              "Борщ",
					CookingTimeMinutes: 60,
					Difficulty:         "средне",
					CreatedAt:          pgtype.Timestamptz{Time: time.Now(), Valid: true},
					UpdatedAt:          pgtype.Timestamptz{Time: time.Now(), Valid: true},
				}, nil
			}
			return store.Recipe{}, pgx.ErrNoRows
		},
		getRecipeStepsFunc: func(ctx context.Context, recipeID int32) ([]store.GetRecipeStepsRow, error) {
			return []store.GetRecipeStepsRow{
				{StepNumber: 1, Instruction: "Варить 1 час"},
				{StepNumber: 2, Instruction: "Посолить"},
			}, nil
		},
		getRecipeIngFunc: func(ctx context.Context, id int32) ([]store.GetRecipeIngredientsRow, error) {
			return []store.GetRecipeIngredientsRow{
				{
					IngredientID:   1,
					IngredientName: "Свекла",
					Criticality:    "основной",
				},
			}, nil
		},
		isFavFunc: func(ctx context.Context, arg store.IsRecipeFavoriteParams) (bool, error) {
			return true, nil
		},
	}

	svc := service.NewRecipeService(mockStore)

	t.Run("found", func(t *testing.T) {
		res, err := svc.GetByID(context.Background(), &uid, 1)
		require.NoError(t, err)
		assert.Equal(t, "Борщ", res.Title)
		assert.True(t, res.IsFavorite)
		require.Len(t, res.Ingredients, 1)
		assert.Equal(t, "Свекла", res.Ingredients[0].Name)
	})

	t.Run("not found", func(t *testing.T) {
		_, err := svc.GetByID(context.Background(), &uid, 999)
		require.ErrorIs(t, err, service.ErrRecipeNotFound)
	})
}

func TestRecipeService_Match(t *testing.T) {
	uid := uuid.New()

	mockStore := &mockRecipeQuerier{
		getUserFunc: func(ctx context.Context, id pgtype.UUID) (store.User, error) {
			return store.User{ID: id}, nil
		},
		listExcludedFunc: func(ctx context.Context, userID pgtype.UUID) ([]int32, error) {
			return []int32{3}, nil // Аллергия на Арахис (id=3)
		},
		listInvFunc: func(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
			return []store.ListInventoryItemsByUserIDRow{
				{
					IngredientID: pgtype.Int4{Int32: 1, Valid: true}, // Курица
					InStock:      true,
				},
			}, nil
		},
		listRecipesFunc: func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
			return []store.Recipe{
				{ID: 1, Title: "Курица с солью", CookingTimeMinutes: 20},
				{ID: 2, Title: "Курица с сыром", CookingTimeMinutes: 30},
				{ID: 3, Title: "Курица с арахисом", CookingTimeMinutes: 40},
			}, nil
		},
		getAllIngFunc: func(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error) {
			return []store.GetAllRecipeIngredientsWithDetailsRow{
				// Recipe 1: Курица (есть) + Соль (базовый) -> 100%
				{RecipeID: 1, IngredientID: 1, IngredientName: "Курица", IsPantryEssential: false},
				{RecipeID: 1, IngredientID: 4, IngredientName: "Соль", IsPantryEssential: true},
				// Recipe 2: Курица (есть) + Сыр (нет) -> 50%
				{RecipeID: 2, IngredientID: 1, IngredientName: "Курица", IsPantryEssential: false},
				{RecipeID: 2, IngredientID: 2, IngredientName: "Сыр", IsPantryEssential: false},
				// Recipe 3: Курица + Арахис (аллерген id=3) -> исключен
				{RecipeID: 3, IngredientID: 1, IngredientName: "Курица", IsPantryEssential: false},
				{RecipeID: 3, IngredientID: 3, IngredientName: "Арахис", IsPantryEssential: false},
			}, nil
		},
	}

	svc := service.NewRecipeService(mockStore)
	res, err := svc.Match(context.Background(), uid)

	require.NoError(t, err)
	assert.Equal(t, 2, res.Total)
	require.Len(t, res.Items, 2)

	assert.Equal(t, "Курица с солью", res.Items[0].Recipe.Title)
	assert.Equal(t, 100, res.Items[0].MatchPercentage)
	assert.True(t, res.Items[0].CanCookNow)
	require.NotNil(t, res.Items[0].MissingIngredients)
	assert.Empty(t, res.Items[0].MissingIngredients)
	assert.Len(t, res.Items[0].UsedIngredients, 2)

	assert.Equal(t, "Курица с сыром", res.Items[1].Recipe.Title)
	assert.Equal(t, 50, res.Items[1].MatchPercentage)
	assert.False(t, res.Items[1].CanCookNow)
	assert.Len(t, res.Items[1].MissingIngredients, 1)
	assert.Equal(t, "Сыр", res.Items[1].MissingIngredients[0].Name)
}

func TestRecipeService_Match_MatchesByCustomNameWhenIngredientIDNil(t *testing.T) {
	uid := uuid.New()

	mockStore := &mockRecipeQuerier{
		getUserFunc: func(ctx context.Context, id pgtype.UUID) (store.User, error) {
			return store.User{ID: id}, nil
		},
		listInvFunc: func(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
			return []store.ListInventoryItemsByUserIDRow{
				{
					IngredientID: pgtype.Int4{Valid: false},
					CustomName:   pgtype.Text{String: "  курица ", Valid: true},
					InStock:      true,
				},
			}, nil
		},
		listRecipesFunc: func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
			return []store.Recipe{
				{ID: 1, Title: "Куриный суп", CookingTimeMinutes: 25},
			}, nil
		},
		getAllIngFunc: func(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error) {
			return []store.GetAllRecipeIngredientsWithDetailsRow{
				{RecipeID: 1, IngredientID: 1, IngredientName: "Курица", IsPantryEssential: false},
			}, nil
		},
	}

	svc := service.NewRecipeService(mockStore)
	res, err := svc.Match(context.Background(), uid)

	require.NoError(t, err)
	require.Len(t, res.Items, 1)
	assert.True(t, res.Items[0].CanCookNow)
	assert.Equal(t, 1, res.Items[0].AvailableCount)
	assert.Equal(t, 100, res.Items[0].MatchPercentage)
}

func TestRecipeService_Match_EmptyCustomPantryDoesNotFallbackToDefaults(t *testing.T) {
	uid := uuid.New()

	mockStore := &mockRecipeQuerier{
		getUserFunc: func(ctx context.Context, id pgtype.UUID) (store.User, error) {
			return store.User{ID: id, HasCustomPantry: true}, nil
		},
		listPantryFunc: func(ctx context.Context, userID pgtype.UUID) ([]int32, error) {
			return []int32{}, nil
		},
		listInvFunc: func(ctx context.Context, id pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
			return []store.ListInventoryItemsByUserIDRow{
				{IngredientID: pgtype.Int4{Int32: 1, Valid: true}, InStock: true},
			}, nil
		},
		listRecipesFunc: func(ctx context.Context, arg store.ListRecipesParams) ([]store.Recipe, error) {
			return []store.Recipe{{ID: 1, Title: "Курица с солью"}}, nil
		},
		getAllIngFunc: func(ctx context.Context) ([]store.GetAllRecipeIngredientsWithDetailsRow, error) {
			return []store.GetAllRecipeIngredientsWithDetailsRow{
				{RecipeID: 1, IngredientID: 1, IngredientName: "Курица", IsPantryEssential: false},
				{RecipeID: 1, IngredientID: 4, IngredientName: "Соль", IsPantryEssential: true},
			}, nil
		},
	}

	svc := service.NewRecipeService(mockStore)
	res, err := svc.Match(context.Background(), uid)

	require.NoError(t, err)
	require.Len(t, res.Items, 1)
	assert.False(t, res.Items[0].CanCookNow)
	assert.Equal(t, 1, res.Items[0].AvailableCount)
	assert.Equal(t, 50, res.Items[0].MatchPercentage)
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

	svc := service.NewRecipeService(mockStore)

	err := svc.SetFavorite(context.Background(), uid, 1, true)
	require.NoError(t, err)
	assert.True(t, added)

	err = svc.SetFavorite(context.Background(), uid, 1, false)
	require.NoError(t, err)
	assert.True(t, removed)
}

func TestRecipeService_ListFavorites(t *testing.T) {
	uid := uuid.New()
	mockStore := &mockRecipeQuerier{
		listFavoriteRecipesFunc: func(ctx context.Context, userID pgtype.UUID) ([]store.Recipe, error) {
			return []store.Recipe{
				{ID: 1, Title: "Паста"},
			}, nil
		},
	}
	svc := service.NewRecipeService(mockStore)
	res, err := svc.ListFavorites(context.Background(), uid)
	require.NoError(t, err)
	assert.Len(t, res, 1)
	assert.Equal(t, int32(1), res[0].ID)
}
