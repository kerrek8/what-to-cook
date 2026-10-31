package middleware_test

import (
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/pkg/token"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestAuthMiddleware(t *testing.T) {
	gin.SetMode(gin.TestMode)
	secret := "my-secret-key-at-least-16-bytes"
	userID := "550e8400-e29b-41d4-a716-446655440000"

	t.Run("valid token", func(t *testing.T) {
		tok, err := token.GenerateAccessToken(userID, 1, secret, time.Hour)
		require.NoError(t, err)

		r := gin.New()
		r.Use(middleware.Auth(secret))
		r.GET("/protected", func(c *gin.Context) {
			id, err := middleware.GetUserID(c)
			assert.NoError(t, err)
			assert.Equal(t, userID, id)
			c.Status(http.StatusOK)
		})

		req := httptest.NewRequest(http.MethodGet, "/protected", nil)
		req.Header.Set("Authorization", "Bearer "+tok)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusOK, w.Code)
	})

	t.Run("missing authorization header", func(t *testing.T) {
		r := gin.New()
		r.Use(middleware.Auth(secret))
		r.GET("/protected", func(c *gin.Context) {
			c.Status(http.StatusOK)
		})

		req := httptest.NewRequest(http.MethodGet, "/protected", nil)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusUnauthorized, w.Code)
	})

	t.Run("invalid token format", func(t *testing.T) {
		r := gin.New()
		r.Use(middleware.Auth(secret))
		r.GET("/protected", func(c *gin.Context) {
			c.Status(http.StatusOK)
		})

		req := httptest.NewRequest(http.MethodGet, "/protected", nil)
		req.Header.Set("Authorization", "Basic 123456")
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusUnauthorized, w.Code)
	})

	t.Run("refresh token rejected on access route", func(t *testing.T) {
		refTok, err := token.GenerateRefreshToken(userID, 1, secret, time.Hour)
		require.NoError(t, err)

		r := gin.New()
		r.Use(middleware.Auth(secret))
		r.GET("/protected", func(c *gin.Context) {
			c.Status(http.StatusOK)
		})

		req := httptest.NewRequest(http.MethodGet, "/protected", nil)
		req.Header.Set("Authorization", "Bearer "+refTok)
		w := httptest.NewRecorder()

		r.ServeHTTP(w, req)
		assert.Equal(t, http.StatusUnauthorized, w.Code)
	})
}
