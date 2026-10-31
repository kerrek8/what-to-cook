package service_test

import (
	"context"
	"errors"
	"testing"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
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
			assert.Equal(t, "vegetables", arg.Category.String)

			return []store.Ingredient{
				{
					ID:                1,
					Name:              "Лук репчатый",
					NameEn:            pgtype.Text{String: "Onion", Valid: true},
					Category:          "vegetables",
					DefaultUnit:       "g",
					IsPantryEssential: false,
				},
			}, nil
		},
	}

	svc := service.NewIngredientService(mockStore)
	res, err := svc.Search(context.Background(), dto.IngredientFilterQuery{
		Query:    "лук",
		Category: "vegetables",
	})

	require.NoError(t, err)
	assert.Equal(t, 1, res.Total)
	require.Len(t, res.Items, 1)
	assert.Equal(t, int32(1), res.Items[0].ID)
	assert.Equal(t, "Лук репчатый", res.Items[0].Name)
	require.NotNil(t, res.Items[0].NameEn)
	assert.Equal(t, "Onion", *res.Items[0].NameEn)
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
				Name:              "Соль",
				Category:          "spices",
				DefaultUnit:       "g",
				IsPantryEssential: true,
			}, nil
		},
	}

	svc := service.NewIngredientService(mockStore)
	item, err := svc.GetByID(context.Background(), 10)

	require.NoError(t, err)
	require.NotNil(t, item)
	assert.Equal(t, int32(10), item.ID)
	assert.Equal(t, "Соль", item.Name)
	assert.Nil(t, item.NameEn)
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

func TestIngredientService_GetByID_Error(t *testing.T) {
	mockStore := &mockIngredientQuerier{
		getByIDFunc: func(ctx context.Context, id int32) (store.Ingredient, error) {
			return store.Ingredient{}, errors.New("connection failed")
		},
	}

	svc := service.NewIngredientService(mockStore)
	item, err := svc.GetByID(context.Background(), 1)

	require.Error(t, err)
	assert.False(t, errors.Is(err, service.ErrIngredientNotFound))
	assert.Nil(t, item)
}
