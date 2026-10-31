package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockInventoryService struct {
	listFunc   func(ctx context.Context, userID uuid.UUID) (dto.InventoryListResponse, error)
	getFunc    func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.InventoryItemResponse, error)
	createFunc func(ctx context.Context, userID uuid.UUID, req dto.CreateInventoryItemRequest) (*dto.InventoryItemResponse, error)
	updateFunc func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateInventoryItemRequest) (*dto.InventoryItemResponse, error)
	deleteFunc func(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error
}

func (m *mockInventoryService) List(ctx context.Context, userID uuid.UUID) (dto.InventoryListResponse, error) {
	if m.listFunc != nil {
		return m.listFunc(ctx, userID)
	}
	return dto.InventoryListResponse{}, nil
}

func (m *mockInventoryService) GetByID(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) (*dto.InventoryItemResponse, error) {
	if m.getFunc != nil {
		return m.getFunc(ctx, userID, itemID)
	}
	return nil, service.ErrInventoryItemNotFound
}

func (m *mockInventoryService) Create(ctx context.Context, userID uuid.UUID, req dto.CreateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
	if m.createFunc != nil {
		return m.createFunc(ctx, userID, req)
	}
	return nil, nil
}

func (m *mockInventoryService) Update(ctx context.Context, userID uuid.UUID, itemID uuid.UUID, req dto.UpdateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
	if m.updateFunc != nil {
		return m.updateFunc(ctx, userID, itemID, req)
	}
	return nil, service.ErrInventoryItemNotFound
}

func (m *mockInventoryService) Delete(ctx context.Context, userID uuid.UUID, itemID uuid.UUID) error {
	if m.deleteFunc != nil {
		return m.deleteFunc(ctx, userID, itemID)
	}
	return nil
}

func setupInventoryTestRouter(svc service.InventoryService, authUserID uuid.UUID) *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.New()

	authInjector := func(c *gin.Context) {
		if authUserID != uuid.Nil {
			c.Set(middleware.ContextUserIDKey, authUserID.String())
		}
		c.Next()
	}

	h := handler.NewInventoryHandler(svc)
	inv := r.Group("/api/v1/inventory", authInjector)
	{
		inv.GET("", h.List)
		inv.POST("", h.Create)
		inv.GET("/:id", h.GetByID)
		inv.PUT("/:id", h.Update)
		inv.DELETE("/:id", h.Delete)
	}
	return r
}

func TestInventoryHandler_List_Success(t *testing.T) {
	uid := uuid.New()
	mockSvc := &mockInventoryService{
		listFunc: func(ctx context.Context, userID uuid.UUID) (dto.InventoryListResponse, error) {
			assert.Equal(t, uid, userID)
			return dto.InventoryListResponse{
				Items: []dto.InventoryItemResponse{
					{
						ID:       uuid.New().String(),
						Name:     "Молоко",
						Category: "dairy",
						InStock:  true,
					},
				},
				Total: 1,
			}, nil
		},
	}

	r := setupInventoryTestRouter(mockSvc, uid)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/inventory", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.InventoryListResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 1, resp.Total)
}

func TestInventoryHandler_GetByID_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()

	mockSvc := &mockInventoryService{
		getFunc: func(ctx context.Context, userID, id uuid.UUID) (*dto.InventoryItemResponse, error) {
			assert.Equal(t, itemID, id)
			return &dto.InventoryItemResponse{
				ID:   id.String(),
				Name: "Сыр",
			}, nil
		},
	}

	r := setupInventoryTestRouter(mockSvc, uid)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/inventory/"+itemID.String(), nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestInventoryHandler_GetByID_InvalidID(t *testing.T) {
	r := setupInventoryTestRouter(&mockInventoryService{}, uuid.New())
	req := httptest.NewRequest(http.MethodGet, "/api/v1/inventory/invalid-uuid", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestInventoryHandler_GetByID_NotFound(t *testing.T) {
	r := setupInventoryTestRouter(&mockInventoryService{}, uuid.New())
	req := httptest.NewRequest(http.MethodGet, "/api/v1/inventory/"+uuid.New().String(), nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestInventoryHandler_Create_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	ingID := int32(2)

	mockSvc := &mockInventoryService{
		createFunc: func(ctx context.Context, userID uuid.UUID, req dto.CreateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
			assert.Equal(t, &ingID, req.IngredientID)
			return &dto.InventoryItemResponse{
				ID:   itemID.String(),
				Name: "Сахар",
			}, nil
		},
	}

	r := setupInventoryTestRouter(mockSvc, uid)
	body, _ := json.Marshal(dto.CreateInventoryItemRequest{
		IngredientID: &ingID,
	})
	req := httptest.NewRequest(http.MethodPost, "/api/v1/inventory", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)
}

func TestInventoryHandler_Create_InvalidPayload(t *testing.T) {
	mockSvc := &mockInventoryService{
		createFunc: func(ctx context.Context, userID uuid.UUID, req dto.CreateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
			return nil, service.ErrInvalidInventoryItem
		},
	}

	r := setupInventoryTestRouter(mockSvc, uuid.New())
	req := httptest.NewRequest(http.MethodPost, "/api/v1/inventory", bytes.NewReader([]byte("{}")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestInventoryHandler_Update_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	inStock := false

	mockSvc := &mockInventoryService{
		updateFunc: func(ctx context.Context, userID, id uuid.UUID, req dto.UpdateInventoryItemRequest) (*dto.InventoryItemResponse, error) {
			return &dto.InventoryItemResponse{
				ID:      id.String(),
				InStock: inStock,
			}, nil
		},
	}

	r := setupInventoryTestRouter(mockSvc, uid)
	body, _ := json.Marshal(dto.UpdateInventoryItemRequest{
		InStock: &inStock,
	})
	req := httptest.NewRequest(http.MethodPut, "/api/v1/inventory/"+itemID.String(), bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
}

func TestInventoryHandler_Delete_Success(t *testing.T) {
	uid := uuid.New()
	itemID := uuid.New()
	deleted := false

	mockSvc := &mockInventoryService{
		deleteFunc: func(ctx context.Context, userID, id uuid.UUID) error {
			deleted = true
			return nil
		},
	}

	r := setupInventoryTestRouter(mockSvc, uid)
	req := httptest.NewRequest(http.MethodDelete, "/api/v1/inventory/"+itemID.String(), nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNoContent, w.Code)
	assert.True(t, deleted)
}

func TestInventoryHandler_Delete_NotFound(t *testing.T) {
	mockSvc := &mockInventoryService{
		deleteFunc: func(ctx context.Context, userID, id uuid.UUID) error {
			return service.ErrInventoryItemNotFound
		},
	}

	r := setupInventoryTestRouter(mockSvc, uuid.New())
	req := httptest.NewRequest(http.MethodDelete, "/api/v1/inventory/"+uuid.New().String(), nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}
