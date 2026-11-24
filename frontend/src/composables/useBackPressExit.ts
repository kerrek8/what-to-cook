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

export interface GuardRouter {
  replace: (to: string) => Promise<any> | void
  back: () => void
  beforeEach?: (guard: (to: any, from: any) => any) => () => void
  afterEach?: (guard: (to: any) => void) => () => void
}

export function createBackPressGuard(
  router: GuardRouter,
  getRoute: () => Pick<RouteLocationNormalizedLoaded, 'name' | 'path' | 'params'>,
  toast: BackPressToastNotifier
) {
  let lastBackPressTime = 0
  let isExiting = false
  let isPopState = false
  let popstateResetTimer: ReturnType<typeof setTimeout> | null = null
  let unregisterBeforeEach: (() => void) | null = null
  let unregisterAfterEach: (() => void) | null = null

  let activeRoute: Pick<RouteLocationNormalizedLoaded, 'name' | 'path' | 'params'> = getRoute()

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

    // Always use the route the user was on before the pop action
    const current = activeRoute || getRoute()
    const routeName = String(current.name || '')
    const isRoot = ROOT_ROUTES.includes(routeName) || current.path === '/'

    // 2. If user is on a child route, navigate to parent screen inside app
    if (!isRoot) {
      if (routeName === 'cook-mode') {
        const id = current.params?.id
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
      // First back gesture on root tab:
      // Block exit, show toast, and STAY ON CURRENT ROOT TAB (prevent jumping to previous tab)
      lastBackPressTime = now
      toast.show(EXIT_TOAST_MESSAGE, 'info', EXIT_WINDOW_MS)
      router.replace(current.path)
      pushRootGuard()
    }
  }

  function onBeforeEach(to: any, from: any) {
    if (!isPopState) {
      return true
    }

    const fromName = String(from?.name || '')
    const isFromRoot = ROOT_ROUTES.includes(fromName) || from?.path === '/'

    // 1. If a modal is open, cancel route navigation to allow modal to close in place
    if (activeModalCount.value > 0) {
      return false
    }

    if (isExiting) {
      return true
    }

    // 2. If back was pressed on a root route:
    if (isFromRoot) {
      const now = Date.now()
      if (now - lastBackPressTime < EXIT_WINDOW_MS) {
        isExiting = true
        return true
      } else {
        lastBackPressTime = now
        toast.show(EXIT_TOAST_MESSAGE, 'info', EXIT_WINDOW_MS)
        pushRootGuard()
        return false // Cancel navigation to previous tab (e.g. from recipes back to fridge)
      }
    }

    // 3. Child routes
    if (fromName === 'cook-mode') {
      const id = from.params?.id
      return `/recipes/${id}`
    } else if (fromName === 'recipe-detail') {
      return '/recipes'
    } else if (fromName === 'login' || fromName === 'register') {
      return '/profile'
    }

    return true
  }

  function onWindowPopState(e: PopStateEvent) {
    isPopState = true
    if (popstateResetTimer) clearTimeout(popstateResetTimer)
    popstateResetTimer = setTimeout(() => {
      isPopState = false
    }, 100)
    handlePopState(e)
  }

  function setup() {
    if (typeof window === 'undefined') return
    pushRootGuard()
    window.addEventListener('popstate', onWindowPopState, { capture: true })

    if (router.beforeEach) {
      unregisterBeforeEach = router.beforeEach(onBeforeEach)
    }

    if (router.afterEach) {
      unregisterAfterEach = router.afterEach((to) => {
        activeRoute = {
          name: to.name,
          path: to.path,
          params: to.params
        }
        isPopState = false
      })
    }
  }

  function cleanup() {
    if (typeof window !== 'undefined') {
      window.removeEventListener('popstate', onWindowPopState, { capture: true })
    }
    if (unregisterBeforeEach) {
      unregisterBeforeEach()
      unregisterBeforeEach = null
    }
    if (unregisterAfterEach) {
      unregisterAfterEach()
      unregisterAfterEach = null
    }
    if (popstateResetTimer) {
      clearTimeout(popstateResetTimer)
      popstateResetTimer = null
    }
  }

  return {
    pushRootGuard,
    handlePopState,
    onBeforeEach,
    setup,
    cleanup,
    setActiveRoute: (route: Pick<RouteLocationNormalizedLoaded, 'name' | 'path' | 'params'>) => {
      activeRoute = route
    },
    setIsPopState: (val: boolean) => {
      isPopState = val
    },
    getLastBackPressTime: () => lastBackPressTime,
    getIsExiting: () => isExiting,
    resetState: () => {
      lastBackPressTime = 0
      isExiting = false
      isPopState = false
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
