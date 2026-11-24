import { describe, it, expect, beforeEach, vi } from 'vitest'
import {
  createBackPressGuard,
  EXIT_WINDOW_MS,
  EXIT_TOAST_MESSAGE
} from './useBackPressExit'
import { activeModalCount, resetModalStack } from '@/utils/modalStack'

describe('createBackPressGuard', () => {
  let mockRouter: {
    replace: ReturnType<typeof vi.fn>
    back: ReturnType<typeof vi.fn>
    beforeEach: ReturnType<typeof vi.fn>
    afterEach: ReturnType<typeof vi.fn>
  }
  let currentRoute: { name: string; path: string; params: Record<string, string> }
  let mockToast: { show: ReturnType<typeof vi.fn> }

  beforeEach(() => {
    resetModalStack()
    mockRouter = {
      replace: vi.fn(),
      back: vi.fn(),
      beforeEach: vi.fn(),
      afterEach: vi.fn()
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

  it('shows toast on first back gesture on root screen without exiting and keeps current path', () => {
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockToast.show).toHaveBeenCalledTimes(1)
    expect(mockToast.show).toHaveBeenCalledWith(EXIT_TOAST_MESSAGE, 'info', EXIT_WINDOW_MS)
    expect(mockRouter.replace).toHaveBeenCalledWith('/fridge')
    expect(guard.getIsExiting()).toBe(false)
    expect(guard.getLastBackPressTime()).toBeGreaterThan(0)
  })

  it('prevents navigation from recipes back to fridge on back gesture and stays on recipes', () => {
    currentRoute = {
      name: 'recipes',
      path: '/recipes',
      params: {}
    }
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)
    guard.setIsPopState(true)

    // Simulate navigation attempt from recipes to fridge via back gesture
    const result = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'recipes', path: '/recipes' })

    // Must return false to cancel navigation to fridge
    expect(result).toBe(false)
    expect(mockToast.show).toHaveBeenCalledWith(EXIT_TOAST_MESSAGE, 'info', EXIT_WINDOW_MS)
    expect(guard.getIsExiting()).toBe(false)
  })

  it('allows exit when back is pressed twice within 2000ms on recipes tab', () => {
    currentRoute = {
      name: 'recipes',
      path: '/recipes',
      params: {}
    }
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)
    guard.setIsPopState(true)

    // First back gesture on recipes
    const res1 = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'recipes', path: '/recipes' })
    expect(res1).toBe(false)
    expect(mockToast.show).toHaveBeenCalledTimes(1)
    expect(guard.getIsExiting()).toBe(false)

    // Second back gesture within 2s on recipes
    const res2 = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'recipes', path: '/recipes' })
    expect(res2).toBe(true)
    expect(guard.getIsExiting()).toBe(true)
  })

  it('allows exit on second back gesture within 2000ms via handlePopState', () => {
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    // First back gesture
    guard.handlePopState()
    expect(mockToast.show).toHaveBeenCalledTimes(1)
    expect(guard.getIsExiting()).toBe(false)

    // Second back gesture immediately (e.g. 500ms later)
    guard.handlePopState()
    expect(guard.getIsExiting()).toBe(true)
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

  it('allows normal tab switching when user clicks tabs without popstate', () => {
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)
    guard.setIsPopState(false)

    // User clicked on recipes tab
    const result = guard.onBeforeEach({ name: 'recipes', path: '/recipes' }, { name: 'fridge', path: '/fridge' })

    // Normal navigation allowed without exit toast
    expect(result).toBe(true)
    expect(mockToast.show).not.toHaveBeenCalled()
  })

  it('does nothing when a modal is open, allowing modal to close', () => {
    activeModalCount.value = 1
    const guard = createBackPressGuard(mockRouter, () => currentRoute, mockToast)

    guard.handlePopState()

    expect(mockToast.show).not.toHaveBeenCalled()
    expect(guard.getIsExiting()).toBe(false)
    expect(guard.getLastBackPressTime()).toBe(0)

    guard.setIsPopState(true)
    const result = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'recipes', path: '/recipes' })
    expect(result).toBe(false)
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

    guard.setIsPopState(true)
    const res = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'recipe-detail', path: '/recipes/42' })
    expect(res).toBe('/recipes')
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

    guard.setIsPopState(true)
    const res = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'cook-mode', path: '/recipes/42/cook', params: { id: '42' } })
    expect(res).toBe('/recipes/42')
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

    guard.setIsPopState(true)
    const res = guard.onBeforeEach({ name: 'fridge', path: '/fridge' }, { name: 'login', path: '/login' })
    expect(res).toBe('/profile')
  })
})
