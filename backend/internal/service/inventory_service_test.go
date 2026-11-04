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

type mockInventoryQuerier struct {
	store.Querier
	listFunc         func(ctx context.Context, userID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error)
	getFunc          func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error)
	createFunc       func(ctx context.Context, arg store.CreateInventoryItemParams) (store.InventoryItem, error)
	updateFunc       func(ctx context.Context, arg store.UpdateInventoryItemParams) (store.InventoryItem, error)
	deleteFunc       func(ctx context.Context, arg store.DeleteInventoryItemParams) error
	getIngByNameFunc func(ctx context.Context, name string) (store.Ingredient, error)
	createIngFunc    func(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error)
}

func (m *mockInventoryQuerier) GetIngredientByNameCaseInsensitive(ctx context.Context, name string) (store.Ingredient, error) {
	if m.getIngByNameFunc != nil {
		return m.getIngByNameFunc(ctx, name)
	}
	return store.Ingredient{}, pgx.ErrNoRows
}

func (m *mockInventoryQuerier) CreateIngredient(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error) {
	if m.createIngFunc != nil {
		return m.createIngFunc(ctx, arg)
	}
	return store.Ingredient{
		ID:          100,
		Name:        arg.Name,
		Category:    arg.Category,
		DefaultUnit: arg.DefaultUnit,
	}, nil
}

func (m *mockInventoryQuerier) ListInventoryItemsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
	if m.listFunc != nil {
		return m.listFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockInventoryQuerier) GetInventoryItemByIDAndUserID(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
	if m.getFunc != nil {
		return m.getFunc(ctx, arg)
	}
	return store.GetInventoryItemByIDAndUserIDRow{}, pgx.ErrNoRows
}

func (m *mockInventoryQuerier) CreateInventoryItem(ctx context.Context, arg store.CreateInventoryItemParams) (store.InventoryItem, error) {
	if m.createFunc != nil {
		return m.createFunc(ctx, arg)
	}
	return store.InventoryItem{}, nil
}

func (m *mockInventoryQuerier) UpdateInventoryItem(ctx context.Context, arg store.UpdateInventoryItemParams) (store.InventoryItem, error) {
	if m.updateFunc != nil {
		return m.updateFunc(ctx, arg)
	}
	return store.InventoryItem{}, nil
}

func (m *mockInventoryQuerier) DeleteInventoryItem(ctx context.Context, arg store.DeleteInventoryItemParams) error {
	if m.deleteFunc != nil {
		return m.deleteFunc(ctx, arg)
	}
	return nil
}

func TestInventoryService_List(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockStore := &mockInventoryQuerier{
		listFunc: func(ctx context.Context, userID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
			assert.Equal(t, uid, uuid.UUID(userID.Bytes))
			return []store.ListInventoryItemsByUserIDRow{
				{
					ID:             pgtype.UUID{Bytes: itemID, Valid: true},
					UserID:         pgtype.UUID{Bytes: uid, Valid: true},
					IngredientID:   pgtype.Int4{Int32: 1, Valid: true},
					IngredientName: pgtype.Text{String: "Молоко", Valid: true},
					InStock:        true,
					CreatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
					UpdatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
				},
			}, nil
		},
	}

	svc := service.NewInventoryService(mockStore)
	res, err := svc.List(context.Background(), uid)

	require.NoError(t, err)
	assert.Equal(t, 1, res.Total)
	require.Len(t, res.Items, 1)
	assert.Equal(t, itemID.String(), res.Items[0].ID)
	assert.Equal(t, "Молоко", res.Items[0].Name)
	assert.True(t, res.Items[0].InStock)
}

func TestInventoryService_GetByID_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockStore := &mockInventoryQuerier{
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{
				ID:         pgtype.UUID{Bytes: itemID, Valid: true},
				UserID:     pgtype.UUID{Bytes: uid, Valid: true},
				CustomName: pgtype.Text{String: "Домашний соус", Valid: true},
				InStock:    true,
				CreatedAt:  pgtype.Timestamptz{Time: time.Now(), Valid: true},
				UpdatedAt:  pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}, nil
		},
	}

	svc := service.NewInventoryService(mockStore)
	res, err := svc.GetByID(context.Background(), uid, itemID)

	require.NoError(t, err)
	require.NotNil(t, res)
	assert.Equal(t, "Домашний соус", res.Name)
}

func TestInventoryService_GetByID_NotFound(t *testing.T) {
	mockStore := &mockInventoryQuerier{
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{}, pgx.ErrNoRows
		},
	}

	svc := service.NewInventoryService(mockStore)
	res, err := svc.GetByID(context.Background(), uuid.New(), uuid.New())

	require.ErrorIs(t, err, service.ErrInventoryItemNotFound)
	assert.Nil(t, res)
}

func TestInventoryService_Create_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	ingID := int32(5)
	amount := 500.0
	unit := "g"
	approx := "medium"
	expDate := "2026-11-15"

	mockStore := &mockInventoryQuerier{
		createFunc: func(ctx context.Context, arg store.CreateInventoryItemParams) (store.InventoryItem, error) {
			assert.Equal(t, uid, uuid.UUID(arg.UserID.Bytes))
			assert.Equal(t, ingID, arg.IngredientID.Int32)
			return store.InventoryItem{
				ID: pgtype.UUID{Bytes: itemID, Valid: true},
			}, nil
		},
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{
				ID:             pgtype.UUID{Bytes: itemID, Valid: true},
				UserID:         pgtype.UUID{Bytes: uid, Valid: true},
				IngredientID:   pgtype.Int4{Int32: ingID, Valid: true},
				IngredientName: pgtype.Text{String: "Куриное филе", Valid: true},
				InStock:        true,
				CreatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
				UpdatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}, nil
		},
	}

	svc := service.NewInventoryService(mockStore)
	res, err := svc.Create(context.Background(), uid, dto.CreateInventoryItemRequest{
		IngredientID:        &ingID,
		Amount:              &amount,
		Unit:                &unit,
		ApproximateQuantity: &approx,
		ExpirationDate:      &expDate,
	})

	require.NoError(t, err)
	require.NotNil(t, res)
	assert.Equal(t, "Куриное филе", res.Name)
}

func TestInventoryService_Create_CustomIngredient_AutoCreated(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	customName := "Паприка копченая"
	unit := "ч. л."

	createdIngCalled := false
	mockStore := &mockInventoryQuerier{
		getIngByNameFunc: func(ctx context.Context, name string) (store.Ingredient, error) {
			assert.Equal(t, "паприка копченая", name)
			return store.Ingredient{}, pgx.ErrNoRows
		},
		createIngFunc: func(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error) {
			createdIngCalled = true
			assert.Equal(t, "паприка копченая", arg.Name)
			return store.Ingredient{
				ID:          42,
				Name:        arg.Name,
				Category:    arg.Category,
				DefaultUnit: arg.DefaultUnit,
			}, nil
		},
		createFunc: func(ctx context.Context, arg store.CreateInventoryItemParams) (store.InventoryItem, error) {
			assert.True(t, arg.IngredientID.Valid)
			assert.Equal(t, int32(42), arg.IngredientID.Int32)
			assert.Equal(t, customName, arg.CustomName.String)
			return store.InventoryItem{
				ID: pgtype.UUID{Bytes: itemID, Valid: true},
			}, nil
		},
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{
				ID:             pgtype.UUID{Bytes: itemID, Valid: true},
				UserID:         pgtype.UUID{Bytes: uid, Valid: true},
				IngredientID:   pgtype.Int4{Int32: 42, Valid: true},
				IngredientName: pgtype.Text{String: "паприка копченая", Valid: true},
				CustomName:     pgtype.Text{String: customName, Valid: true},
				InStock:        true,
				CreatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
				UpdatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}, nil
		},
	}

	svc := service.NewInventoryService(mockStore)
	res, err := svc.Create(context.Background(), uid, dto.CreateInventoryItemRequest{
		CustomName: &customName,
		Unit:       &unit,
	})

	require.NoError(t, err)
	require.NotNil(t, res)
	assert.True(t, createdIngCalled)
	assert.Equal(t, "паприка копченая", res.Name)
	assert.Equal(t, int32(42), *res.IngredientID)
}

func TestInventoryService_Create_ValidationErrors(t *testing.T) {
	svc := service.NewInventoryService(&mockInventoryQuerier{})

	// Missing both ingredient_id and custom_name
	_, err := svc.Create(context.Background(), uuid.New(), dto.CreateInventoryItemRequest{})
	require.ErrorIs(t, err, service.ErrInvalidInventoryItem)

	// Invalid date
	cust := "test"
	badDate := "not-a-date"
	_, err = svc.Create(context.Background(), uuid.New(), dto.CreateInventoryItemRequest{
		CustomName:     &cust,
		ExpirationDate: &badDate,
	})
	require.ErrorIs(t, err, service.ErrInvalidExpirationDate)
}

func TestInventoryService_Update_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	inStock := false
	expDate := "2026-12-01"

	mockStore := &mockInventoryQuerier{
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{
				ID:         pgtype.UUID{Bytes: itemID, Valid: true},
				UserID:     pgtype.UUID{Bytes: uid, Valid: true},
				CustomName: pgtype.Text{String: "Суп", Valid: true},
				InStock:    inStock,
				CreatedAt:  pgtype.Timestamptz{Time: time.Now(), Valid: true},
				UpdatedAt:  pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}, nil
		},
		updateFunc: func(ctx context.Context, arg store.UpdateInventoryItemParams) (store.InventoryItem, error) {
			assert.Equal(t, itemID, uuid.UUID(arg.ID.Bytes))
			assert.False(t, arg.InStock.Bool)
			return store.InventoryItem{}, nil
		},
	}

	svc := service.NewInventoryService(mockStore)
	res, err := svc.Update(context.Background(), uid, itemID, dto.UpdateInventoryItemRequest{
		InStock:        &inStock,
		ExpirationDate: &expDate,
	})

	require.NoError(t, err)
	require.NotNil(t, res)
	assert.False(t, res.InStock)
}

func TestInventoryService_Delete_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	deleted := false

	mockStore := &mockInventoryQuerier{
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{
				ID:     pgtype.UUID{Bytes: itemID, Valid: true},
				UserID: pgtype.UUID{Bytes: uid, Valid: true},
			}, nil
		},
		deleteFunc: func(ctx context.Context, arg store.DeleteInventoryItemParams) error {
			deleted = true
			return nil
		},
	}

	svc := service.NewInventoryService(mockStore)
	err := svc.Delete(context.Background(), uid, itemID)

	require.NoError(t, err)
	assert.True(t, deleted)
}

func TestInventoryService_Delete_NotFound(t *testing.T) {
	mockStore := &mockInventoryQuerier{
		getFunc: func(ctx context.Context, arg store.GetInventoryItemByIDAndUserIDParams) (store.GetInventoryItemByIDAndUserIDRow, error) {
			return store.GetInventoryItemByIDAndUserIDRow{}, pgx.ErrNoRows
		},
	}

	svc := service.NewInventoryService(mockStore)
	err := svc.Delete(context.Background(), uuid.New(), uuid.New())

	require.ErrorIs(t, err, service.ErrInventoryItemNotFound)
}
