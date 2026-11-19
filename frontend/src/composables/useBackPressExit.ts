import { onMounted, onUnmounted } from 'vue'
import { useRouter, useRoute, type Router, type RouteLocationNormalizedLoaded } from 'vue-router'
import { useToastStore } from '@/stores/toast'
import { activeModalCount } from '@/utils/modalStack'

export const ROOT_ROUTES = ['fridge', 'recipes', 'shopping', 'profile']
export const EXIT_WINDOW_MS = 2000
export const EXIT_TOAST_MESSAGE = 'Нажмите «Назад» еще раз, чтобы выйти'

export interface BackPressToastNotifier {
  show: (message: string, type?: 'success' | 'fail' | 'info', duration?: number) => void
}

export function createBackPressGuard(
  router: Pick<Router, 'replace' | 'back'>,
  getRoute: () => Pick<RouteLocationNormalizedLoaded, 'name' | 'path' | 'params'>,
  toast: BackPressToastNotifier
) {
  let lastBackPressTime = 0
  let isExiting = false

  function pushRootGuard() {
    if (typeof window === 'undefined') return
    try {
      window.history.pushState({ isAppRootGuard: true }, '')
    } catch {
      // Ignored if pushState not permitted in certain environments
    }
  }

  function handlePopState(e?: PopStateEvent) {
    // 1. If any bottom sheet / modal is open, let the modal's handler close it
    if (activeModalCount.value > 0) {
      return
    }

    if (isExiting) {
      return
    }

    const route = getRoute()
    const routeName = String(route.name || '')
    const isRoot = ROOT_ROUTES.includes(routeName) || route.path === '/'

    // 2. If user is on a child route, navigate to parent screen inside app
    if (!isRoot) {
      if (routeName === 'cook-mode') {
        const id = route.params?.id
        router.replace(`/recipes/${id}`)
      } else if (routeName === 'recipe-detail') {
        router.replace('/recipes')
      } else if (routeName === 'login' || routeName === 'register') {
        router.replace('/profile')
      }
      pushRootGuard()
      return
    }

    // 3. User is on a root tab. Check double-back window
    const now = Date.now()
    if (now - lastBackPressTime < EXIT_WINDOW_MS) {
      // Confirmed exit on second back gesture within 2 seconds
      isExiting = true
      try {
        window.history.back()
      } catch {
        // Ignored
      }
    } else {
      // First back gesture: block exit, show toast, re-push guard
      lastBackPressTime = now
      toast.show(EXIT_TOAST_MESSAGE, 'info', EXIT_WINDOW_MS)
      pushRootGuard()
    }
  }

  function setup() {
    if (typeof window === 'undefined') return
    pushRootGuard()
    window.addEventListener('popstate', handlePopState)
  }

  function cleanup() {
    if (typeof window === 'undefined') return
    window.removeEventListener('popstate', handlePopState)
  }

  return {
    pushRootGuard,
    handlePopState,
    setup,
    cleanup,
    getLastBackPressTime: () => lastBackPressTime,
    getIsExiting: () => isExiting,
    resetState: () => {
      lastBackPressTime = 0
      isExiting = false
    }
  }
}

export function useBackPressExit() {
  const router = useRouter()
  const route = useRoute()
  const toast = useToastStore()

  const guard = createBackPressGuard(router, () => route, toast)

  onMounted(() => {
    guard.setup()
  })

  onUnmounted(() => {
    guard.cleanup()
  })

  return guard
}
