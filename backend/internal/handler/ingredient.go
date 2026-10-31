package handler

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
)

type IngredientHandler struct {
	ingredientService service.IngredientService
}

func NewIngredientHandler(ingredientService service.IngredientService) *IngredientHandler {
	return &IngredientHandler{
		ingredientService: ingredientService,
	}
}

// @Summary List and search ingredients
// @Tags ingredients
// @Produce json
// @Param q query string false "Search query by name"
// @Param category query string false "Filter by category"
// @Success 200 {object} dto.IngredientListResponse
// @Failure 500 {object} map[string]string
// @Router /api/v1/ingredients [get]
func (h *IngredientHandler) List(c *gin.Context) {
	var query dto.IngredientFilterQuery
	if err := c.ShouldBindQuery(&query); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	resp, err := h.ingredientService.Search(c.Request.Context(), query)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to fetch ingredients"})
		return
	}

	c.JSON(http.StatusOK, resp)
}

// @Summary Get ingredient by ID
// @Tags ingredients
// @Produce json
// @Param id path int true "Ingredient ID"
// @Success 200 {object} dto.IngredientResponse
// @Failure 400 {object} map[string]string
// @Failure 404 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/ingredients/{id} [get]
func (h *IngredientHandler) GetByID(c *gin.Context) {
	idParam := c.Param("id")
	id, err := strconv.Atoi(idParam)
	if err != nil || id <= 0 {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid ingredient id"})
		return
	}

	resp, err := h.ingredientService.GetByID(c.Request.Context(), int32(id))
	if err != nil {
		if errors.Is(err, service.ErrIngredientNotFound) {
			c.JSON(http.StatusNotFound, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to fetch ingredient"})
		return
	}

	c.JSON(http.StatusOK, resp)
}
