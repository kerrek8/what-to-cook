package middleware

import (
	"errors"
	"net/http"
	"strings"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/pkg/token"
)

const ContextUserIDKey = "user_id"

var ErrUnauthorized = errors.New("unauthorized")

func Auth(jwtSecret string) gin.HandlerFunc {
	return func(c *gin.Context) {
		authHeader := c.GetHeader("Authorization")
		if authHeader == "" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "authorization header required"})
			return
		}

		parts := strings.SplitN(authHeader, " ", 2)
		if len(parts) != 2 || !strings.EqualFold(parts[0], "Bearer") {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid authorization header format"})
			return
		}

		claims, err := token.ParseToken(parts[1], jwtSecret)
		if err != nil || claims.Subject != "access" {
			c.AbortWithStatusJSON(http.StatusUnauthorized, gin.H{"error": "invalid or expired token"})
			return
		}

		c.Set(ContextUserIDKey, claims.UserID)
		c.Next()
	}
}

func GetUserID(c *gin.Context) (string, error) {
	val, ok := c.Get(ContextUserIDKey)
	if !ok {
		return "", ErrUnauthorized
	}
	userID, ok := val.(string)
	if !ok || userID == "" {
		return "", ErrUnauthorized
	}
	return userID, nil
}
