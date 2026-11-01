import { defineStore } from 'pinia'
import { ref } from 'vue'

export const usePwaStore = defineStore('pwa', () => {
  const canInstall = ref(false)
  const isInstalled = ref(
    typeof window !== 'undefined' &&
      (window.matchMedia('(display-mode: standalone)').matches ||
        (window.navigator as any).standalone === true)
  )

  let deferredPrompt: any = null

  if (typeof window !== 'undefined') {
    window.addEventListener('beforeinstallprompt', (e: Event) => {
      e.preventDefault()
      deferredPrompt = e
      canInstall.value = true
    })

    window.addEventListener('appinstalled', () => {
      deferredPrompt = null
      canInstall.value = false
      isInstalled.value = true
    })
  }

  async function installApp(): Promise<boolean> {
    if (!deferredPrompt) return false
    deferredPrompt.prompt()
    const { outcome } = await deferredPrompt.userChoice
    deferredPrompt = null
    canInstall.value = false
    return outcome === 'accepted'
  }

  return {
    canInstall,
    isInstalled,
    installApp
  }
})
