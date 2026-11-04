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

type mockShoppingQuerier struct {
	store.Querier
	listFunc                      func(ctx context.Context, userID pgtype.UUID) ([]store.ListShoppingItemsByUserIDRow, error)
	getFunc                       func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error)
	createFunc                    func(ctx context.Context, arg store.CreateShoppingItemParams) (store.ShoppingListItem, error)
	updateFunc                    func(ctx context.Context, arg store.UpdateShoppingItemParams) (store.ShoppingListItem, error)
	setStatusFunc                 func(ctx context.Context, arg store.SetShoppingItemBoughtStatusParams) (store.ShoppingListItem, error)
	deleteFunc                    func(ctx context.Context, arg store.DeleteShoppingItemParams) error
	getRecipeFunc                 func(ctx context.Context, id int32) (store.Recipe, error)
	getRecipeIngredientsFunc      func(ctx context.Context, recipeID int32) ([]store.GetRecipeIngredientsRow, error)
	listInventoryFunc             func(ctx context.Context, userID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error)
	getShoppingByIngredientFunc   func(ctx context.Context, arg store.GetShoppingItemByIngredientAndUserIDParams) (store.ShoppingListItem, error)
	transferBoughtItemsFunc       func(ctx context.Context, userID pgtype.UUID) ([]store.InventoryItem, error)
	deleteBoughtShoppingItemsFunc func(ctx context.Context, userID pgtype.UUID) error
	getIngByNameFunc              func(ctx context.Context, name string) (store.Ingredient, error)
	createIngFunc                 func(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error)
}

func (m *mockShoppingQuerier) GetIngredientByNameCaseInsensitive(ctx context.Context, name string) (store.Ingredient, error) {
	if m.getIngByNameFunc != nil {
		return m.getIngByNameFunc(ctx, name)
	}
	return store.Ingredient{}, pgx.ErrNoRows
}

func (m *mockShoppingQuerier) CreateIngredient(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error) {
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

func (m *mockShoppingQuerier) ListShoppingItemsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.ListShoppingItemsByUserIDRow, error) {
	if m.listFunc != nil {
		return m.listFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockShoppingQuerier) GetShoppingItemByIDAndUserID(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
	if m.getFunc != nil {
		return m.getFunc(ctx, arg)
	}
	return store.GetShoppingItemByIDAndUserIDRow{}, pgx.ErrNoRows
}

func (m *mockShoppingQuerier) CreateShoppingItem(ctx context.Context, arg store.CreateShoppingItemParams) (store.ShoppingListItem, error) {
	if m.createFunc != nil {
		return m.createFunc(ctx, arg)
	}
	return store.ShoppingListItem{}, nil
}

func (m *mockShoppingQuerier) UpdateShoppingItem(ctx context.Context, arg store.UpdateShoppingItemParams) (store.ShoppingListItem, error) {
	if m.updateFunc != nil {
		return m.updateFunc(ctx, arg)
	}
	return store.ShoppingListItem{}, nil
}

func (m *mockShoppingQuerier) SetShoppingItemBoughtStatus(ctx context.Context, arg store.SetShoppingItemBoughtStatusParams) (store.ShoppingListItem, error) {
	if m.setStatusFunc != nil {
		return m.setStatusFunc(ctx, arg)
	}
	return store.ShoppingListItem{}, nil
}

func (m *mockShoppingQuerier) DeleteShoppingItem(ctx context.Context, arg store.DeleteShoppingItemParams) error {
	if m.deleteFunc != nil {
		return m.deleteFunc(ctx, arg)
	}
	return nil
}

func (m *mockShoppingQuerier) GetRecipeByID(ctx context.Context, id int32) (store.Recipe, error) {
	if m.getRecipeFunc != nil {
		return m.getRecipeFunc(ctx, id)
	}
	return store.Recipe{}, pgx.ErrNoRows
}

func (m *mockShoppingQuerier) GetRecipeIngredients(ctx context.Context, recipeID int32) ([]store.GetRecipeIngredientsRow, error) {
	if m.getRecipeIngredientsFunc != nil {
		return m.getRecipeIngredientsFunc(ctx, recipeID)
	}
	return nil, nil
}

func (m *mockShoppingQuerier) ListInventoryItemsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
	if m.listInventoryFunc != nil {
		return m.listInventoryFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockShoppingQuerier) GetShoppingItemByIngredientAndUserID(ctx context.Context, arg store.GetShoppingItemByIngredientAndUserIDParams) (store.ShoppingListItem, error) {
	if m.getShoppingByIngredientFunc != nil {
		return m.getShoppingByIngredientFunc(ctx, arg)
	}
	return store.ShoppingListItem{}, pgx.ErrNoRows
}

func (m *mockShoppingQuerier) TransferBoughtItemsToInventory(ctx context.Context, userID pgtype.UUID) ([]store.InventoryItem, error) {
	if m.transferBoughtItemsFunc != nil {
		return m.transferBoughtItemsFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockShoppingQuerier) DeleteBoughtShoppingItemsByUserID(ctx context.Context, userID pgtype.UUID) error {
	if m.deleteBoughtShoppingItemsFunc != nil {
		return m.deleteBoughtShoppingItemsFunc(ctx, userID)
	}
	return nil
}

func TestShoppingService_List(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockStore := &mockShoppingQuerier{
		listFunc: func(ctx context.Context, userID pgtype.UUID) ([]store.ListShoppingItemsByUserIDRow, error) {
			assert.Equal(t, uid, uuid.UUID(userID.Bytes))
			return []store.ListShoppingItemsByUserIDRow{
				{
					ID:             pgtype.UUID{Bytes: itemID, Valid: true},
					UserID:         userID,
					IngredientID:   pgtype.Int4{Int32: 10, Valid: true},
					IngredientName: pgtype.Text{String: "Молоко", Valid: true},
					IsBought:       false,
					CreatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
					UpdatedAt:      pgtype.Timestamptz{Time: time.Now(), Valid: true},
				},
			}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.List(context.Background(), uid)

	require.NoError(t, err)
	assert.Equal(t, 1, res.Total)
	assert.Equal(t, itemID.String(), res.Items[0].ID)
	assert.Equal(t, "Молоко", res.Items[0].Name)
	assert.False(t, res.Items[0].IsBought)
}

func TestShoppingService_GetByID_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockStore := &mockShoppingQuerier{
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			assert.Equal(t, itemID, uuid.UUID(arg.ID.Bytes))
			assert.Equal(t, uid, uuid.UUID(arg.UserID.Bytes))
			return store.GetShoppingItemByIDAndUserIDRow{
				ID:             arg.ID,
				UserID:         arg.UserID,
				IngredientID:   pgtype.Int4{Int32: 5, Valid: true},
				IngredientName: pgtype.Text{String: "Томаты", Valid: true},
				IsBought:       true,
			}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.GetByID(context.Background(), uid, itemID)

	require.NoError(t, err)
	assert.Equal(t, itemID.String(), res.ID)
	assert.Equal(t, "Томаты", res.Name)
	assert.True(t, res.IsBought)
}

func TestShoppingService_GetByID_NotFound(t *testing.T) {
	mockStore := &mockShoppingQuerier{
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{}, pgx.ErrNoRows
		},
	}

	svc := service.NewShoppingService(mockStore)
	_, err := svc.GetByID(context.Background(), uuid.New(), uuid.New())

	assert.ErrorIs(t, err, service.ErrShoppingItemNotFound)
}

func TestShoppingService_Create_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	ingID := int32(42)
	amount := 250.0
	unit := "g"

	mockStore := &mockShoppingQuerier{
		createFunc: func(ctx context.Context, arg store.CreateShoppingItemParams) (store.ShoppingListItem, error) {
			assert.Equal(t, uid, uuid.UUID(arg.UserID.Bytes))
			assert.Equal(t, ingID, arg.IngredientID.Int32)
			return store.ShoppingListItem{
				ID: arg.UserID,
			}, nil
		},
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{
				ID:             pgtype.UUID{Bytes: itemID, Valid: true},
				UserID:         arg.UserID,
				IngredientID:   pgtype.Int4{Int32: ingID, Valid: true},
				IngredientName: pgtype.Text{String: "Сыр Чеддер", Valid: true},
				Unit:           pgtype.Text{String: unit, Valid: true},
			}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.Create(context.Background(), uid, dto.CreateShoppingItemRequest{
		IngredientID: &ingID,
		Amount:       &amount,
		Unit:         &unit,
	})

	require.NoError(t, err)
	assert.Equal(t, itemID.String(), res.ID)
	assert.Equal(t, "Сыр Чеддер", res.Name)
}

func TestShoppingService_Create_CustomIngredient_AutoCreated(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	customName := "Кинза свежая"
	unit := "пучок"

	createdIngCalled := false
	mockStore := &mockShoppingQuerier{
		getIngByNameFunc: func(ctx context.Context, name string) (store.Ingredient, error) {
			assert.Equal(t, "кинза свежая", name)
			return store.Ingredient{}, pgx.ErrNoRows
		},
		createIngFunc: func(ctx context.Context, arg store.CreateIngredientParams) (store.Ingredient, error) {
			createdIngCalled = true
			assert.Equal(t, "кинза свежая", arg.Name)
			return store.Ingredient{
				ID:          55,
				Name:        arg.Name,
				Category:    arg.Category,
				DefaultUnit: arg.DefaultUnit,
			}, nil
		},
		createFunc: func(ctx context.Context, arg store.CreateShoppingItemParams) (store.ShoppingListItem, error) {
			assert.True(t, arg.IngredientID.Valid)
			assert.Equal(t, int32(55), arg.IngredientID.Int32)
			assert.Equal(t, customName, arg.CustomName.String)
			return store.ShoppingListItem{
				ID: pgtype.UUID{Bytes: itemID, Valid: true},
			}, nil
		},
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{
				ID:             pgtype.UUID{Bytes: itemID, Valid: true},
				UserID:         arg.UserID,
				IngredientID:   pgtype.Int4{Int32: 55, Valid: true},
				IngredientName: pgtype.Text{String: "кинза свежая", Valid: true},
				CustomName:     pgtype.Text{String: customName, Valid: true},
			}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.Create(context.Background(), uid, dto.CreateShoppingItemRequest{
		CustomName: &customName,
		Unit:       &unit,
	})

	require.NoError(t, err)
	require.NotNil(t, res)
	assert.True(t, createdIngCalled)
	assert.Equal(t, "кинза свежая", res.Name)
	assert.Equal(t, int32(55), *res.IngredientID)
}

func TestShoppingService_Create_ValidationErrors(t *testing.T) {
	svc := service.NewShoppingService(&mockShoppingQuerier{})

	_, err := svc.Create(context.Background(), uuid.New(), dto.CreateShoppingItemRequest{})
	assert.ErrorIs(t, err, service.ErrInvalidShoppingItem)

	emptyName := "   "
	_, err = svc.Create(context.Background(), uuid.New(), dto.CreateShoppingItemRequest{
		CustomName: &emptyName,
	})
	assert.ErrorIs(t, err, service.ErrInvalidShoppingItem)
}

func TestShoppingService_Update_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	isBought := true

	mockStore := &mockShoppingQuerier{
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{
				ID:             arg.ID,
				UserID:         arg.UserID,
				IngredientName: pgtype.Text{String: "Яблоки", Valid: true},
				IsBought:       isBought,
			}, nil
		},
		updateFunc: func(ctx context.Context, arg store.UpdateShoppingItemParams) (store.ShoppingListItem, error) {
			assert.Equal(t, itemID, uuid.UUID(arg.ID.Bytes))
			assert.Equal(t, isBought, arg.IsBought.Bool)
			return store.ShoppingListItem{}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.Update(context.Background(), uid, itemID, dto.UpdateShoppingItemRequest{
		IsBought: &isBought,
	})

	require.NoError(t, err)
	assert.True(t, res.IsBought)
}

func TestShoppingService_SetStatus(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockStore := &mockShoppingQuerier{
		setStatusFunc: func(ctx context.Context, arg store.SetShoppingItemBoughtStatusParams) (store.ShoppingListItem, error) {
			assert.Equal(t, itemID, uuid.UUID(arg.ID.Bytes))
			assert.True(t, arg.IsBought)
			return store.ShoppingListItem{}, nil
		},
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{
				ID:             arg.ID,
				UserID:         arg.UserID,
				IngredientName: pgtype.Text{String: "Хлеб", Valid: true},
				IsBought:       true,
			}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.SetStatus(context.Background(), uid, itemID, true)

	require.NoError(t, err)
	assert.True(t, res.IsBought)
}

func TestShoppingService_Delete_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockStore := &mockShoppingQuerier{
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{ID: arg.ID, UserID: arg.UserID}, nil
		},
		deleteFunc: func(ctx context.Context, arg store.DeleteShoppingItemParams) error {
			assert.Equal(t, itemID, uuid.UUID(arg.ID.Bytes))
			assert.Equal(t, uid, uuid.UUID(arg.UserID.Bytes))
			return nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	err := svc.Delete(context.Background(), uid, itemID)

	require.NoError(t, err)
}

func TestShoppingService_Delete_NotFound(t *testing.T) {
	mockStore := &mockShoppingQuerier{
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{}, pgx.ErrNoRows
		},
	}

	svc := service.NewShoppingService(mockStore)
	err := svc.Delete(context.Background(), uuid.New(), uuid.New())

	assert.ErrorIs(t, err, service.ErrShoppingItemNotFound)
}

func TestShoppingService_AddMissingFromRecipe(t *testing.T) {
	uid := uuid.New()
	recipeID := int32(101)

	createdCount := 0
	mockStore := &mockShoppingQuerier{
		getRecipeFunc: func(ctx context.Context, id int32) (store.Recipe, error) {
			assert.Equal(t, recipeID, id)
			return store.Recipe{ID: id, Title: "Паста Карбонара"}, nil
		},
		getRecipeIngredientsFunc: func(ctx context.Context, rID int32) ([]store.GetRecipeIngredientsRow, error) {
			return []store.GetRecipeIngredientsRow{
				{
					IngredientID:      1,
					IngredientName:    "Соль",
					IsPantryEssential: true,
				},
				{
					IngredientID:      2,
					IngredientName:    "Спагетти",
					IsPantryEssential: false,
				},
				{
					IngredientID:      3,
					IngredientName:    "Бекон",
					IsPantryEssential: false,
				},
				{
					IngredientID:      4,
					IngredientName:    "Пармезан",
					IsPantryEssential: false,
				},
			}, nil
		},
		listInventoryFunc: func(ctx context.Context, uID pgtype.UUID) ([]store.ListInventoryItemsByUserIDRow, error) {
			return []store.ListInventoryItemsByUserIDRow{
				{
					IngredientID: pgtype.Int4{Int32: 2, Valid: true},
					InStock:      true,
				},
			}, nil
		},
		getShoppingByIngredientFunc: func(ctx context.Context, arg store.GetShoppingItemByIngredientAndUserIDParams) (store.ShoppingListItem, error) {
			if arg.IngredientID.Int32 == 4 {
				return store.ShoppingListItem{
					ID:       pgtype.UUID{Bytes: uuid.New(), Valid: true},
					IsBought: false,
				}, nil
			}
			return store.ShoppingListItem{}, pgx.ErrNoRows
		},
		createFunc: func(ctx context.Context, arg store.CreateShoppingItemParams) (store.ShoppingListItem, error) {
			assert.Equal(t, int32(3), arg.IngredientID.Int32)
			createdCount++
			return store.ShoppingListItem{
				ID: pgtype.UUID{Bytes: uuid.New(), Valid: true},
			}, nil
		},
		getFunc: func(ctx context.Context, arg store.GetShoppingItemByIDAndUserIDParams) (store.GetShoppingItemByIDAndUserIDRow, error) {
			return store.GetShoppingItemByIDAndUserIDRow{
				ID:             arg.ID,
				UserID:         arg.UserID,
				IngredientID:   pgtype.Int4{Int32: 3, Valid: true},
				IngredientName: pgtype.Text{String: "Бекон", Valid: true},
			}, nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.AddMissingFromRecipe(context.Background(), uid, recipeID)

	require.NoError(t, err)
	assert.Equal(t, recipeID, res.RecipeID)
	assert.Equal(t, 1, res.AddedCount)
	assert.Equal(t, 1, createdCount)
	assert.Len(t, res.Items, 1)
	assert.Equal(t, "Бекон", res.Items[0].Name)
}

func TestShoppingService_TransferToInventory(t *testing.T) {
	uid := uuid.New()
	deletedCalled := false

	mockStore := &mockShoppingQuerier{
		transferBoughtItemsFunc: func(ctx context.Context, userID pgtype.UUID) ([]store.InventoryItem, error) {
			assert.Equal(t, uid, uuid.UUID(userID.Bytes))
			return []store.InventoryItem{
				{ID: pgtype.UUID{Bytes: uuid.New(), Valid: true}},
				{ID: pgtype.UUID{Bytes: uuid.New(), Valid: true}},
			}, nil
		},
		deleteBoughtShoppingItemsFunc: func(ctx context.Context, userID pgtype.UUID) error {
			assert.Equal(t, uid, uuid.UUID(userID.Bytes))
			deletedCalled = true
			return nil
		},
	}

	svc := service.NewShoppingService(mockStore)
	res, err := svc.TransferToInventory(context.Background(), uid)

	require.NoError(t, err)
	assert.Equal(t, 2, res.TransferredCount)
	assert.True(t, deletedCalled)
}
