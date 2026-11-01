import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useNotificationStore } from './notification'
import * as pushUtils from '@/utils/push'
import * as notifApi from '@/api/notifications'

vi.mock('@/utils/push', () => ({
  isPushSupported: vi.fn(),
  getNotificationPermission: vi.fn(),
  getCurrentPushSubscription: vi.fn(),
  subscribeToPush: vi.fn(),
  unsubscribeFromPush: vi.fn()
}))

vi.mock('@/api/notifications', () => ({
  getVapidPublicKeyApi: vi.fn(),
  subscribePushApi: vi.fn(),
  listPushSubscriptionsApi: vi.fn()
}))

describe('useNotificationStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.clearAllMocks()
    vi.mocked(pushUtils.isPushSupported).mockReturnValue(true)
    vi.mocked(pushUtils.getNotificationPermission).mockReturnValue('default')
  })

  it('initializes with push supported', () => {
    const store = useNotificationStore()
    expect(store.supported).toBe(true)
    expect(store.permission).toBe('default')
    expect(store.isSubscribed).toBe(false)
  })

  it('checks subscription state from service worker', async () => {
    vi.mocked(pushUtils.getCurrentPushSubscription).mockResolvedValueOnce({
      endpoint: 'https://example.com/push/123'
    } as any)

    const store = useNotificationStore()
    await store.checkSubscription()

    expect(store.isSubscribed).toBe(true)
  })

  it('enables notifications and registers subscription with backend', async () => {
    vi.mocked(notifApi.getVapidPublicKeyApi).mockResolvedValueOnce('mock-vapid-public-key')

    const mockSub = {
      endpoint: 'https://fcm.googleapis.com/fcm/send/test',
      toJSON: () => ({
        endpoint: 'https://fcm.googleapis.com/fcm/send/test',
        keys: {
          p256dh: 'mock-p256dh',
          auth: 'mock-auth'
        }
      })
    }
    vi.mocked(pushUtils.subscribeToPush).mockResolvedValueOnce(mockSub as any)
    vi.mocked(notifApi.subscribePushApi).mockResolvedValueOnce({
      id: 'sub-1',
      endpoint: mockSub.endpoint,
      created_at: '2026-11-01'
    })

    const store = useNotificationStore()
    const result = await store.enableNotifications()

    expect(result).toBe(true)
    expect(store.isSubscribed).toBe(true)
    expect(store.permission).toBe('granted')
    expect(notifApi.subscribePushApi).toHaveBeenCalledWith({
      endpoint: mockSub.endpoint,
      keys: {
        p256dh: 'mock-p256dh',
        auth: 'mock-auth'
      }
    })
  })

  it('disables notifications when requested', async () => {
    vi.mocked(pushUtils.unsubscribeFromPush).mockResolvedValueOnce(true)

    const store = useNotificationStore()
    store.isSubscribed = true

    const result = await store.disableNotifications()
    expect(result).toBe(true)
    expect(store.isSubscribed).toBe(false)
  })
})
