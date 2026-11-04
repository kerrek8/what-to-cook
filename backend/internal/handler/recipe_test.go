package handler_test

import (
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

type mockRecipeService struct {
	listFunc        func(ctx context.Context, userID *uuid.UUID, q dto.RecipeQuery) (dto.RecipeListResponse, error)
	getByIDFunc     func(ctx context.Context, userID *uuid.UUID, id int32) (*dto.RecipeResponse, error)
	matchFunc       func(ctx context.Context, userID uuid.UUID) (dto.RecipeMatchResponse, error)
	setFavoriteFunc func(ctx context.Context, userID uuid.UUID, recipeID int32, isFav bool) error
	listFavoritesFunc func(ctx context.Context, userID uuid.UUID) ([]dto.RecipeResponse, error)
	syncFunc        func(ctx context.Context, query string) (dto.RecipeSyncResponse, error)
}

func (m *mockRecipeService) List(ctx context.Context, userID *uuid.UUID, q dto.RecipeQuery) (dto.RecipeListResponse, error) {
	if m.listFunc != nil {
		return m.listFunc(ctx, userID, q)
	}
	return dto.RecipeListResponse{}, nil
}

func (m *mockRecipeService) GetByID(ctx context.Context, userID *uuid.UUID, id int32) (*dto.RecipeResponse, error) {
	if m.getByIDFunc != nil {
		return m.getByIDFunc(ctx, userID, id)
	}
	return nil, service.ErrRecipeNotFound
}

func (m *mockRecipeService) Match(ctx context.Context, userID uuid.UUID) (dto.RecipeMatchResponse, error) {
	if m.matchFunc != nil {
		return m.matchFunc(ctx, userID)
	}
	return dto.RecipeMatchResponse{}, nil
}

func (m *mockRecipeService) SetFavorite(ctx context.Context, userID uuid.UUID, recipeID int32, isFav bool) error {
	if m.setFavoriteFunc != nil {
		return m.setFavoriteFunc(ctx, userID, recipeID, isFav)
	}
	return nil
}

func (m *mockRecipeService) ListFavorites(ctx context.Context, userID uuid.UUID) ([]dto.RecipeResponse, error) {
	if m.listFavoritesFunc != nil {
		return m.listFavoritesFunc(ctx, userID)
	}
	return []dto.RecipeResponse{}, nil
}

func (m *mockRecipeService) SyncFromProvider(ctx context.Context, query string) (dto.RecipeSyncResponse, error) {
	if m.syncFunc != nil {
		return m.syncFunc(ctx, query)
	}
	return dto.RecipeSyncResponse{}, nil
}

func setupRecipeTestRouter(svc service.RecipeService, authUserID uuid.UUID) *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.New()

	authInjector := func(c *gin.Context) {
		if authUserID != uuid.Nil {
			c.Set(middleware.ContextUserIDKey, authUserID.String())
		}
		c.Next()
	}

	h := handler.NewRecipeHandler(svc)
	api := r.Group("/api/v1", authInjector)
	{
		api.GET("/recipes", h.List)
		api.GET("/recipes/match", h.Match)
		api.GET("/recipes/favorites", h.ListFavorites)
		api.GET("/recipes/:id", h.GetByID)
		api.POST("/recipes/:id/favorite", h.AddFavorite)
		api.DELETE("/recipes/:id/favorite", h.RemoveFavorite)
		api.POST("/recipes/sync", h.Sync)
	}
	return r
}

func TestRecipeHandler_List_Success(t *testing.T) {
	mockSvc := &mockRecipeService{
		listFunc: func(ctx context.Context, userID *uuid.UUID, q dto.RecipeQuery) (dto.RecipeListResponse, error) {
			assert.Equal(t, "борщ", q.Query)
			return dto.RecipeListResponse{
				Items: []dto.RecipeResponse{
					{ID: 1, Title: "Борщ классический"},
				},
				Total: 1,
			}, nil
		},
	}

	r := setupRecipeTestRouter(mockSvc, uuid.Nil)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/recipes?q=борщ", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.RecipeListResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 1, resp.Total)
}

func TestRecipeHandler_GetByID_Success(t *testing.T) {
	mockSvc := &mockRecipeService{
		getByIDFunc: func(ctx context.Context, userID *uuid.UUID, id int32) (*dto.RecipeResponse, error) {
			assert.Equal(t, int32(10), id)
			return &dto.RecipeResponse{
				ID:    10,
				Title: "Паста Карбонара",
			}, nil
		},
	}

	r := setupRecipeTestRouter(mockSvc, uuid.Nil)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/recipes/10", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.RecipeResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, "Паста Карбонара", resp.Title)
}

func TestRecipeHandler_GetByID_NotFound(t *testing.T) {
	r := setupRecipeTestRouter(&mockRecipeService{}, uuid.Nil)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/recipes/999", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusNotFound, w.Code)
}

func TestRecipeHandler_GetByID_InvalidID(t *testing.T) {
	r := setupRecipeTestRouter(&mockRecipeService{}, uuid.Nil)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/recipes/abc", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestRecipeHandler_Match_Success(t *testing.T) {
	uid := uuid.New()
	mockSvc := &mockRecipeService{
		matchFunc: func(ctx context.Context, userID uuid.UUID) (dto.RecipeMatchResponse, error) {
			assert.Equal(t, uid, userID)
			return dto.RecipeMatchResponse{
				Items: []dto.RecipeMatchItem{
					{
						Recipe:          dto.RecipeResponse{ID: 1, Title: "Омлет"},
						MatchPercentage: 100,
						CanCookNow:      true,
					},
				},
				Total: 1,
			}, nil
		},
	}

	r := setupRecipeTestRouter(mockSvc, uid)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/recipes/match", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.RecipeMatchResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 1, resp.Total)
	assert.True(t, resp.Items[0].CanCookNow)
}

func TestRecipeHandler_Favorites(t *testing.T) {
	uid := uuid.New()
	added := false
	removed := false

	mockSvc := &mockRecipeService{
		setFavoriteFunc: func(ctx context.Context, userID uuid.UUID, recipeID int32, isFav bool) error {
			assert.Equal(t, uid, userID)
			assert.Equal(t, int32(1), recipeID)
			if isFav {
				added = true
			} else {
				removed = true
			}
			return nil
		},
	}

	r := setupRecipeTestRouter(mockSvc, uid)

	// Add
	req := httptest.NewRequest(http.MethodPost, "/api/v1/recipes/1/favorite", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
	assert.True(t, added)

	// Remove
	req = httptest.NewRequest(http.MethodDelete, "/api/v1/recipes/1/favorite", nil)
	w = httptest.NewRecorder()
	r.ServeHTTP(w, req)
	assert.Equal(t, http.StatusOK, w.Code)
	assert.True(t, removed)
}

func TestRecipeHandler_Sync(t *testing.T) {
	mockSvc := &mockRecipeService{
		syncFunc: func(ctx context.Context, query string) (dto.RecipeSyncResponse, error) {
			assert.Equal(t, "beef", query)
			return dto.RecipeSyncResponse{SyncedCount: 5}, nil
		},
	}

	r := setupRecipeTestRouter(mockSvc, uuid.Nil)
	req := httptest.NewRequest(http.MethodPost, "/api/v1/recipes/sync?q=beef", nil)
	w := httptest.NewRecorder()
	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp dto.RecipeSyncResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, 5, resp.SyncedCount)
}

func TestRecipeHandler_ListFavorites_Success(t *testing.T) {
	authUID := uuid.New()
	mockSvc := &mockRecipeService{
		listFavoritesFunc: func(ctx context.Context, userID uuid.UUID) ([]dto.RecipeResponse, error) {
			assert.Equal(t, authUID, userID)
			return []dto.RecipeResponse{
				{ID: 1, Title: "Паста"},
			}, nil
		},
	}
	router := setupRecipeTestRouter(mockSvc, authUID)

	req := httptest.NewRequest(http.MethodGet, "/api/v1/recipes/favorites", nil)
	rec := httptest.NewRecorder()
	router.ServeHTTP(rec, req)

	assert.Equal(t, http.StatusOK, rec.Code)
	var resp []dto.RecipeResponse
	err := json.Unmarshal(rec.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Len(t, resp, 1)
	assert.Equal(t, int32(1), resp[0].ID)
}
