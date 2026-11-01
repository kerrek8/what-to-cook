package dto

import "time"

type PushKeys struct {
	P256dh string `json:"p256dh"`
	Auth   string `json:"auth"`
}

type SubscribeNotificationRequest struct {
	Endpoint string    `json:"endpoint" binding:"required"`
	Keys     *PushKeys `json:"keys,omitempty"`
	P256dh   string    `json:"p256dh,omitempty"`
	Auth     string    `json:"auth,omitempty"`
}

func (r *SubscribeNotificationRequest) GetP256dh() string {
	if r.Keys != nil && r.Keys.P256dh != "" {
		return r.Keys.P256dh
	}
	return r.P256dh
}

func (r *SubscribeNotificationRequest) GetAuth() string {
	if r.Keys != nil && r.Keys.Auth != "" {
		return r.Keys.Auth
	}
	return r.Auth
}

type PushSubscriptionResponse struct {
	ID        string    `json:"id"`
	Endpoint  string    `json:"endpoint"`
	CreatedAt time.Time `json:"created_at"`
}

type PushNotificationPayload struct {
	Title string `json:"title"`
	Body  string `json:"body"`
	Icon  string `json:"icon,omitempty"`
	URL   string `json:"url,omitempty"`
}
