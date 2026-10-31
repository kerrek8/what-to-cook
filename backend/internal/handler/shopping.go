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

type ShoppingHandler struct {
	shoppingService service.ShoppingService
}

func NewShoppingHandler(shoppingService service.ShoppingService) *ShoppingHandler {
	return &ShoppingHandler{
		shoppingService: shoppingService,
	}
}

func (h *ShoppingHandler) getUserID(c *gin.Context) (uuid.UUID, error) {
	userIDStr, err := middleware.GetUserID(c)
	if err != nil {
		return uuid.Nil, err
	}
	return uuid.Parse(userIDStr)
}

// @Summary List shopping items
// @Tags shopping-list
// @Security BearerAuth
// @Produce json
// @Success 200 {object} dto.ShoppingListResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/shopping-list [get]
func (h *ShoppingHandler) List(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	resp, err := h.shoppingService.List(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list shopping items"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Create shopping item
// @Tags shopping-list
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param request body dto.CreateShoppingItemRequest true "Shopping item payload"
// @Success 201 {object} dto.ShoppingItemResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/shopping-list [post]
func (h *ShoppingHandler) Create(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req dto.CreateShoppingItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	resp, err := h.shoppingService.Create(c.Request.Context(), userID, req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidShoppingItem) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create shopping item"})
		return
	}

	c.JSON(http.StatusCreated, resp)
}

// @Summary Update shopping item
// @Tags shopping-list
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param id path string true "Shopping item ID"
// @Param request body dto.UpdateShoppingItemRequest true "Update shopping item payload"
// @Success 200 {object} dto.ShoppingItemResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/shopping-list/{id} [patch]
func (h *ShoppingHandler) Update(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	itemID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid item id"})
		return
	}

	var req dto.UpdateShoppingItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	resp, err := h.shoppingService.Update(c.Request.Context(), userID, itemID, req)
	if err != nil {
		if errors.Is(err, service.ErrShoppingItemNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update shopping item"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Delete shopping item
// @Tags shopping-list
// @Security BearerAuth
// @Produce json
// @Param id path string true "Shopping item ID"
// @Success 204 "No Content"
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/shopping-list/{id} [delete]
func (h *ShoppingHandler) Delete(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	itemID, err := uuid.Parse(c.Param("id"))
	if err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid item id"})
		return
	}

	err = h.shoppingService.Delete(c.Request.Context(), userID, itemID)
	if err != nil {
		if errors.Is(err, service.ErrShoppingItemNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to delete shopping item"})
		return
	}

	c.Status(http.StatusNoContent)
}

// @Summary Add missing ingredients from recipe to shopping list
// @Tags shopping-list
// @Security BearerAuth
// @Produce json
// @Param id path int true "Recipe ID"
// @Success 200 {object} dto.AddFromRecipeResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/shopping-list/from-recipe/{id} [post]
func (h *ShoppingHandler) AddFromRecipe(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	recipeID, err := strconv.Atoi(c.Param("id"))
	if err != nil || recipeID <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid recipe id"})
		return
	}

	resp, err := h.shoppingService.AddMissingFromRecipe(c.Request.Context(), userID, int32(recipeID))
	if err != nil {
		if errors.Is(err, service.ErrRecipeNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to add missing ingredients from recipe"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Transfer bought shopping list items to inventory
// @Tags shopping-list
// @Security BearerAuth
// @Produce json
// @Success 200 {object} dto.TransferToInventoryResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/shopping-list/transfer-to-inventory [post]
func (h *ShoppingHandler) TransferToInventory(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	resp, err := h.shoppingService.TransferToInventory(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to transfer items to inventory"})
		return
	}

	c.JSON(http.StatusOK, resp)
}
