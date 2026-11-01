package handler

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
)

type HealthHandler struct{}

func NewHealthHandler() *HealthHandler {
	return &HealthHandler{}
}

// @Summary Health check
// @Tags health
// @Produce json
// @Success 200 {object} dto.HealthResponse
// @Router /health [get]
func (h *HealthHandler) Health(c *gin.Context) {
	c.JSON(http.StatusOK, dto.HealthResponse{
		Status: "ok",
		Time:   time.Now().UTC().Format(time.RFC3339),
	})
}
