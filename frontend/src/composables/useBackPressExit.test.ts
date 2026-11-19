import { describe, it, expect, beforeEach, vi } from 'vitest'
import {
  createBackPressGuard,
  EXIT_WINDOW_MS,
  EXIT_TOAST_MESSAGE
} from './useBackPressExit'
import { activeModalCount, resetModalStack } from '@/utils/modalStack'

describe('createBackPressGuard', () => {
  let mockRouter: { replace: ReturnType<typeof vi.fn>; back: ReturnType<typeof vi.fn> }
  let currentRoute: { name: string; path: string; params: Record<string, string> }
  let mockToast: { show: ReturnType<typeof vi.fn> }

  beforeEach(() => {
    resetModalStack()
    mockRouter = {
      replace: vi.fn(),
      back: vi.fn()
    }
    currentRoute = {
      name: 'fridge',
      path: '/fridge',
      params: {}
    }
    mockToast = {
      show: vi.fn()
    }
  })

  it('shows toast on first back gesture on root screen without exiting', () => {
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockToast.show).toHaveBeenCalledTimes(1)
    expect(mockToast.show).toHaveBeenCalledWith(EXIT_TOAST_MESSAGE, 'info', EXIT_WINDOW_MS)
    expect(guard.getIsExiting()).toBe(false)
    expect(guard.getLastBackPressTime()).toBeGreaterThan(0)
  })

  it('allows exit on second back gesture within 2000ms', () => {
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    // First back gesture
    guard.handlePopState()
    expect(mockToast.show).toHaveBeenCalledTimes(1)
    expect(guard.getIsExiting()).toBe(false)

    // Second back gesture immediately (e.g. 500ms later)
    guard.handlePopState()
    expect(guard.getIsExiting()).toBe(true)
    // Toast should not be called a second time
    expect(mockToast.show).toHaveBeenCalledTimes(1)
  })

  it('resets timer and shows toast again if second back gesture is after 2000ms', () => {
    vi.useFakeTimers()
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    // First back press at t = 0
    guard.handlePopState()
    expect(mockToast.show).toHaveBeenCalledTimes(1)
    expect(guard.getIsExiting()).toBe(false)

    // Advance time by 2500ms (timeout expired)
    vi.advanceTimersByTime(2500)

    // Second back press after timeout
    guard.handlePopState()
    expect(mockToast.show).toHaveBeenCalledTimes(2)
    expect(guard.getIsExiting()).toBe(false)

    vi.useRealTimers()
  })

  it('does nothing when a modal is open, allowing modal to close', () => {
    activeModalCount.value = 1
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockToast.show).not.toHaveBeenCalled()
    expect(guard.getIsExiting()).toBe(false)
    expect(guard.getLastBackPressTime()).toBe(0)
  })

  it('navigates to /recipes when back is pressed on recipe-detail without exit toast', () => {
    currentRoute = {
      name: 'recipe-detail',
      path: '/recipes/42',
      params: { id: '42' }
    }
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockRouter.replace).toHaveBeenCalledWith('/recipes')
    expect(mockToast.show).not.toHaveBeenCalled()
    expect(guard.getIsExiting()).toBe(false)
  })

  it('navigates to /recipes/:id when back is pressed in cook-mode', () => {
    currentRoute = {
      name: 'cook-mode',
      path: '/recipes/42/cook',
      params: { id: '42' }
    }
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockRouter.replace).toHaveBeenCalledWith('/recipes/42')
    expect(mockToast.show).not.toHaveBeenCalled()
    expect(guard.getIsExiting()).toBe(false)
  })

  it('navigates to /profile when back is pressed on login or register', () => {
    currentRoute = {
      name: 'login',
      path: '/login',
      params: {}
    }
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockRouter.replace).toHaveBeenCalledWith('/profile')
    expect(mockToast.show).not.toHaveBeenCalled()
    expect(guard.getIsExiting()).toBe(false)
  })
})
