package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockShoppingService struct {
	listFunc                func(ctx context.Context, userID uuid.UUID) (dto.ShoppingListResponse, error)
	getFunc                 func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.ShoppingItemResponse, error)
	createFunc              func(ctx context.Context, userID uuid.UUID, req dto.CreateShoppingItemRequest) (*dto.ShoppingItemResponse, error)
	updateFunc              func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateShoppingItemRequest) (*dto.ShoppingItemResponse, error)
	setStatusFunc           func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, isBought bool) (*dto.ShoppingItemResponse, error)
	deleteFunc              func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error
	addMissingFromRecipeFunc func(ctx context.Context, userID uuid.UUID, recipeID int32) (*dto.AddFromRecipeResponse, error)
	transferToInventoryFunc func(ctx context.Context, userID uuid.UUID) (*dto.TransferToInventoryResponse, error)
}

func (m *mockShoppingService) List(ctx context.Context, userID uuid.UUID) (dto.ShoppingListResponse, error) {
	if m.listFunc != nil {
		return m.listFunc(ctx, userID)
	}
	return dto.ShoppingListResponse{}, nil
}

func (m *mockShoppingService) GetByID(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.ShoppingItemResponse, error) {
	if m.getFunc != nil {
		return m.getFunc(ctx, userID, itemID)
	}
	return nil, service.ErrShoppingItemNotFound
}

func (m *mockShoppingService) Create(ctx context.Context, userID uuid.UUID, req dto.CreateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
	if m.createFunc != nil {
		return m.createFunc(ctx, userID, req)
	}
	return nil, nil
}

func (m *mockShoppingService) Update(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
	if m.updateFunc != nil {
		return m.updateFunc(ctx, userID, itemID, req)
	}
	return nil, service.ErrShoppingItemNotFound
}

func (m *mockShoppingService) SetStatus(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, isBought bool) (*dto.ShoppingItemResponse, error) {
	if m.setStatusFunc != nil {
		return m.setStatusFunc(ctx, userID, itemID, isBought)
	}
	return nil, service.ErrShoppingItemNotFound
}

func (m *mockShoppingService) Delete(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error {
	if m.deleteFunc != nil {
		return m.deleteFunc(ctx, userID, itemID)
	}
	return nil
}

func (m *mockShoppingService) AddMissingFromRecipe(ctx context.Context, userID uuid.UUID, recipeID int32) (*dto.AddFromRecipeResponse, error) {
	if m.addMissingFromRecipeFunc != nil {
		return m.addMissingFromRecipeFunc(ctx, userID, recipeID)
	}
	return nil, nil
}

func (m *mockShoppingService) TransferToInventory(ctx context.Context, userID uuid.UUID) (*dto.TransferToInventoryResponse, error) {
	if m.transferToInventoryFunc != nil {
		return m.transferToInventoryFunc(ctx, userID)
	}
	return nil, nil
}

func setupShoppingTestRouter(svc service.ShoppingService, authUserID uuid.UUID) *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.New()

	authInjector := func(c *gin.Context) {
		if authUserID != uuid.Nil {
			c.Set(middleware.ContextUserIDKey, authUserID.String())
		}
		c.Next()
	}

	h := handler.NewShoppingHandler(svc)
	grp := r.Group("/api/v1/shopping-list", authInjector)
	{
		grp.GET("", h.List)
		grp.POST("", h.Create)
		grp.POST("/from-recipe/:id", h.AddFromRecipe)
		grp.PATCH("/:id", h.Update)
		grp.DELETE("/:id", h.Delete)
		grp.POST("/transfer-to-inventory", h.TransferToInventory)
	}

	return r
}

func TestShoppingHandler_List_Success(t *testing.T) {
	userID := uuid.New()
	mockSvc := &mockShoppingService{
		listFunc: func(ctx context.Context, uID uuid.UUID) (dto.ShoppingListResponse, error) {
			assert.Equal(t, userID, uID)
			return dto.ShoppingListResponse{
				Items: []dto.ShoppingItemResponse{
					{
						ID:        uuid.New().String(),
						Name:      "Хлеб",
						IsBought:  false,
						CreatedAt: time.Now(),
					},
				},
				Total: 1,
			}, nil
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/shopping-list", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.ShoppingListResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 1, resp.Total)
	assert.Equal(t, "Хлеб", resp.Items[0].Name)
}

func TestShoppingHandler_Create_Success(t *testing.T) {
	userID := uuid.New()
	name := "Бананы"
	mockSvc := &mockShoppingService{
		createFunc: func(ctx context.Context, uID uuid.UUID, req dto.CreateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
			assert.Equal(t, userID, uID)
			assert.Equal(t, name, *req.CustomName)
			return &dto.ShoppingItemResponse{
				ID:        uuid.New().String(),
				Name:      name,
				IsBought:  false,
				CreatedAt: time.Now(),
			}, nil
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	body, _ := json.Marshal(dto.CreateShoppingItemRequest{
		CustomName: &name,
	})
	req := httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)
	var resp dto.ShoppingItemResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, name, resp.Name)
}

func TestShoppingHandler_Create_InvalidPayload(t *testing.T) {
	userID := uuid.New()
	mockSvc := &mockShoppingService{
		createFunc: func(ctx context.Context, uID uuid.UUID, req dto.CreateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
			return nil, service.ErrInvalidShoppingItem
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list", bytes.NewReader([]byte("{}")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestShoppingHandler_Update_Success(t *testing.T) {
	userID := uuid.New()
	itemID := uuid.New()
	isBought := true

	mockSvc := &mockShoppingService{
		updateFunc: func(ctx context.Context, uID uuid.UUID, iID uuid.UUID, req dto.UpdateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
			assert.Equal(t, userID, uID)
			assert.Equal(t, itemID, iID)
			assert.Equal(t, isBought, *req.IsBought)
			return &dto.ShoppingItemResponse{
				ID:        itemID.String(),
				Name:      "Молоко",
				IsBought:  isBought,
				UpdatedAt: time.Now(),
			}, nil
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	body, _ := json.Marshal(dto.UpdateShoppingItemRequest{
		IsBought: &isBought,
	})
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/shopping-list/"+itemID.String(), bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.ShoppingItemResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.True(t, resp.IsBought)
}

func TestShoppingHandler_Update_NotFound(t *testing.T) {
	userID := uuid.New()
	itemID := uuid.New()
	isBought := true

	mockSvc := &mockShoppingService{
		updateFunc: func(ctx context.Context, uID uuid.UUID, iID uuid.UUID, req dto.UpdateShoppingItemRequest) (*dto.ShoppingItemResponse, error) {
			return nil, service.ErrShoppingItemNotFound
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	body, _ := json.Marshal(dto.UpdateShoppingItemRequest{
		IsBought: &isBought,
	})
	req := httptest.NewRequest(http.MethodPatch, "/api/v1/shopping-list/"+itemID.String(), bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestShoppingHandler_Delete_Success(t *testing.T) {
	userID := uuid.New()
	itemID := uuid.New()

	mockSvc := &mockShoppingService{
		deleteFunc: func(ctx context.Context, uID uuid.UUID, iID uuid.UUID) error {
			assert.Equal(t, userID, uID)
			assert.Equal(t, itemID, iID)
			return nil
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodDelete, "/api/v1/shopping-list/"+itemID.String(), nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNoContent, w.Code)
}

func TestShoppingHandler_Delete_NotFound(t *testing.T) {
	userID := uuid.New()
	itemID := uuid.New()

	mockSvc := &mockShoppingService{
		deleteFunc: func(ctx context.Context, uID uuid.UUID, iID uuid.UUID) error {
			return service.ErrShoppingItemNotFound
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodDelete, "/api/v1/shopping-list/"+itemID.String(), nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestShoppingHandler_AddFromRecipe_Success(t *testing.T) {
	userID := uuid.New()
	recipeID := int32(42)

	mockSvc := &mockShoppingService{
		addMissingFromRecipeFunc: func(ctx context.Context, uID uuid.UUID, rID int32) (*dto.AddFromRecipeResponse, error) {
			assert.Equal(t, userID, uID)
			assert.Equal(t, recipeID, rID)
			return &dto.AddFromRecipeResponse{
				RecipeID:   recipeID,
				AddedCount: 2,
				Items: []dto.ShoppingItemResponse{
					{ID: uuid.New().String(), Name: "Сливки"},
					{ID: uuid.New().String(), Name: "Сыр"},
				},
			}, nil
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list/from-recipe/42", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.AddFromRecipeResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, recipeID, resp.RecipeID)
	assert.Equal(t, 2, resp.AddedCount)
	assert.Len(t, resp.Items, 2)
}

func TestShoppingHandler_AddFromRecipe_NotFound(t *testing.T) {
	userID := uuid.New()
	mockSvc := &mockShoppingService{
		addMissingFromRecipeFunc: func(ctx context.Context, uID uuid.UUID, rID int32) (*dto.AddFromRecipeResponse, error) {
			return nil, service.ErrRecipeNotFound
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list/from-recipe/999", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestShoppingHandler_TransferToInventory_Success(t *testing.T) {
	userID := uuid.New()
	mockSvc := &mockShoppingService{
		transferToInventoryFunc: func(ctx context.Context, uID uuid.UUID) (*dto.TransferToInventoryResponse, error) {
			assert.Equal(t, userID, uID)
			return &dto.TransferToInventoryResponse{
				TransferredCount: 3,
			}, nil
		},
	}

	r := setupShoppingTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodPost, "/api/v1/shopping-list/transfer-to-inventory", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.TransferToInventoryResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 3, resp.TransferredCount)
}
