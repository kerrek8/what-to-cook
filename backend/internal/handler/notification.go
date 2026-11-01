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

type NotificationHandler struct {
	notificationService service.NotificationService
}

func NewNotificationHandler(notificationService service.NotificationService) *NotificationHandler {
	return &NotificationHandler{
		notificationService: notificationService,
	}
}

func (h *NotificationHandler) getUserID(c *gin.Context) (uuid.UUID, error) {
	userIDStr, err := middleware.GetUserID(c)
	if err != nil {
		return uuid.Nil, err
	}
	return uuid.Parse(userIDStr)
}

// @Summary Subscribe to Web Push notifications
// @Tags notifications
// @Security BearerAuth
// @Accept json
// @Produce json
// @Param request body dto.SubscribeNotificationRequest true "Push subscription payload"
// @Success 201 {object} dto.PushSubscriptionResponse
// @Failure 400 {object} map[string]string
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/notifications/subscribe [post]
func (h *NotificationHandler) Subscribe(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	var req dto.SubscribeNotificationRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "invalid request body"})
		return
	}

	resp, err := h.notificationService.Subscribe(c.Request.Context(), userID, req)
	if err != nil {
		if errors.Is(err, service.ErrInvalidSubscription) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to save subscription"})
		return
	}

	c.JSON(http.StatusCreated, resp)
}

// @Summary List user push subscriptions
// @Tags notifications
// @Security BearerAuth
// @Produce json
// @Success 200 {array} dto.PushSubscriptionResponse
// @Failure 401 {object} map[string]string
// @Failure 500 {object} map[string]string
// @Router /api/v1/notifications/subscriptions [get]
func (h *NotificationHandler) ListSubscriptions(c *gin.Context) {
	userID, err := h.getUserID(c)
	if err != nil {
		c.JSON(http.StatusUnauthorized, gin.H{"error": "unauthorized"})
		return
	}

	resp, err := h.notificationService.ListSubscriptions(c.Request.Context(), userID)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "failed to list subscriptions"})
		return
	}

	c.JSON(http.StatusOK, resp)
}
