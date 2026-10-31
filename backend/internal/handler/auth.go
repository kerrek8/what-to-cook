package handler

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
)

const (
	RefreshTokenCookieName = "refresh_token"
	RefreshTokenMaxAge     = 30 * 24 * 60 * 60
)

type AuthHandler struct {
	authService *service.AuthService
	isSecure    bool
}

func NewAuthHandler(authService *service.AuthService, isSecure bool) *AuthHandler {
	return &AuthHandler{
		authService: authService,
		isSecure:    isSecure,
	}
}

// @Summary Register a new user
// @Tags auth
// @Accept json
// @Produce json
// @Param request body dto.RegisterRequest true "Registration payload"
// @Success 201 {object} dto.AuthResponse
// @Failure 400 {object} map[string]string
// @Failure 409 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/auth/register [post]
func (h *AuthHandler) Register(c *gin.Context) {
	var req dto.RegisterRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, refreshToken, err := h.authService.Register(c.Request.Context(), req)
	if err != nil {
		if errors.Is(err, service.ErrUserAlreadyExists) {
			c.JSON(http.StatusConflict, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to register user"})
		return
	}

	h.setRefreshCookie(c, refreshToken)
	c.JSON(http.StatusCreated, resp)
}

// @Summary Login user
// @Tags auth
// @Accept json
// @Produce json
// @Param request body dto.LoginRequest true "Login credentials"
// @Success 200 {object} dto.AuthResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/auth/login [post]
func (h *AuthHandler) Login(c *gin.Context) {
	var req dto.LoginRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, refreshToken, err := h.authService.Login(c.Request.Context(), req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidCredentials) {
			c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to login"})
		return
	}

	h.setRefreshCookie(c, refreshToken)
	c.JSON(http.StatusOK, resp)
}

// @Summary Refresh access token
// @Tags auth
// @Produce json
// @Success 200 {object} dto.AuthResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/auth/refresh [post]
func (h *AuthHandler) Refresh(c *gin.Context) {
	tokenStr, err := c.Cookie(RefreshTokenCookieName)
	if err != nil || tokenStr == "" {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "refresh token cookie required"})
		return
	}

	resp, newRefreshToken, err := h.authService.Refresh(c.Request.Context(), tokenStr)
	if err != nil {
		h.clearRefreshCookie(c)
		c.JSON(http.StatusUnauthorized, gin.H{"error": err.Error()})
		return
	}

	h.setRefreshCookie(c, newRefreshToken)
	c.JSON(http.StatusOK, resp)
}

// @Summary Logout user
// @Tags auth
// @Produce json
// @Success 204 "No Content"
// @Router /api/v1/auth/logout [post]
func (h *AuthHandler) Logout(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err == nil && userID != "" {
		_ = h.authService.InvalidateSessions(c.Request.Context(), userID)
	}

	h.clearRefreshCookie(c)
	c.Status(http.StatusNoContent)
}

func (h *AuthHandler) setRefreshCookie(c *gin.Context, token string) {
	c.SetSameSite(http.SameSiteLaxMode)
	c.SetCookie(
		RefreshTokenCookieName,
		token,
		RefreshTokenMaxAge,
		"/",
		"",
		h.isSecure,
		true,
	)
}

func (h *AuthHandler) clearRefreshCookie(c *gin.Context) {
	c.SetSameSite(http.SameSiteLaxMode)
	c.SetCookie(
		RefreshTokenCookieName,
		"",
		-1,
		"/",
		"",
		h.isSecure,
		true,
	)
}
