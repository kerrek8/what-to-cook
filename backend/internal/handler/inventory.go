package handler

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
)

type InventoryHandler struct {
	inventoryService service.InventoryService
}

func NewInventoryHandler(inventoryService service.InventoryService) *InventoryHandler {
	return &InventoryHandler{
		inventoryService: inventoryService,
	}
}

func (h *InventoryHandler) getUserID(c *gin.Context) (uuid.UUID, error) {
	userIDStr, err := middleware.GetUserID(c)
	if err != nil {
		return uuid.Nil, err
	}
	return uuid.Parse(userIDStr)
}

// @Summary List inventory items
// @Tags inventory
// @Security BearerAuth
// @Produce json
// @Success 200 {object} dto.InventoryListResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/inventory [get]
func (h *InventoryHandler) List(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	resp, err := h.inventoryService.List(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list inventory items"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Get inventory item by ID
// @Tags inventory
// @Security BearerAuth
// @Produce json
// @Param id path string true "Inventory item ID"
// @Success 200 {object} dto.InventoryItemResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/inventory/{id} [get]
func (h *InventoryHandler) GetByID(c *gin.Context) {
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

	resp, err := h.inventoryService.GetByID(c.Request.Context(), userID, itemID)
	if err != nil {
		if errors.Is(err, service.ErrInventoryItemNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to get inventory item"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Create inventory item
// @Tags inventory
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param request body dto.CreateInventoryItemRequest true "Inventory item payload"
// @Success 201 {object} dto.InventoryItemResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/inventory [post]
func (h *InventoryHandler) Create(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req dto.CreateInventoryItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.inventoryService.Create(c.Request.Context(), userID, req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidInventoryItem) || errors.Is(err, service.ErrInvalidExpirationDate) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to create inventory item"})
		return
	}

	c.JSON(http.StatusCreated, resp)
}

// @Summary Update inventory item
// @Tags inventory
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param id path string true "Inventory item ID"
// @Param request body dto.UpdateInventoryItemRequest true "Inventory item update payload"
// @Success 200 {object} dto.InventoryItemResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/inventory/{id} [put]
func (h *InventoryHandler) Update(c *gin.Context) {
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

	var req dto.UpdateInventoryItemRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.inventoryService.Update(c.Request.Context(), userID, itemID, req)
	if err != nil {
		if errors.Is(err, service.ErrInventoryItemNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		if errors.Is(err, service.ErrInvalidExpirationDate) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to update inventory item"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Delete inventory item
// @Tags inventory
// @Security BearerAuth
// @Param id path string true "Inventory item ID"
// @Success 204 "No Content"
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/inventory/{id} [delete]
func (h *InventoryHandler) Delete(c *gin.Context) {
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

	if err := h.inventoryService.Delete(c.Request.Context(), userID, itemID); err != nil {
		if errors.Is(err, service.ErrInventoryItemNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to delete inventory item"})
		return
	}

	c.Status(http.StatusNoContent)
}
