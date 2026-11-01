package handler_test

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/handler"
	"github.com/kerrek8/what-to-cook/backend/internal/middleware"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockNotificationService struct {
	subscribeFunc     func(ctx context.Context, userID uuid.UUID, req dto.SubscribeNotificationRequest) (*dto.PushSubscriptionResponse, error)
	listSubsFunc      func(ctx context.Context, userID uuid.UUID) ([]dto.PushSubscriptionResponse, error)
	sendToUserFunc    func(ctx context.Context, userID uuid.UUID, payload dto.PushNotificationPayload) (int, error)
	checkExpiringFunc func(ctx context.Context, now time.Time) (int, error)
}

func (m *mockNotificationService) Subscribe(ctx context.Context, userID uuid.UUID, req dto.SubscribeNotificationRequest) (*dto.PushSubscriptionResponse, error) {
	if m.subscribeFunc != nil {
		return m.subscribeFunc(ctx, userID, req)
	}
	return nil, nil
}

func (m *mockNotificationService) ListSubscriptions(ctx context.Context, userID uuid.UUID) ([]dto.PushSubscriptionResponse, error) {
	if m.listSubsFunc != nil {
		return m.listSubsFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockNotificationService) SendToUser(ctx context.Context, userID uuid.UUID, payload dto.PushNotificationPayload) (int, error) {
	if m.sendToUserFunc != nil {
		return m.sendToUserFunc(ctx, userID, payload)
	}
	return 0, nil
}

func (m *mockNotificationService) CheckAndNotifyExpiring(ctx context.Context, now time.Time) (int, error) {
	if m.checkExpiringFunc != nil {
		return m.checkExpiringFunc(ctx, now)
	}
	return 0, nil
}

func setupNotificationTestRouter(svc service.NotificationService, authUserID uuid.UUID) *gin.Engine {
	gin.SetMode(gin.TestMode)
	r := gin.New()

	authInjector := func(c *gin.Context) {
		if authUserID != uuid.Nil {
			c.Set(middleware.ContextUserIDKey, authUserID.String())
		}
		c.Next()
	}

	h := handler.NewNotificationHandler(svc)
	grp := r.Group("/api/v1/notifications", authInjector)
	{
		grp.POST("/subscribe", h.Subscribe)
		grp.GET("/subscriptions", h.ListSubscriptions)
	}

	return r
}

func TestNotificationHandler_Subscribe_Success(t *testing.T) {
	userID := uuid.New()
	subID := uuid.New()
	endpoint := "https://push.example.com/endpoint"

	mockSvc := &mockNotificationService{
		subscribeFunc: func(ctx context.Context, uID uuid.UUID, req dto.SubscribeNotificationRequest) (*dto.PushSubscriptionResponse, error) {
			assert.Equal(t, userID, uID)
			assert.Equal(t, endpoint, req.Endpoint)
			return &dto.PushSubscriptionResponse{
				ID:        subID.String(),
				Endpoint:  endpoint,
				CreatedAt: time.Now(),
			}, nil
		},
	}

	r := setupNotificationTestRouter(mockSvc, userID)
	body, _ := json.Marshal(dto.SubscribeNotificationRequest{
		Endpoint: endpoint,
		P256dh:   "key1",
		Auth:     "auth1",
	})
	req := httptest.NewRequest(http.MethodPost, "/api/v1/notifications/subscribe", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusCreated, w.Code)
	var resp dto.PushSubscriptionResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Equal(t, subID.String(), resp.ID)
	assert.Equal(t, endpoint, resp.Endpoint)
}

func TestNotificationHandler_Subscribe_InvalidPayload(t *testing.T) {
	r := setupNotificationTestRouter(&mockNotificationService{}, uuid.New())
	req := httptest.NewRequest(http.MethodPost, "/api/v1/notifications/subscribe", bytes.NewReader([]byte("{invalid-json")))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestNotificationHandler_Subscribe_ValidationError(t *testing.T) {
	mockSvc := &mockNotificationService{
		subscribeFunc: func(ctx context.Context, uID uuid.UUID, req dto.SubscribeNotificationRequest) (*dto.PushSubscriptionResponse, error) {
			return nil, service.ErrInvalidSubscription
		},
	}

	r := setupNotificationTestRouter(mockSvc, uuid.New())
	body, _ := json.Marshal(dto.SubscribeNotificationRequest{
		Endpoint: "https://push.com/incomplete",
	})
	req := httptest.NewRequest(http.MethodPost, "/api/v1/notifications/subscribe", bytes.NewReader(body))
	req.Header.Set("Content-Type", "application/json")
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusBadRequest, w.Code)
}

func TestNotificationHandler_ListSubscriptions_Success(t *testing.T) {
	userID := uuid.New()
	mockSvc := &mockNotificationService{
		listSubsFunc: func(ctx context.Context, uID uuid.UUID) ([]dto.PushSubscriptionResponse, error) {
			assert.Equal(t, userID, uID)
			return []dto.PushSubscriptionResponse{
				{
					ID:       uuid.New().String(),
					Endpoint: "https://push.com/device1",
				},
			}, nil
		},
	}

	r := setupNotificationTestRouter(mockSvc, userID)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/notifications/subscriptions", nil)
	w := httptest.NewRecorder()

	r.ServeHTTP(w, req)

	assert.Equal(t, http.StatusOK, w.Code)
	var resp []dto.PushSubscriptionResponse
	err := json.Unmarshal(w.Body.Bytes(), &resp)
	require.NoError(t, err)
	assert.Len(t, resp, 1)
}
