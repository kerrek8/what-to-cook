package service

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"net/http"
	"strings"
	"time"

	"github.com/SherClockHolmes/webpush-go"
	"github.com/google/uuid"
	"github.com/jackc/pgx/v5/pgtype"
	"github.com/kerrek8/what-to-cook/backend/internal/dto"
	"github.com/kerrek8/what-to-cook/backend/internal/store"
)

var (
	ErrInvalidSubscription = errors.New("endpoint, p256dh and auth keys are required")
)

type PushSender interface {
	SendNotification(ctx context.Context, message []byte, sub *webpush.Subscription) (*http.Response, error)
}

type defaultPushSender struct {
	subject    string
	publicKey  string
	privateKey string
	client     *http.Client
}

func NewDefaultPushSender(subject, publicKey, privateKey string, client *http.Client) PushSender {
	if client == nil {
		client = &http.Client{Timeout: 10 * time.Second}
	}
	return &defaultPushSender{
		subject:    subject,
		publicKey:  publicKey,
		privateKey: privateKey,
		client:     client,
	}
}

func (s *defaultPushSender) SendNotification(ctx context.Context, message []byte, sub *webpush.Subscription) (*http.Response, error) {
	if s.publicKey == "" || s.privateKey == "" {
		return nil, errors.New("VAPID keys not configured")
	}
	return webpush.SendNotificationWithContext(ctx, message, sub, &webpush.Options{
		Subscriber:      s.subject,
		VAPIDPublicKey:  s.publicKey,
		VAPIDPrivateKey: s.privateKey,
		TTL:             30,
		HTTPClient:      s.client,
	})
}

type NotificationService interface {
	Subscribe(ctx context.Context, userID uuid.UUID, req dto.SubscribeNotificationRequest) (*dto.PushSubscriptionResponse, error)
	ListSubscriptions(ctx context.Context, userID uuid.UUID) ([]dto.PushSubscriptionResponse, error)
	SendToUser(ctx context.Context, userID uuid.UUID, payload dto.PushNotificationPayload) (int, error)
	CheckAndNotifyExpiring(ctx context.Context, now time.Time) (int, error)
}

type notificationService struct {
	store  store.Querier
	sender PushSender
}

func NewNotificationService(st store.Querier, sender PushSender) NotificationService {
	return &notificationService{
		store:  st,
		sender: sender,
	}
}

func (s *notificationService) Subscribe(ctx context.Context, userID uuid.UUID, req dto.SubscribeNotificationRequest) (*dto.PushSubscriptionResponse, error) {
	p256dh := strings.TrimSpace(req.GetP256dh())
	auth := strings.TrimSpace(req.GetAuth())
	endpoint := strings.TrimSpace(req.Endpoint)

	if endpoint == "" || p256dh == "" || auth == "" {
		return nil, ErrInvalidSubscription
	}

	sub, err := s.store.UpsertPushSubscription(ctx, store.UpsertPushSubscriptionParams{
		UserID:   pgtype.UUID{Bytes: userID, Valid: true},
		Endpoint: endpoint,
		P256dh:   p256dh,
		Auth:     auth,
	})
	if err != nil {
		return nil, err
	}

	return &dto.PushSubscriptionResponse{
		ID:        uuid.UUID(sub.ID.Bytes).String(),
		Endpoint:  sub.Endpoint,
		CreatedAt: sub.CreatedAt.Time,
	}, nil
}

func (s *notificationService) ListSubscriptions(ctx context.Context, userID uuid.UUID) ([]dto.PushSubscriptionResponse, error) {
	subs, err := s.store.ListPushSubscriptionsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return nil, err
	}

	result := make([]dto.PushSubscriptionResponse, len(subs))
	for i, sub := range subs {
		result[i] = dto.PushSubscriptionResponse{
			ID:        uuid.UUID(sub.ID.Bytes).String(),
			Endpoint:  sub.Endpoint,
			CreatedAt: sub.CreatedAt.Time,
		}
	}
	return result, nil
}

func (s *notificationService) SendToUser(ctx context.Context, userID uuid.UUID, payload dto.PushNotificationPayload) (int, error) {
	subs, err := s.store.ListPushSubscriptionsByUserID(ctx, pgtype.UUID{Bytes: userID, Valid: true})
	if err != nil {
		return 0, err
	}

	if len(subs) == 0 {
		return 0, nil
	}

	payloadBytes, err := json.Marshal(payload)
	if err != nil {
		return 0, err
	}

	sentCount := 0
	for _, sub := range subs {
		webSub := &webpush.Subscription{
			Endpoint: sub.Endpoint,
			Keys: webpush.Keys{
				P256dh: sub.P256dh,
				Auth:   sub.Auth,
			},
		}

		resp, err := s.sender.SendNotification(ctx, payloadBytes, webSub)
		if err != nil {
			continue
		}
		if resp != nil {
			if resp.StatusCode == http.StatusNotFound || resp.StatusCode == http.StatusGone {
				_ = s.store.DeletePushSubscriptionByEndpoint(ctx, sub.Endpoint)
				_ = resp.Body.Close()
				continue
			}
			_ = resp.Body.Close()
			if resp.StatusCode >= 200 && resp.StatusCode < 300 {
				sentCount++
			}
		} else {
			sentCount++
		}
	}

	return sentCount, nil
}

func (s *notificationService) CheckAndNotifyExpiring(ctx context.Context, now time.Time) (int, error) {
	var minDate, maxDate pgtype.Date
	_ = minDate.Scan(now.Format("2006-01-02"))
	_ = maxDate.Scan(now.AddDate(0, 0, 1).Format("2006-01-02"))

	items, err := s.store.ListExpiringInventoryItems(ctx, store.ListExpiringInventoryItemsParams{
		MinExpirationDate: minDate,
		MaxExpirationDate: maxDate,
	})
	if err != nil {
		return 0, err
	}

	if len(items) == 0 {
		return 0, nil
	}

	userItems := make(map[uuid.UUID][]string)
	for _, item := range items {
		uID := uuid.UUID(item.UserID.Bytes)
		name := "Продукт"
		if item.IngredientName.Valid && item.IngredientName.String != "" {
			name = item.IngredientName.String
		} else if item.CustomName.Valid && item.CustomName.String != "" {
			name = item.CustomName.String
		}
		userItems[uID] = append(userItems[uID], name)
	}

	totalSent := 0
	for uID, names := range userItems {
		var body string
		if len(names) <= 3 {
			body = fmt.Sprintf("Скоро испортятся: %s. Приготовьте что-нибудь вкусное!", strings.Join(names, ", "))
		} else {
			body = fmt.Sprintf("Скоро испортятся: %s и ещё %d прод. Приготовьте что-нибудь вкусное!", strings.Join(names[:3], ", "), len(names)-3)
		}

		payload := dto.PushNotificationPayload{
			Title: "Истекает срок годности!",
			Body:  body,
			URL:   "/inventory",
		}

		sent, err := s.SendToUser(ctx, uID, payload)
		if err == nil {
			totalSent += sent
		}
	}

	return totalSent, nil
}

type ExpirationWorker struct {
	service  NotificationService
	interval time.Duration
	stopChan chan struct{}
	doneChan chan struct{}
}

func NewExpirationWorker(svc NotificationService, interval time.Duration) *ExpirationWorker {
	if interval <= 0 {
		interval = 24 * time.Hour
	}
	return &ExpirationWorker{
		service:  svc,
		interval: interval,
		stopChan: make(chan struct{}),
		doneChan: make(chan struct{}),
	}
}

func (w *ExpirationWorker) Start() {
	go func() {
		defer close(w.doneChan)

		// Run immediate check on worker startup
		initCtx, initCancel := context.WithTimeout(context.Background(), 2*time.Minute)
		_, _ = w.service.CheckAndNotifyExpiring(initCtx, time.Now())
		initCancel()

		ticker := time.NewTicker(w.interval)
		defer ticker.Stop()

		for {
			select {
			case <-ticker.C:
				ctx, cancel := context.WithTimeout(context.Background(), 2*time.Minute)
				_, _ = w.service.CheckAndNotifyExpiring(ctx, time.Now())
				cancel()
			case <-w.stopChan:
				return
			}
		}
	}()
}

func (w *ExpirationWorker) Stop() {
	close(w.stopChan)
	<-w.doneChan
}
