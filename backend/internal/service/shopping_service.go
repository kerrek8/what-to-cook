package service

import (
	"context"
	"errors"
	"fmt"
	"strings"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var (
	ErrShoppingItemNotFound = errors.New("shopping item not found")
	ErrInvalidShoppingItem  = errors.New("either ingredient_id or custom_name must be provided")
)

type ShoppingService interface {
	List(ctx context.Context, userID uuid.UUID) (dto.ShoppingListResponse, error)
	GetByID(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.ShoppingItemResponse, error)
	Create(ctx context.Context, userID uuid.UUID, req dto.CreateShoppingItemRequest) (*dto.ShoppingItemResponse, error)
	Update(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateShoppingItemRequest) (*dto.ShoppingItemResponse, error)
	SetStatus(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, isBought bool) (*dto.ShoppingItemResponse, error)
	Delete(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error
	AddMissingFromRecipe(ctx context.Context, userID uuid.UUID, recipeID int32) (*dto.AddFromRecipeResponse, error)
	TransferToInventory(ctx context.Context, userID uuid.UUID) (*dto.TransferToInventoryResponse, error)
}

type shoppingService struct {
	store store.Querier
}

func NewShoppingService(st store.Querier) ShoppingService {
	return &shoppingService{store: st}
}

func (s *shoppingService) List(ctx context.Context, userID uuid.UUID) (dto.ShoppingListResponse, error) {
	items, err := s.store.ListShoppingItemsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return dto.ShoppingListResponse{}, err
	}

	responses := make([]dto.ShoppingItemResponse, len(items))
	for i, item := range items {
		responses[i] = mapShoppingListRowToDTO(item)
	}

	return dto.ShoppingListResponse{
		Items: responses,
		Total: len(responses),
	}, nil
}

func (s *shoppingService) GetByID(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.ShoppingItemResponse, error) {
	row, err := s.store.GetShoppingItemByIDAndUserID(ctx, store.GetShoppingItemByIDAndUserIDParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrShoppingItemNotFound
		}
		return nil, err
	}

	resp := mapShoppingGetRowToDTO(row)
	return &resp, nil
}

func (s *shoppingService) Create(ctx context.Context, userID uuid.UUID, req dto.CreateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
	if req.IngredientID == nil && (req.CustomName == nil || strings.TrimSpace(*req.CustomName) == "") {
		return nil, ErrInvalidShoppingItem
	}

	var ingredientID pgtype.Int4
	if req.IngredientID != nil {
		ingredientID = pgtype.Int4{Int32: *req.IngredientID, Valid: true}
	} else if req.CustomName != nil && strings.TrimSpace(*req.CustomName) != "" {
		cleanName := strings.TrimSpace(*req.CustomName)
		canonicalName := strings.ToLower(cleanName)

		ing, err := s.store.GetIngredientByNameCaseInsensitive(ctx, canonicalName)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				defaultUnit := "г"
				if req.Unit != nil && *req.Unit != "" {
					defaultUnit = *req.Unit
				}
				newIng, createErr := s.store.CreateIngredient(ctx, store.CreateIngredientParams{
					Name:              canonicalName,
					Category:          "Другое",
					DefaultUnit:       defaultUnit,
					IsPantryEssential: false,
				})
				if createErr == nil {
					ingredientID = pgtype.Int4{Int32: newIng.ID, Valid: true}
				}
			}
		} else {
			ingredientID = pgtype.Int4{Int32: ing.ID, Valid: true}
		}
	}

	var customName pgtype.Text
	if req.CustomName != nil && strings.TrimSpace(*req.CustomName) != "" {
		customName = pgtype.Text{String: strings.TrimSpace(*req.CustomName), Valid: true}
	}

	var amount pgtype.Numeric
	if req.Amount != nil {
		_ = amount.Scan(fmt.Sprintf("%.2f", *req.Amount))
	}

	var unit pgtype.Text
	if req.Unit != nil && *req.Unit != "" {
		unit = pgtype.Text{String: *req.Unit, Valid: true}
	}

	created, err := s.store.CreateShoppingItem(ctx, store.CreateShoppingItemParams{
		UserID:       pgtype.UUID{Bytes: userID, Valid: true},
		IngredientID: ingredientID,
		CustomName:   customName,
		Amount:       amount,
		Unit:         unit,
		IsBought:     false,
	})
	if err != nil {
		return nil, err
	}

	return s.GetByID(ctx, userID, uuid.UUID(created.ID.Bytes))
}

func (s *shoppingService) Update(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
	_, err := s.store.GetShoppingItemByIDAndUserID(ctx, store.GetShoppingItemByIDAndUserIDParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrShoppingItemNotFound
		}
		return nil, err
	}

	var ingredientID pgtype.Int4
	if req.IngredientID != nil {
		ingredientID = pgtype.Int4{Int32: *req.IngredientID, Valid: true}
	} else if req.CustomName != nil && strings.TrimSpace(*req.CustomName) != "" {
		cleanName := strings.TrimSpace(*req.CustomName)
		canonicalName := strings.ToLower(cleanName)

		ing, err := s.store.GetIngredientByNameCaseInsensitive(ctx, canonicalName)
		if err != nil {
			if errors.Is(err, pgx.ErrNoRows) {
				defaultUnit := "г"
				if req.Unit != nil && *req.Unit != "" {
					defaultUnit = *req.Unit
				}
				newIng, createErr := s.store.CreateIngredient(ctx, store.CreateIngredientParams{
					Name:              canonicalName,
					Category:          "Другое",
					DefaultUnit:       defaultUnit,
					IsPantryEssential: false,
				})
				if createErr == nil {
					ingredientID = pgtype.Int4{Int32: newIng.ID, Valid: true}
				}
			}
		} else {
			ingredientID = pgtype.Int4{Int32: ing.ID, Valid: true}
		}
	}

	var customName pgtype.Text
	if req.CustomName != nil && strings.TrimSpace(*req.CustomName) != "" {
		customName = pgtype.Text{String: strings.TrimSpace(*req.CustomName), Valid: true}
	}

	var amount pgtype.Numeric
	if req.Amount != nil {
		_ = amount.Scan(fmt.Sprintf("%.2f", *req.Amount))
	}

	var unit pgtype.Text
	if req.Unit != nil && *req.Unit != "" {
		unit = pgtype.Text{String: *req.Unit, Valid: true}
	}

	var isBought pgtype.Bool
	if req.IsBought != nil {
		isBought = pgtype.Bool{Bool: *req.IsBought, Valid: true}
	}

	_, err = s.store.UpdateShoppingItem(ctx, store.UpdateShoppingItemParams{
		ID:           pgtype.UUID{Bytes: itemID, Valid: true},
		UserID:       pgtype.UUID{Bytes: userID, Valid: true},
		IngredientID: ingredientID,
		CustomName:   customName,
		Amount:       amount,
		Unit:         unit,
		IsBought:     isBought,
	})
	if err != nil {
		return nil, err
	}

	return s.GetByID(ctx, userID, itemID)
}

func (s *shoppingService) SetStatus(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, isBought bool) (*dto.ShoppingItemResponse, error) {
	_, err := s.store.SetShoppingItemBoughtStatus(ctx, store.SetShoppingItemBoughtStatusParams{
		ID:       pgtype.UUID{Bytes: itemID, Valid: true},
		UserID:   pgtype.UUID{Bytes: userID, Valid: true},
		IsBought: isBought,
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrShoppingItemNotFound
		}
		return nil, err
	}

	return s.GetByID(ctx, userID, itemID)
}

func (s *shoppingService) Delete(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error {
	_, err := s.store.GetShoppingItemByIDAndUserID(ctx, store.GetShoppingItemByIDAndUserIDParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrShoppingItemNotFound
		}
		return err
	}

	return s.store.DeleteShoppingItem(ctx, store.DeleteShoppingItemParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
}

func (s *shoppingService) AddMissingFromRecipe(ctx context.Context, userID uuid.UUID, recipeID int32) (*dto.AddFromRecipeResponse, error) {
	_, err := s.store.GetRecipeByID(ctx, recipeID)
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrRecipeNotFound
		}
		return nil, err
	}

	recipeIngredients, err := s.store.GetRecipeIngredients(ctx, recipeID)
	if err != nil {
		return nil, err
	}

	invItems, err := s.store.ListInventoryItemsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return nil, err
	}

	availableSet := make(map[int32]bool)
	for _, item := range invItems {
		if item.InStock && item.IngredientID.Valid {
			availableSet[item.IngredientID.Int32] = true
		}
	}

	var addedItems []dto.ShoppingItemResponse
	for _, rIng := range recipeIngredients {
		if rIng.IsPantryEssential {
			continue
		}
		if availableSet[rIng.IngredientID] {
			continue
		}

		existing, err := s.store.GetShoppingItemByIngredientAndUserID(ctx, store.GetShoppingItemByIngredientAndUserIDParams{
			UserID:       pgtype.UUID{Bytes: userID, Valid: true},
			IngredientID: pgtype.Int4{Int32: rIng.IngredientID, Valid: true},
		})
		if err == nil && existing.ID.Valid {
			continue
		}

		created, err := s.store.CreateShoppingItem(ctx, store.CreateShoppingItemParams{
			UserID:       pgtype.UUID{Bytes: userID, Valid: true},
			IngredientID: pgtype.Int4{Int32: rIng.IngredientID, Valid: true},
			CustomName:   pgtype.Text{String: rIng.IngredientName, Valid: true},
			Amount:       rIng.Amount,
			Unit:         rIng.Unit,
			IsBought:     false,
		})
		if err != nil {
			return nil, err
		}

		itemDTO, err := s.GetByID(ctx, userID, uuid.UUID(created.ID.Bytes))
		if err == nil && itemDTO != nil {
			addedItems = append(addedItems, *itemDTO)
		}
	}

	return &dto.AddFromRecipeResponse{
		RecipeID:   recipeID,
		AddedCount: len(addedItems),
		Items:      addedItems,
	}, nil
}

func (s *shoppingService) TransferToInventory(ctx context.Context, userID uuid.UUID) (*dto.TransferToInventoryResponse, error) {
	transferred, err := s.store.TransferBoughtItemsToInventory(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return nil, err
	}

	if len(transferred) > 0 {
		if err := s.store.DeleteBoughtShoppingItemsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true}); err != nil {
			return nil, err
		}
	}

	return &dto.TransferToInventoryResponse{
		TransferredCount: len(transferred),
	}, nil
}

func mapShoppingListRowToDTO(row store.ListShoppingItemsByUserIDRow) dto.ShoppingItemResponse {
	var ingredientID *int32
	if row.IngredientID.Valid {
		ingredientID = &row.IngredientID.Int32
	}

	name := "Без названия"
	if row.IngredientName.Valid && row.IngredientName.String != "" {
		name = row.IngredientName.String
	} else if row.CustomName.Valid && row.CustomName.String != "" {
		name = row.CustomName.String
	}

	category := "Другое"
	if row.IngredientCategory.Valid && row.IngredientCategory.String != "" {
		category = row.IngredientCategory.String
	}

	var unit *string
	if row.Unit.Valid && row.Unit.String != "" {
		unit = &row.Unit.String
	} else if row.IngredientDefaultUnit.Valid && row.IngredientDefaultUnit.String != "" {
		unit = &row.IngredientDefaultUnit.String
	}

	return dto.ShoppingItemResponse{
		ID:           uuid.UUID(row.ID.Bytes).String(),
		IngredientID: ingredientID,
		Name:         name,
		Category:     category,
		Amount:       numericToFloat(row.Amount),
		Unit:         unit,
		IsBought:     row.IsBought,
		CreatedAt:    row.CreatedAt.Time,
		UpdatedAt:    row.UpdatedAt.Time,
	}
}

func mapShoppingGetRowToDTO(row store.GetShoppingItemByIDAndUserIDRow) dto.ShoppingItemResponse {
	var ingredientID *int32
	if row.IngredientID.Valid {
		ingredientID = &row.IngredientID.Int32
	}

	name := "Без названия"
	if row.IngredientName.Valid && row.IngredientName.String != "" {
		name = row.IngredientName.String
	} else if row.CustomName.Valid && row.CustomName.String != "" {
		name = row.CustomName.String
	}

	category := "Другое"
	if row.IngredientCategory.Valid && row.IngredientCategory.String != "" {
		category = row.IngredientCategory.String
	}

	var unit *string
	if row.Unit.Valid && row.Unit.String != "" {
		unit = &row.Unit.String
	} else if row.IngredientDefaultUnit.Valid && row.IngredientDefaultUnit.String != "" {
		unit = &row.IngredientDefaultUnit.String
	}

	return dto.ShoppingItemResponse{
		ID:           uuid.UUID(row.ID.Bytes).String(),
		IngredientID: ingredientID,
		Name:         name,
		Category:     category,
		Amount:       numericToFloat(row.Amount),
		Unit:         unit,
		IsBought:     row.IsBought,
		CreatedAt:    row.CreatedAt.Time,
		UpdatedAt:    row.UpdatedAt.Time,
	}
}
