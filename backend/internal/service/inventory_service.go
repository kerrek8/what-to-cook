package service

import (
	"context"
	"errors"
	"fmt"
	"strings"
	"time"

	"github.com/google/uuid"
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var (
	ErrInventoryItemNotFound = errors.New("inventory item not found")
	ErrInvalidInventoryItem  = errors.New("either ingredient_id or custom_name must be provided")
	ErrInvalidExpirationDate = errors.New("invalid expiration date format, expected YYYY-MM-DD")
)

type InventoryService interface {
	List(ctx context.Context, userID uuid.UUID) (dto.InventoryListResponse, error)
	GetByID(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.InventoryItemResponse, error)
	Create(ctx context.Context, userID uuid.UUID, req dto.CreateInventoryItemRequest) (*dto.InventoryItemResponse, error)
	Update(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateInventoryItemRequest) (*dto.InventoryItemResponse, error)
	Delete(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error
}

type inventoryService struct {
	store store.Querier
}

func NewInventoryService(st store.Querier) InventoryService {
	return &inventoryService{store: st}
}

func (s *inventoryService) List(ctx context.Context, userID uuid.UUID) (dto.InventoryListResponse, error) {
	items, err := s.store.ListInventoryItemsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return dto.InventoryListResponse{}, err
	}

	responses := make([]dto.InventoryItemResponse, len(items))
	for i, item := range items {
		responses[i] = mapListRowToDTO(item)
	}

	return dto.InventoryListResponse{
		Items: responses,
		Total: len(responses),
	}, nil
}

func (s *inventoryService) GetByID(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.InventoryItemResponse, error) {
	row, err := s.store.GetInventoryItemByIDAndUserID(ctx, store.GetInventoryItemByIDAndUserIDParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrInventoryItemNotFound
		}
		return nil, err
	}

	resp := mapGetRowToDTO(row)
	return &resp, nil
}

func (s *inventoryService) Create(ctx context.Context, userID uuid.UUID, req dto.CreateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
	if req.IngredientID == nil && (req.CustomName == nil || strings.TrimSpace(*req.CustomName) == "") {
		return nil, ErrInvalidInventoryItem
	}

	var ingredientID pgtype.Int4
	if req.IngredientID != nil {
		ingredientID = pgtype.Int4{Int32: *req.IngredientID, Valid: true}
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

	var approxQty pgtype.Text
	if req.ApproximateQuantity != nil && *req.ApproximateQuantity != "" {
		approxQty = pgtype.Text{String: *req.ApproximateQuantity, Valid: true}
	}

	inStock := true
	if req.InStock != nil {
		inStock = *req.InStock
	}

	var expDate pgtype.Date
	if req.ExpirationDate != nil && *req.ExpirationDate != "" {
		t, err := time.Parse("2006-01-02", *req.ExpirationDate)
		if err != nil {
			return nil, ErrInvalidExpirationDate
		}
		expDate = pgtype.Date{Time: t, Valid: true}
	}

	created, err := s.store.CreateInventoryItem(ctx, store.CreateInventoryItemParams{
		UserID:              pgtype.UUID{Bytes: userID, Valid: true},
		IngredientID:        ingredientID,
		CustomName:          customName,
		Amount:              amount,
		Unit:                unit,
		ApproximateQuantity: approxQty,
		InStock:             inStock,
		ExpirationDate:      expDate,
	})
	if err != nil {
		return nil, err
	}

	createdUUID := uuid.UUID(created.ID.Bytes)
	return s.GetByID(ctx, userID, createdUUID)
}

func (s *inventoryService) Update(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
	_, err := s.store.GetInventoryItemByIDAndUserID(ctx, store.GetInventoryItemByIDAndUserIDParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return nil, ErrInventoryItemNotFound
		}
		return nil, err
	}

	var ingredientID pgtype.Int4
	if req.IngredientID != nil {
		ingredientID = pgtype.Int4{Int32: *req.IngredientID, Valid: true}
	}

	var customName pgtype.Text
	if req.CustomName != nil {
		customName = pgtype.Text{String: strings.TrimSpace(*req.CustomName), Valid: true}
	}

	var amount pgtype.Numeric
	if req.Amount != nil {
		_ = amount.Scan(fmt.Sprintf("%.2f", *req.Amount))
	}

	var unit pgtype.Text
	if req.Unit != nil {
		unit = pgtype.Text{String: *req.Unit, Valid: true}
	}

	var approxQty pgtype.Text
	if req.ApproximateQuantity != nil {
		approxQty = pgtype.Text{String: *req.ApproximateQuantity, Valid: true}
	}

	var inStock pgtype.Bool
	if req.InStock != nil {
		inStock = pgtype.Bool{Bool: *req.InStock, Valid: true}
	}

	var expDate pgtype.Date
	if req.ExpirationDate != nil && *req.ExpirationDate != "" {
		t, err := time.Parse("2006-01-02", *req.ExpirationDate)
		if err != nil {
			return nil, ErrInvalidExpirationDate
		}
		expDate = pgtype.Date{Time: t, Valid: true}
	}

	_, err = s.store.UpdateInventoryItem(ctx, store.UpdateInventoryItemParams{
		ID:                  pgtype.UUID{Bytes: itemID, Valid: true},
		UserID:              pgtype.UUID{Bytes: userID, Valid: true},
		IngredientID:        ingredientID,
		CustomName:          customName,
		Amount:              amount,
		Unit:                unit,
		ApproximateQuantity: approxQty,
		InStock:             inStock,
		ExpirationDate:      expDate,
	})
	if err != nil {
		return nil, err
	}

	return s.GetByID(ctx, userID, itemID)
}

func (s *inventoryService) Delete(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error {
	_, err := s.store.GetInventoryItemByIDAndUserID(ctx, store.GetInventoryItemByIDAndUserIDParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
	if err != nil {
		if errors.Is(err, pgx.ErrNoRows) {
			return ErrInventoryItemNotFound
		}
		return err
	}

	return s.store.DeleteInventoryItem(ctx, store.DeleteInventoryItemParams{
		ID:     pgtype.UUID{Bytes: itemID, Valid: true},
		UserID: pgtype.UUID{Bytes: userID, Valid: true},
	})
}

func mapListRowToDTO(row store.ListInventoryItemsByUserIDRow) dto.InventoryItemResponse {
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

	var nameEn *string
	if row.IngredientNameEn.Valid {
		nameEn = &row.IngredientNameEn.String
	}

	category := "other"
	if row.IngredientCategory.Valid && row.IngredientCategory.String != "" {
		category = row.IngredientCategory.String
	}

	var unit *string
	if row.Unit.Valid && row.Unit.String != "" {
		unit = &row.Unit.String
	} else if row.IngredientDefaultUnit.Valid && row.IngredientDefaultUnit.String != "" {
		unit = &row.IngredientDefaultUnit.String
	}

	var approxQty *string
	if row.ApproximateQuantity.Valid {
		approxQty = &row.ApproximateQuantity.String
	}

	return dto.InventoryItemResponse{
		ID:                  uuid.UUID(row.ID.Bytes).String(),
		IngredientID:        ingredientID,
		Name:                name,
		NameEn:              nameEn,
		Category:            category,
		Amount:              numericToFloat(row.Amount),
		Unit:                unit,
		ApproximateQuantity: approxQty,
		InStock:             row.InStock,
		ExpirationDate:      dateToString(row.ExpirationDate),
		CreatedAt:           row.CreatedAt.Time,
		UpdatedAt:           row.UpdatedAt.Time,
	}
}

func mapGetRowToDTO(row store.GetInventoryItemByIDAndUserIDRow) dto.InventoryItemResponse {
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

	var nameEn *string
	if row.IngredientNameEn.Valid {
		nameEn = &row.IngredientNameEn.String
	}

	category := "other"
	if row.IngredientCategory.Valid && row.IngredientCategory.String != "" {
		category = row.IngredientCategory.String
	}

	var unit *string
	if row.Unit.Valid && row.Unit.String != "" {
		unit = &row.Unit.String
	} else if row.IngredientDefaultUnit.Valid && row.IngredientDefaultUnit.String != "" {
		unit = &row.IngredientDefaultUnit.String
	}

	var approxQty *string
	if row.ApproximateQuantity.Valid {
		approxQty = &row.ApproximateQuantity.String
	}

	return dto.InventoryItemResponse{
		ID:                  uuid.UUID(row.ID.Bytes).String(),
		IngredientID:        ingredientID,
		Name:                name,
		NameEn:              nameEn,
		Category:            category,
		Amount:              numericToFloat(row.Amount),
		Unit:                unit,
		ApproximateQuantity: approxQty,
		InStock:             row.InStock,
		ExpirationDate:      dateToString(row.ExpirationDate),
		CreatedAt:           row.CreatedAt.Time,
		UpdatedAt:           row.UpdatedAt.Time,
	}
}

func numericToFloat(num pgtype.Numeric) *float64 {
	if !num.Valid {
		return nil
	}
	f, err := num.Float64Value()
	if err != nil || !f.Valid {
		return nil
	}
	val := f.Float64
	return &val
}

func dateToString(d pgtype.Date) *string {
	if !d.Valid {
		return nil
	}
	s := d.Time.Format("2006-01-02")
	return &s
}
