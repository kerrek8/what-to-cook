package service

import (
	"context"
	"errors"
	"fmt"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var ErrMaxAllergensExceeded = errors.New("free tier allows at most 1 excluded product")

type UserService struct {
	queries store.Querier
}

func NewUserService(queries store.Querier) *UserService {
	return &UserService{
		queries: queries,
	}
}

func (s *UserService) GetMe(ctx context.Context, userIDStr string) (*dto.UserResponse, error) {
	parsedUUID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, ErrInvalidToken
	}

	user, err := s.queries.GetUserByID(ctx, pgtype.UUID{Bytes: parsedUUID, Valid: true})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrUserNotFound
		}
		return nil, fmt.Errorf("get user: %w", err)
	}

	resp := loadAndMapUserDTO(ctx, s.queries, user)
	return &resp, nil
}

func (s *UserService) UpdatePantry(ctx context.Context, userIDStr string, req dto.UpdatePantryRequest) (*dto.UserResponse, error) {
	parsedUUID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, ErrInvalidToken
	}

	pgUUID := pgtype.UUID{Bytes: parsedUUID, Valid: true}

	if err := s.queries.SetUserCustomPantryFlag(ctx, store.SetUserCustomPantryFlagParams{
		ID:              pgUUID,
		HasCustomPantry: true,
	}); err != nil {
		return nil, fmt.Errorf("set custom pantry flag: %w", err)
	}

	if err := s.queries.ClearUserPantryIngredients(ctx, pgUUID); err != nil {
		return nil, fmt.Errorf("clear pantry: %w", err)
	}

	for _, ingID := range req.PantryIngredientIDs {
		if err := s.queries.AddUserPantryIngredient(ctx, store.AddUserPantryIngredientParams{
			UserID:       pgUUID,
			IngredientID: ingID,
		}); err != nil {
			return nil, fmt.Errorf("add pantry ingredient: %w", err)
		}
	}

	user, err := s.queries.GetUserByID(ctx, pgUUID)
	if err != nil {
		return nil, fmt.Errorf("get updated user: %w", err)
	}

	resp := loadAndMapUserDTO(ctx, s.queries, user)
	return &resp, nil
}

func (s *UserService) UpdateAllergens(ctx context.Context, userIDStr string, req dto.UpdateAllergensRequest) (*dto.UserResponse, error) {
	if len(req.ExcludedIngredientIDs) > 1 {
		return nil, ErrMaxAllergensExceeded
	}

	parsedUUID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, ErrInvalidToken
	}

	pgUUID := pgtype.UUID{Bytes: parsedUUID, Valid: true}

	if err := s.queries.ClearUserExcludedIngredients(ctx, pgUUID); err != nil {
		return nil, fmt.Errorf("clear allergens: %w", err)
	}

	for _, ingID := range req.ExcludedIngredientIDs {
		if err := s.queries.AddUserExcludedIngredient(ctx, store.AddUserExcludedIngredientParams{
			UserID:       pgUUID,
			IngredientID: ingID,
		}); err != nil {
			return nil, fmt.Errorf("add allergen: %w", err)
		}
	}

	user, err := s.queries.GetUserByID(ctx, pgUUID)
	if err != nil {
		return nil, fmt.Errorf("get updated user: %w", err)
	}

	resp := loadAndMapUserDTO(ctx, s.queries, user)
	return &resp, nil
}

func (s *UserService) UpdateAvatar(ctx context.Context, userIDStr string, avatarURL *string) (*dto.UserResponse, error) {
	parsedUUID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, ErrInvalidToken
	}

	pgUUID := pgtype.UUID{Bytes: parsedUUID, Valid: true}
	var pgAvatar pgtype.Text
	if avatarURL != nil && *avatarURL != "" {
		pgAvatar = pgtype.Text{String: *avatarURL, Valid: true}
	}

	user, err := s.queries.UpdateUserAvatar(ctx, store.UpdateUserAvatarParams{
		ID:        pgUUID,
		AvatarUrl: pgAvatar,
	})
	if err != nil {
		return nil, fmt.Errorf("update avatar: %w", err)
	}

	resp := loadAndMapUserDTO(ctx, s.queries, user)
	return &resp, nil
}
