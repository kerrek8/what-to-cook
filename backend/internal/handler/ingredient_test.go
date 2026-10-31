package handler_test

import (
	"context"
	"encoding/json"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockIngredientService struct {
	searchFunc  func(ctx context.Context, filter dto.IngredientFilterQuery) (dto.IngredientListResponse, error)
	getByIDFunc func(ctx context.Context, id int32) (*dto.IngredientResponse, error)
}

func (m *mockIngredientService) Search(ctx context.Context, filter dto.IngredientFilterQuery) (dto.IngredientListResponse, error) {
	if m.searchFunc != nil {
		return m.searchFunc(ctx, filter)
	}
	return dto.IngredientListResponse{}, nil
}

func (m *mockIngredientService) GetByID(ctx context.Context, id int32) (*dto.IngredientResponse, error) {
	if m.getByIDFunc != nil {
		return m.getByIDFunc(ctx, id)
	}
	return nil, service.ErrIngredientNotFound
}

func setupIngredientTestRouter(svc service.IngredientService) *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.New()
	h := handler.NewIngredientHandler(svc)
	api := r.Group("/api/v1")
	{
		api.GET("/ingredients", h.List)
		api.GET("/ingredients/:id", h.GetByID)
	}
	return r
}

func TestIngredientHandler_List_Success(t *testing.T) {
	mockSvc := &mockIngredientService{
		searchFunc: func(ctx context.Context, filter dto.IngredientFilterQuery) (dto.IngredientListResponse, error) {
			assert.Equal(t, "лук", filter.Query)
			assert.Equal(t, "vegetables", filter.Category)
			return dto.IngredientListResponse{
				Items: []dto.IngredientResponse{
					{
						ID:                1,
						Name:              "Лук репчатый",
						Category:          "vegetables",
						DefaultUnit:       "g",
						IsPantryEssential: false,
					},
				},
				Total: 1,
			}, nil
		},
	}

	router := setupIngredientTestRouter(mockSvc)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/ingredients?q=лук&category=vegetables", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.IngredientListResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 1, resp.Total)
	require.Len(t, resp.Items, 1)
	assert.Equal(t, "Лук репчатый", resp.Items[0].Name)
}

func TestIngredientHandler_List_ServiceError(t *testing.T) {
	mockSvc := &mockIngredientService{
		searchFunc: func(ctx context.Context, filter dto.IngredientFilterQuery) (dto.IngredientListResponse, error) {
			return dto.IngredientListResponse{}, errors.New("db error")
		},
	}

	router := setupIngredientTestRouter(mockSvc)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/ingredients", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
}

func TestIngredientHandler_GetByID_Success(t *testing.T) {
	mockSvc := &mockIngredientService{
		getByIDFunc: func(ctx context.Context, id int32) (*dto.IngredientResponse, error) {
			return &dto.IngredientResponse{
				ID:                id,
				Name:              "Соль",
				Category:          "spices",
				DefaultUnit:       "g",
				IsPantryEssential: true,
			}, nil
		},
	}

	router := setupIngredientTestRouter(mockSvc)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/ingredients/5", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.IngredientResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, int32(5), resp.ID)
	assert.Equal(t, "Соль", resp.Name)
	assert.True(t, resp.IsPantryEssential)
}

func TestIngredientHandler_GetByID_InvalidID(t *testing.T) {
	router := setupIngredientTestRouter(&mockIngredientService{})

	testCases := []string{
		"/api/v1/ingredients/abc",
		"/api/v1/ingredients/0",
		"/api/v1/ingredients/-1",
	}

	for _, tc := range testCases {
		req := httptest.NewRequest(http.MethodGet, tc, nil)
		w := httptest.NewRecorder()
		router.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	}
}

func TestIngredientHandler_GetByID_NotFound(t *testing.T) {
	mockSvc := &mockIngredientService{
		getByIDFunc: func(ctx context.Context, id int32) (*dto.IngredientResponse, error) {
			return nil, service.ErrIngredientNotFound
		},
	}

	router := setupIngredientTestRouter(mockSvc)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/ingredients/999", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestIngredientHandler_GetByID_ServiceError(t *testing.T) {
	mockSvc := &mockIngredientService{
		getByIDFunc: func(ctx context.Context, id int32) (*dto.IngredientResponse, error) {
			return nil, errors.New("db failure")
		},
	}

	router := setupIngredientTestRouter(mockSvc)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/ingredients/1", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)

	assert.Equal(t, http.StatusInternalServerError, w.Code)
}
