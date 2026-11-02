package handler

import (
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
)

type TranslationHandler struct {
	service service.TranslationService
}

func NewTranslationHandler(translationService service.TranslationService) *TranslationHandler {
	return &TranslationHandler{service: translationService}
}

// @Summary Translate a batch of text between English and Russian
// @Tags translations
// @Accept json
// @Produce json
// @Param request body dto.TranslateRequest true "Text and language pair"
// @Success 200 {object} dto.TranslateResponse
// @Failure 400 {object} map[string]string
// @Failure 502 {object} map[string]string
// @Router /api/v1/translations [post]
func (h *TranslationHandler) Translate(c *gin.Context) {
	var request dto.TranslateRequest
	if err := c.ShouldBindJSON(&request); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid translation request"})
		return
	}

	response, err := h.service.Translate(request)
	if err != nil {
		c.JSON(http.StatusBadGateway, gin.H{"error": "translation service unavailable"})
		return
	}

	c.JSON(http.StatusOK, response)
}
