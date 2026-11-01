import { apiClient } from './client'

export interface PushKeys {
  p256dh: string
  auth: string
}

export interface SubscribePushPayload {
  endpoint: string
  keys?: PushKeys
  p256dh?: string
  auth?: string
}

export interface PushSubscriptionResponse {
  id: string
  endpoint: string
  created_at: string
}

export async function getVapidPublicKeyApi(): Promise<string> {
  try {
    const { data } = await apiClient.get<{ public_key: string }>('/api/v1/notifications/vapid-key')
    return data.public_key || ''
  } catch {
    return ''
  }
}

export async function subscribePushApi(
  payload: SubscribePushPayload
): Promise<PushSubscriptionResponse> {
  const { data } = await apiClient.post<PushSubscriptionResponse>(
    '/api/v1/notifications/subscribe',
    payload
  )
  return data
}

export async function listPushSubscriptionsApi(): Promise<PushSubscriptionResponse[]> {
  const { data } = await apiClient.get<PushSubscriptionResponse[]>('/api/v1/notifications/subscriptions')
  return data
}
