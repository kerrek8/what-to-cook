package service_test

import (
	"bytes"
	"context"
	"io"
	"net/http"
	"sync/atomic"
	"testing"
	"time"

	"github.com/SherClockHolmes/webpush-go"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/service"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

type mockNotificationQuerier struct {
	store.Querier
	upsertFunc           func(ctx context.Context, arg store.UpsertPushSubscriptionParams) (store.PushSubscription, error)
	listSubsFunc         func(ctx context.Context, userID pgtype.UUID) ([]store.PushSubscription, error)
	deleteEndpointFunc   func(ctx context.Context, endpoint string) error
	listExpiringFunc     func(ctx context.Context, arg store.ListExpiringInventoryItemsParams) ([]store.ListExpiringInventoryItemsRow, error)
}

func (m *mockNotificationQuerier) UpsertPushSubscription(ctx context.Context, arg store.UpsertPushSubscriptionParams) (store.PushSubscription, error) {
	if m.upsertFunc != nil {
		return m.upsertFunc(ctx, arg)
	}
	return store.PushSubscription{}, nil
}

func (m *mockNotificationQuerier) ListPushSubscriptionsByUserID(ctx context.Context, userID pgtype.UUID) ([]store.PushSubscription, error) {
	if m.listSubsFunc != nil {
		return m.listSubsFunc(ctx, userID)
	}
	return nil, nil
}

func (m *mockNotificationQuerier) DeletePushSubscriptionByEndpoint(ctx context.Context, endpoint string) error {
	if m.deleteEndpointFunc != nil {
		return m.deleteEndpointFunc(ctx, endpoint)
	}
	return nil
}

func (m *mockNotificationQuerier) ListExpiringInventoryItems(ctx context.Context, arg store.ListExpiringInventoryItemsParams) ([]store.ListExpiringInventoryItemsRow, error) {
	if m.listExpiringFunc != nil {
		return m.listExpiringFunc(ctx, arg)
	}
	return nil, nil
}

type mockPushSender struct {
	sendFunc func(ctx context.Context, message []byte, sub *webpush.Subscription) (*http.Response, error)
}

func (m *mockPushSender) SendNotification(ctx context.Context, message []byte, sub *webpush.Subscription) (*http.Response, error) {
	if m.sendFunc != nil {
		return m.sendFunc(ctx, message, sub)
	}
	return &http.Response{
		StatusCode: http.StatusOK,
		Body:       io.NopCloser(bytes.NewReader(nil)),
	}, nil
}

func TestNotificationService_Subscribe_Success(t *testing.T) {
	userID := uuid.New()
	subID := uuid.New()
	endpoint := "https://fcm.googleapis.com/fcm/send/123"

	mockStore := &mockNotificationQuerier{
		upsertFunc: func(ctx context.Context, arg store.UpsertPushSubscriptionParams) (store.PushSubscription, error) {
			assert.Equal(t, userID, uuid.UUID(arg.UserID.Bytes))
			assert.Equal(t, endpoint, arg.Endpoint)
			assert.Equal(t, "key-p256dh", arg.P256dh)
			assert.Equal(t, "key-auth", arg.Auth)
			return store.PushSubscription{
				ID:        pgtype.UUID{Bytes: subID, Valid: true},
				UserID:    arg.UserID,
				Endpoint:  arg.Endpoint,
				P256dh:    arg.P256dh,
				Auth:      arg.Auth,
				CreatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
			}, nil
		},
	}

	svc := service.NewNotificationService(mockStore, &mockPushSender{})
	res, err := svc.Subscribe(context.Background(), userID, dto.SubscribeNotificationRequest{
		Endpoint: endpoint,
		Keys: &dto.PushKeys{
			P256dh: "key-p256dh",
			Auth:   "key-auth",
		},
	})

	require.NoError(t, err)
	assert.Equal(t, subID.String(), res.ID)
	assert.Equal(t, endpoint, res.Endpoint)
}

func TestNotificationService_Subscribe_Validation(t *testing.T) {
	svc := service.NewNotificationService(&mockNotificationQuerier{}, &mockPushSender{})

	_, err := svc.Subscribe(context.Background(), uuid.New(), dto.SubscribeNotificationRequest{})
	assert.ErrorIs(t, err, service.ErrInvalidSubscription)

	_, err = svc.Subscribe(context.Background(), uuid.New(), dto.SubscribeNotificationRequest{
		Endpoint: "https://example.com",
	})
	assert.ErrorIs(t, err, service.ErrInvalidSubscription)
}

func TestNotificationService_ListSubscriptions(t *testing.T) {
	userID := uuid.New()
	subID := uuid.New()

	mockStore := &mockNotificationQuerier{
		listSubsFunc: func(ctx context.Context, uID pgtype.UUID) ([]store.PushSubscription, error) {
			assert.Equal(t, userID, uuid.UUID(uID.Bytes))
			return []store.PushSubscription{
				{
					ID:        pgtype.UUID{Bytes: subID, Valid: true},
					Endpoint:  "https://push.com/sub",
					CreatedAt: pgtype.Timestamptz{Time: time.Now(), Valid: true},
				},
			}, nil
		},
	}

	svc := service.NewNotificationService(mockStore, &mockPushSender{})
	res, err := svc.ListSubscriptions(context.Background(), userID)

	require.NoError(t, err)
	assert.Len(t, res, 1)
	assert.Equal(t, subID.String(), res[0].ID)
}

func TestNotificationService_SendToUser_ExpiredSubscriptionCleanup(t *testing.T) {
	userID := uuid.New()
	endpoint := "https://push.example.com/expired"
	deletedEndpoint := ""

	mockStore := &mockNotificationQuerier{
		listSubsFunc: func(ctx context.Context, uID pgtype.UUID) ([]store.PushSubscription, error) {
			return []store.PushSubscription{
				{
					ID:       pgtype.UUID{Bytes: uuid.New(), Valid: true},
					Endpoint: endpoint,
					P256dh:   "key",
					Auth:     "auth",
				},
			}, nil
		},
		deleteEndpointFunc: func(ctx context.Context, ep string) error {
			deletedEndpoint = ep
			return nil
		},
	}

	mockSender := &mockPushSender{
		sendFunc: func(ctx context.Context, message []byte, sub *webpush.Subscription) (*http.Response, error) {
			return &http.Response{
				StatusCode: http.StatusGone, // 410 Gone
				Body:       io.NopCloser(bytes.NewReader(nil)),
			}, nil
		},
	}

	svc := service.NewNotificationService(mockStore, mockSender)
	sent, err := svc.SendToUser(context.Background(), userID, dto.PushNotificationPayload{
		Title: "Test",
		Body:  "Test body",
	})

	require.NoError(t, err)
	assert.Equal(t, 0, sent)
	assert.Equal(t, endpoint, deletedEndpoint)
}

func TestNotificationService_CheckAndNotifyExpiring(t *testing.T) {
	user1 := uuid.New()
	user2 := uuid.New()

	mockStore := &mockNotificationQuerier{
		listExpiringFunc: func(ctx context.Context, arg store.ListExpiringInventoryItemsParams) ([]store.ListExpiringInventoryItemsRow, error) {
			return []store.ListExpiringInventoryItemsRow{
				{
					UserID:         pgtype.UUID{Bytes: user1, Valid: true},
					IngredientName: pgtype.Text{String: "Молоко", Valid: true},
				},
				{
					UserID:         pgtype.UUID{Bytes: user1, Valid: true},
					IngredientName: pgtype.Text{String: "Сыр", Valid: true},
				},
				{
					UserID:     pgtype.UUID{Bytes: user2, Valid: true},
					CustomName: pgtype.Text{String: "Йогурт", Valid: true},
				},
			}, nil
		},
		listSubsFunc: func(ctx context.Context, uID pgtype.UUID) ([]store.PushSubscription, error) {
			return []store.PushSubscription{
				{
					ID:       pgtype.UUID{Bytes: uuid.New(), Valid: true},
					Endpoint: "https://push.com/user/" + uuid.UUID(uID.Bytes).String(),
					P256dh:   "p256",
					Auth:     "auth",
				},
			}, nil
		},
	}

	sendCalls := 0
	mockSender := &mockPushSender{
		sendFunc: func(ctx context.Context, message []byte, sub *webpush.Subscription) (*http.Response, error) {
			sendCalls++
			return &http.Response{
				StatusCode: http.StatusOK,
				Body:       io.NopCloser(bytes.NewReader(nil)),
			}, nil
		},
	}

	svc := service.NewNotificationService(mockStore, mockSender)
	totalSent, err := svc.CheckAndNotifyExpiring(context.Background(), time.Now())

	require.NoError(t, err)
	assert.Equal(t, 2, totalSent)
	assert.Equal(t, 2, sendCalls)
}

func TestExpirationWorker_StartAndStop(t *testing.T) {
	mockStore := &mockNotificationQuerier{
		listExpiringFunc: func(ctx context.Context, arg store.ListExpiringInventoryItemsParams) ([]store.ListExpiringInventoryItemsRow, error) {
			return nil, nil
		},
	}

	svc := service.NewNotificationService(mockStore, &mockPushSender{})
	worker := service.NewExpirationWorker(svc, 10*time.Millisecond)

	worker.Start()
	time.Sleep(50 * time.Millisecond)
	worker.Stop()
}

func TestExpirationWorker_ImmediateStartupCheck(t *testing.T) {
	var called atomic.Int32
	mockStore := &mockNotificationQuerier{
		listExpiringFunc: func(ctx context.Context, arg store.ListExpiringInventoryItemsParams) ([]store.ListExpiringInventoryItemsRow, error) {
			called.Add(1)
			return nil, nil
		},
	}

	svc := service.NewNotificationService(mockStore, &mockPushSender{})
	// Set interval to 24 hours to prove it runs without waiting for ticker
	worker := service.NewExpirationWorker(svc, 24*time.Hour)

	worker.Start()
	time.Sleep(50 * time.Millisecond)
	worker.Stop()

	assert.GreaterOrEqual(t, called.Load(), int32(1), "worker must execute check immediately on startup")
}
