import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import {
  isPushSupported,
  getNotificationPermission,
  getCurrentPushSubscription,
  subscribeToPush,
  unsubscribeFromPush
} from '@/utils/push'
import { getVapidPublicKeyApi, subscribePushApi } from '@/api/notifications'

export const useNotificationStore = defineStore('notification', () => {
  const supported = ref(isPushSupported())
  const permission = ref<NotificationPermission>(getNotificationPermission())
  const isSubscribed = ref(false)
  const isLoading = ref(false)

  const isGranted = computed(() => permission.value === 'granted')

  async function checkSubscription() {
    supported.value = isPushSupported()
    permission.value = getNotificationPermission()

    if (!supported.value) {
      isSubscribed.value = false
      return
    }

    const currentSub = await getCurrentPushSubscription()
    isSubscribed.value = currentSub !== null
  }

  async function enableNotifications(): Promise<boolean> {
    if (!supported.value) return false
    isLoading.value = true

    try {
      let vapidKey = await getVapidPublicKeyApi()
      if (!vapidKey) {
        vapidKey = (import.meta.env.VITE_VAPID_PUBLIC_KEY as string) || ''
      }

      if (!vapidKey) {
        throw new Error('VAPID public key not found')
      }

      const sub = await subscribeToPush(vapidKey)
      if (!sub) {
        permission.value = getNotificationPermission()
        return false
      }

      const subJSON = sub.toJSON()
      if (subJSON.endpoint) {
        await subscribePushApi({
          endpoint: subJSON.endpoint,
          keys: subJSON.keys
            ? {
                p256dh: subJSON.keys.p256dh || '',
                auth: subJSON.keys.auth || ''
              }
            : undefined
        })
      }

      permission.value = 'granted'
      isSubscribed.value = true
      return true
    } catch {
      return false
    } finally {
      isLoading.value = false
    }
  }

  async function disableNotifications(): Promise<boolean> {
    isLoading.value = true
    try {
      const ok = await unsubscribeFromPush()
      if (ok) {
        isSubscribed.value = false
      }
      return ok
    } finally {
      isLoading.value = false
    }
  }

  return {
    supported,
    permission,
    isSubscribed,
    isLoading,
    isGranted,
    checkSubscription,
    enableNotifications,
    disableNotifications
  }
})
