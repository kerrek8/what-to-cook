package handler

import (
	"errors"
	"fmt"
	"mime"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/storage"
)

type UserHandler struct {
	userService *service.UserService
	storage     storage.Storage
}

func NewUserHandler(userService *service.UserService, storage storage.Storage) *UserHandler {
	return &UserHandler{
		userService: userService,
		storage:     storage,
	}
}

// @Summary Get current user profile
// @Tags users
// @Produce json
// @Security BearerAuth
// @Success 200 {object} dto.UserResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/users/me [get]
func (h *UserHandler) GetMe(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	user, err := h.userService.GetMe(c.Request.Context(), userID)
	if err != nil {
		if errors.Is(err, service.ErrUserNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get profile"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// @Summary Upload user avatar
// @Tags users
// @Accept multipart/form-data
// @Produce json
// @Security BearerAuth
// @Param avatar formData file true "Avatar image file"
// @Success 200 {object} dto.UploadAvatarResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/users/me/avatar [post]
func (h *UserHandler) UploadAvatar(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	fileHeader, err := c.FormFile("avatar")
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "avatar file is required"})
		return
	}

	const maxAvatarSize = 5 * 1024 * 1024
	if fileHeader.Size > maxAvatarSize {
		c.JSON(http.StatusBadRequest, gin.H{"error": "file size exceeds 5MB limit"})
		return
	}

	contentType := fileHeader.Header.Get("Content-Type")
	mediaType, _, _ := mime.ParseMediaType(contentType)
	if mediaType == "" {
		mediaType = contentType
	}

	switch mediaType {
	case "image/jpeg", "image/jpg", "image/png", "image/gif":
	default:
		c.JSON(http.StatusBadRequest, gin.H{"error": "unsupported image format"})
		return
	}

	file, err := fileHeader.Open()
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to open avatar file"})
		return
	}
	defer file.Close()

	optimized, err := storage.OptimizeAvatarImage(file)
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "failed to process image"})
		return
	}

	if h.storage == nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "storage not configured"})
		return
	}

	relPath := fmt.Sprintf("avatars/%s.jpg", userID)
	avatarURL, err := h.storage.Save(c.Request.Context(), relPath, optimized)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save avatar"})
		return
	}

	_, err = h.userService.UpdateAvatar(c.Request.Context(), userID, &avatarURL)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update user avatar"})
		return
	}

	c.JSON(http.StatusOK, dto.UploadAvatarResponse{AvatarURL: avatarURL})
}

// @Summary Delete user avatar
// @Tags users
// @Security BearerAuth
// @Success 204 "No Content"
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/users/me/avatar [delete]
func (h *UserHandler) DeleteAvatar(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	_, err = h.userService.UpdateAvatar(c.Request.Context(), userID, nil)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to delete avatar"})
		return
	}

	if h.storage != nil {
		relPath := fmt.Sprintf("avatars/%s.jpg", userID)
		_ = h.storage.Delete(c.Request.Context(), relPath)
	}

	c.Status(http.StatusNoContent)
}

// @Summary Update user allergens / excluded ingredients
// @Tags users
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body dto.UpdateAllergensRequest true "Excluded ingredients list"
// @Success 200 {object} dto.UserResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/users/me/allergens [put]
func (h *UserHandler) UpdateAllergens(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req dto.UpdateAllergensRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.userService.UpdateAllergens(c.Request.Context(), userID, req)
	if err != nil {
		if errors.Is(err, service.ErrMaxAllergensExceeded) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update allergens"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// @Summary Update user pantry essentials
// @Tags users
// @Accept json
// @Produce json
// @Security BearerAuth
// @Param request body dto.UpdatePantryRequest true "Pantry ingredients list"
// @Success 200 {object} dto.UserResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/users/me/pantry [put]
func (h *UserHandler) UpdatePantry(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req dto.UpdatePantryRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	user, err := h.userService.UpdatePantry(c.Request.Context(), userID, req)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update pantry"})
		return
	}

	c.JSON(http.StatusOK, user)
}

// @Summary Get current user pantry essentials
// @Tags users
// @Produce json
// @Security BearerAuth
// @Success 200 {object} dto.UserResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/users/me/pantry [get]
func (h *UserHandler) GetPantry(c *gin.Context) {
	userID, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	user, err := h.userService.GetMe(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get pantry"})
		return
	}
	c.JSON(http.StatusOK, gin.H{"pantry_ingredient_ids": user.PantryIngredientIDs})
}
