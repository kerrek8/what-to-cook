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
	"github.com/jackc/pgx/v5"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockUserQuerier struct {
	store.Querier
	users map[string]store.User
}

func newMockUserQuerier() *mockUserQuerier {
	return &mockUserQuerier{users: make(map[string]store.User)}
}

func (m *mockUserQuerier) GetUserByID(ctx context.Context, id pgtype.UUID) (store.User, error) {
	idStr := uuid.UUID(id.Bytes).String()
	u, ok := m.users[idStr]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func (m *mockUserQuerier) UpdateUserExcludedIngredients(ctx context.Context, arg store.UpdateUserExcludedIngredientsParams) error {
	idStr := uuid.UUID(arg.ID.Bytes).String()
	u, ok := m.users[idStr]
	if !ok {
		return pgx.ErrNoRows
	}
	u.ExcludedIngredientIds = arg.ExcludedIngredientIds
	m.users[idStr] = u
	return nil
}

func TestUserHandler(t *testing.T) {
	gin.SetMode(gin.TestMode)
	mock := newMockUserQuerier()
	userService := service.NewUserService(mock)
	userHandler := handler.NewUserHandler(userService)

	testUserID := uuid.New()
	testUserIDStr := testUserID.String()
	mock.users[testUserIDStr] = store.User{
		ID:                    pgtype.UUID{Bytes: testUserID, Valid: true},
		Email:                 "me@example.com",
		Name:                  "Me User",
		TokenVersion:          1,
		ExcludedIngredientIds: []int32{},
		CreatedAt:             pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}

	r := gin.New()
	r.Use(func(c *gin.Context) {
		c.Set(middleware.ContextUserIDKey, testUserIDStr)
		c.Next()
	})
	r.GET("/api/v1/users/me", userHandler.GetMe)
	r.PUT("/api/v1/users/me/allergens", userHandler.UpdateAllergens)

	t.Run("get me success", func(t *testing.T) {
		req := httptest.NewRequest(http.MethodGet, "/api/v1/users/me", nil)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)

		var resp dto.UserResponse
		err := json.Unmarshal(w.Body.Bytes(), &resp)
		require.NoError(t, err)
		assert.Equal(t, "me@example.com", resp.Email)
	})

	t.Run("update allergens success", func(t *testing.T) {
		body, _ := json.Marshal(dto.UpdateAllergensRequest{
			ExcludedIngredientIDs: []int32{15},
		})

		req := httptest.NewRequest(http.MethodPut, "/api/v1/users/me/allergens", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)

		var resp dto.UserResponse
		err := json.Unmarshal(w.Body.Bytes(), &resp)
		require.NoError(t, err)
		assert.Equal(t, []int32{15}, resp.ExcludedIngredientIDs)
	})

	t.Run("update allergens exceeds free limit fails with 400", func(t *testing.T) {
		body, _ := json.Marshal(dto.UpdateAllergensRequest{
			ExcludedIngredientIDs: []int32{15, 20},
		})

		req := httptest.NewRequest(http.MethodPut, "/api/v1/users/me/allergens", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})
}
