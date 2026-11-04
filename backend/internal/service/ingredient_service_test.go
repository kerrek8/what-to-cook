package service_test

import (
	"context"
	"errors"
	"testing"

	"github.com/jackc/pgx/v5"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockIngredientQuerier struct {
	store.Querier
	searchFunc  func(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error)
	getByIDFunc func(ctx context.Context, id int32) (store.Ingredient, error)
}

func (m *mockIngredientQuerier) SearchIngredients(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error) {
	if m.searchFunc != nil {
		return m.searchFunc(ctx, arg)
	}
	return nil, nil
}

func (m *mockIngredientQuerier) GetIngredientByID(ctx context.Context, id int32) (store.Ingredient, error) {
	if m.getByIDFunc != nil {
		return m.getByIDFunc(ctx, id)
	}
	return store.Ingredient{}, pgx.ErrNoRows
}

func TestIngredientService_Search_Success(t *testing.T) {
	mockStore := &mockIngredientQuerier{
		searchFunc: func(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error) {
			assert.True(t, arg.Query.Valid)
			assert.Equal(t, "лук", arg.Query.String)
			assert.True(t, arg.Category.Valid)
			assert.Equal(t, "Овощи и зелень", arg.Category.String)

			return []store.Ingredient{
				{
					ID:                1,
					Name:              "лук репчатый",
					Category:          "Овощи и зелень",
					DefaultUnit:       "г",
					IsPantryEssential: false,
				},
			}, nil
		},
	}

	svc := service.NewIngredientService(mockStore)
	res, err := svc.Search(context.Background(), dto.IngredientFilterQuery{
		Query:    "лук",
		Category: "Овощи и зелень",
	})

	require.NoError(t, err)
	assert.Equal(t, 1, res.Total)
	require.Len(t, res.Items, 1)
	assert.Equal(t, int32(1), res.Items[0].ID)
	assert.Equal(t, "лук репчатый", res.Items[0].Name)
}

func TestIngredientService_Search_Error(t *testing.T) {
	mockStore := &mockIngredientQuerier{
		searchFunc: func(ctx context.Context, arg store.SearchIngredientsParams) ([]store.Ingredient, error) {
			return nil, errors.New("db error")
		},
	}

	svc := service.NewIngredientService(mockStore)
	_, err := svc.Search(context.Background(), dto.IngredientFilterQuery{})
	require.Error(t, err)
}

func TestIngredientService_GetByID_Success(t *testing.T) {
	mockStore := &mockIngredientQuerier{
		getByIDFunc: func(ctx context.Context, id int32) (store.Ingredient, error) {
			return store.Ingredient{
				ID:                id,
				Name:              "соль",
				Category:          "Специи",
				DefaultUnit:       "г",
				IsPantryEssential: true,
			}, nil
		},
	}

	svc := service.NewIngredientService(mockStore)
	item, err := svc.GetByID(context.Background(), 10)

	require.NoError(t, err)
	require.NotNil(t, item)
	assert.Equal(t, int32(10), item.ID)
	assert.Equal(t, "соль", item.Name)
	assert.True(t, item.IsPantryEssential)
}

func TestIngredientService_GetByID_NotFound(t *testing.T) {
	mockStore := &mockIngredientQuerier{
		getByIDFunc: func(ctx context.Context, id int32) (store.Ingredient, error) {
			return store.Ingredient{}, pgx.ErrNoRows
		},
	}

	svc := service.NewIngredientService(mockStore)
	item, err := svc.GetByID(context.Background(), 999)

	require.ErrorIs(t, err, service.ErrIngredientNotFound)
	assert.Nil(t, item)
}
