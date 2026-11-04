package handler

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
)

type RecipeHandler struct {
	recipeService service.RecipeService
}

func NewRecipeHandler(recipeService service.RecipeService) *RecipeHandler {
	return &RecipeHandler{
		recipeService: recipeService,
	}
}

func (h *RecipeHandler) getUserID(c *gin.Context) (uuid.UUID, error) {
	userIDStr, err := middleware.GetUserID(c)
	if err != nil {
		return uuid.Nil, err
	}
	return uuid.Parse(userIDStr)
}

func (h *RecipeHandler) getOptionalUserID(c *gin.Context) *uuid.UUID {
	userIDStr, err := middleware.GetUserID(c)
	if err == nil {
		if uid, err := uuid.Parse(userIDStr); err == nil {
			return &uid
		}
	}
	return nil
}

// @Summary List recipes
// @Tags recipes
// @Produce json
// @Param q query string false "Search query by title"
// @Param difficulty query string false "Filter by difficulty (easy, medium, hard)"
// @Param max_time query int false "Max cooking time in minutes"
// @Param limit query int false "Limit"
// @Param offset query int false "Offset"
// @Success 200 {object} dto.RecipeListResponse
// @Failure 500 {object} map[string]string
// @Router /api/v1/recipes [get]
func (h *RecipeHandler) List(c *gin.Context) {
	var query dto.RecipeQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	userID := h.getOptionalUserID(c)
	resp, err := h.recipeService.List(c.Request.Context(), userID, query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list recipes"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Get recipe by ID
// @Tags recipes
// @Produce json
// @Param id path int true "Recipe ID"
// @Success 200 {object} dto.RecipeResponse
// @Failure 400 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/recipes/{id} [get]
func (h *RecipeHandler) GetByID(c *gin.Context) {
	id, err := strconv.Atoi(c.Param("id"))
	if err != nil || id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid recipe id"})
		return
	}

	userID := h.getOptionalUserID(c)
	resp, err := h.recipeService.GetByID(c.Request.Context(), userID, int32(id))
	if err != nil {
		if errors.Is(err, service.ErrRecipeNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get recipe"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Match recipes against user inventory
// @Tags recipes
// @Security BearerAuth
// @Produce json
// @Success 200 {object} dto.RecipeMatchResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/recipes/match [get]
func (h *RecipeHandler) Match(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	resp, err := h.recipeService.Match(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to match recipes"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary List user favorite recipes
// @Tags recipes
// @Security BearerAuth
// @Produce json
// @Success 200 {array} dto.RecipeResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/recipes/favorites [get]
func (h *RecipeHandler) ListFavorites(c *gin.Context) {
	userIDStr, err := middleware.GetUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}
	userID, err := uuid.Parse(userIDStr)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	favs, err := h.recipeService.ListFavorites(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list favorite recipes"})
		return
	}

	c.JSON(http.StatusOK, favs)
}

// @Summary Add recipe to favorites
// @Tags recipes
// @Security BearerAuth
// @Produce json
// @Param id path int true "Recipe ID"
// @Success 200 {object} map[string]string
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Router /api/v1/recipes/{id}/favorite [post]
func (h *RecipeHandler) AddFavorite(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil || id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid recipe id"})
		return
	}

	if err := h.recipeService.SetFavorite(c.Request.Context(), userID, int32(id), true); err != nil {
		if errors.Is(err, service.ErrRecipeNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to add favorite"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "added"})
}

// @Summary Remove recipe from favorites
// @Tags recipes
// @Security BearerAuth
// @Produce json
// @Param id path int true "Recipe ID"
// @Success 200 {object} map[string]string
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Router /api/v1/recipes/{id}/favorite [delete]
func (h *RecipeHandler) RemoveFavorite(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	id, err := strconv.Atoi(c.Param("id"))
	if err != nil || id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid recipe id"})
		return
	}

	if err := h.recipeService.SetFavorite(c.Request.Context(), userID, int32(id), false); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to remove favorite"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"status": "removed"})
}

// @Summary Sync recipes from TheMealDB
// @Tags recipes
// @Produce json
// @Param q query string false "Search query for external API"
// @Success 200 {object} dto.RecipeSyncResponse
// @Failure 500 {object} map[string]string
// @Router /api/v1/recipes/sync [post]
func (h *RecipeHandler) Sync(c *gin.Context) {
	q := c.DefaultQuery("q", "chicken")
	resp, err := h.recipeService.SyncFromProvider(c.Request.Context(), q)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	c.JSON(http.StatusOK, resp)
}
