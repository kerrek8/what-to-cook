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
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockAuthQuerier struct {
	store.Querier
	users map[string]store.User
}

func newMockAuthQuerier() *mockAuthQuerier {
	return &mockAuthQuerier{users: make(map[string]store.User)}
}

func (m *mockAuthQuerier) CreateUser(ctx context.Context, arg store.CreateUserParams) (store.User, error) {
	u := store.User{
		ID:                    pgtype.UUID{Bytes: uuid.New(), Valid: true},
		Email:                 arg.Email,
		PasswordHash:          arg.PasswordHash,
		Name:                  arg.Name,
		TokenVersion:          1,
		ExcludedIngredientIds: []int32{},
		CreatedAt:             pgtype.Timestamptz{Time: time.Now(), Valid: true},
		UpdatedAt:             pgtype.Timestamptz{Time: time.Now(), Valid: true},
	}
	m.users[arg.Email] = u
	return u, nil
}

func (m *mockAuthQuerier) GetUserByEmail(ctx context.Context, email string) (store.User, error) {
	u, ok := m.users[email]
	if !ok {
		return store.User{}, pgx.ErrNoRows
	}
	return u, nil
}

func TestAuthHandler_RegisterAndLogin(t *testing.T) {
	gin.SetMode(gin.TestMode)
	mock := newMockAuthQuerier()
	authService := service.NewAuthService(mock, "test-secret-at-least-16-bytes")
	authHandler := handler.NewAuthHandler(authService, false)

	r := gin.New()
	r.POST("/api/v1/auth/register", authHandler.Register)
	r.POST("/api/v1/auth/login", authHandler.Login)
	r.POST("/api/v1/auth/refresh", authHandler.Refresh)
	r.POST("/api/v1/auth/logout", authHandler.Logout)

	t.Run("successful register", func(t *testing.T) {
		body, _ := json.Marshal(dto.RegisterRequest{
			Email:    "api@example.com",
			Password: "securepassword",
			Name:     "API User",
		})

		req := httptest.NewRequest(http.MethodPost, "/api/v1/auth/register", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusCreated, w.Code)

		var resp dto.AuthResponse
		err := json.Unmarshal(w.Body.Bytes(), &resp)
		require.NoError(t, err)
		assert.NotEmpty(t, resp.AccessToken)
		assert.Equal(t, "api@example.com", resp.User.Email)
		assert.Contains(t, w.Header().Get("Set-Cookie"), handler.RefreshTokenCookieName)
	})

	t.Run("invalid register payload fails with 400", func(t *testing.T) {
		body, _ := json.Marshal(dto.RegisterRequest{
			Email:    "invalid-email",
			Password: "123",
			Name:     "",
		})

		req := httptest.NewRequest(http.MethodPost, "/api/v1/auth/register", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusBadRequest, w.Code)
	})

	t.Run("successful login", func(t *testing.T) {
		body, _ := json.Marshal(dto.LoginRequest{
			Email:    "api@example.com",
			Password: "securepassword",
		})

		req := httptest.NewRequest(http.MethodPost, "/api/v1/auth/login", bytes.NewBuffer(body))
		req.Header.Set("Content-Type", "application/json")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})
}
