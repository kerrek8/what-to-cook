package service

import (
	"context"
	"errors"

	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var ErrIngredientNotFound = errors.New("ingredient not found")

type IngredientService interface {
	Search(ctx context.Context, filter dto.IngredientFilterQuery) (dto.IngredientListResponse, error)
	GetByID(ctx context.Context, id int32) (*dto.IngredientResponse, error)
}

type ingredientService struct {
	store store.Querier
}

func NewIngredientService(st store.Querier) IngredientService {
	return &ingredientService{store: st}
}

func (s *ingredientService) Search(ctx context.Context, filter dto.IngredientFilterQuery) (dto.IngredientListResponse, error) {
	var queryText pgtype.Text
	if filter.Query != "" {
		queryText = pgtype.Text{String: filter.Query, Valid: true}
	}

	var categoryText pgtype.Text
	if filter.Category != "" {
		categoryText = pgtype.Text{String: filter.Category, Valid: true}
	}

	items, err := s.store.SearchIngredients(ctx, store.SearchIngredientsParams{
		Query:    queryText,
		Category: categoryText,
	})
	if err != nil {
		return dto.IngredientListResponse{}, err
	}

	responses := make([]dto.IngredientResponse, len(items))
	for i, item := range items {
		responses[i] = mapStoreIngredientToDTO(item)
	}

	return dto.IngredientListResponse{
		Items: responses,
		Total: len(responses),
	}, nil
}

func (s *ingredientService) GetByID(ctx context.Context, id int32) (*dto.IngredientResponse, error) {
	item, err := s.store.GetIngredientByID(ctx, id)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrIngredientNotFound
		}
		return nil, err
	}

	resp := mapStoreIngredientToDTO(item)
	return &resp, nil
}

func mapStoreIngredientToDTO(item store.Ingredient) dto.IngredientResponse {
	return dto.IngredientResponse{
		ID:                item.ID,
		Name:              item.Name,
		Category:          item.Category,
		DefaultUnit:       item.DefaultUnit,
		IsPantryEssential: item.IsPantryEssential,
	}
}
