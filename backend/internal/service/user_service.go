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

	resp := MapUserToDTO(user)
	return &resp, nil
}

func (s *UserService) UpdatePantry(ctx context.Context, userIDStr string, req dto.UpdatePantryRequest) (*dto.UserResponse, error) {
	parsedUUID, err := uuid.Parse(userIDStr)
	if err != nil {
		return nil, ErrInvalidToken
	}

	pgUUID := pgtype.UUID{Bytes: parsedUUID, Valid: true}

	pantryIDs := req.PantryIngredientIDs
	if pantryIDs == nil {
		pantryIDs = []int32{}
	}

	err = s.queries.UpdateUserPantryIngredients(ctx, store.UpdateUserPantryIngredientsParams{
		ID:                  pgUUID,
		PantryIngredientIds: pantryIDs,
	})
	if err != nil {
		return nil, fmt.Errorf("update pantry: %w", err)
	}

	user, err := s.queries.GetUserByID(ctx, pgUUID)
	if err != nil {
		return nil, fmt.Errorf("get updated user: %w", err)
	}

	resp := MapUserToDTO(user)
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

	err = s.queries.UpdateUserExcludedIngredients(ctx, store.UpdateUserExcludedIngredientsParams{
		ID:                    pgUUID,
		ExcludedIngredientIds: req.ExcludedIngredientIDs,
	})
	if err != nil {
		return nil, fmt.Errorf("update allergens: %w", err)
	}

	user, err := s.queries.GetUserByID(ctx, pgUUID)
	if err != nil {
		return nil, fmt.Errorf("get updated user: %w", err)
	}

	resp := MapUserToDTO(user)
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

	resp := MapUserToDTO(user)
	return &resp, nil
}
