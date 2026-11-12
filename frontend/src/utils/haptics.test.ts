import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { triggerHaptic } from './haptics'

describe('triggerHaptic', () => {
  const originalNavigator = globalThis.navigator

  beforeEach(() => {
    vi.restoreAllMocks()
  })

  afterEach(() => {
    Object.defineProperty(globalThis, 'navigator', {
      value: originalNavigator,
      writable: true,
      configurable: true
    })
  })

  it('returns false when navigator is undefined', () => {
    Object.defineProperty(globalThis, 'navigator', {
      value: undefined,
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('light')
    expect(result).toBe(false)
  })

  it('returns false when navigator.vibrate is not available', () => {
    Object.defineProperty(globalThis, 'navigator', {
      value: {},
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('light')
    expect(result).toBe(false)
  })

  it('triggers light haptic with 15ms duration by default', () => {
    const vibrateMock = vi.fn().mockReturnValue(true)
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic()
    expect(vibrateMock).toHaveBeenCalledWith(15)
    expect(result).toBe(true)
  })

  it('triggers light haptic with 15ms duration when explicitly requested', () => {
    const vibrateMock = vi.fn().mockReturnValue(true)
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('light')
    expect(vibrateMock).toHaveBeenCalledWith(15)
    expect(result).toBe(true)
  })

  it('triggers medium haptic with 35ms duration', () => {
    const vibrateMock = vi.fn().mockReturnValue(true)
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('medium')
    expect(vibrateMock).toHaveBeenCalledWith(35)
    expect(result).toBe(true)
  })

  it('triggers success haptic with [50, 50, 100] pattern', () => {
    const vibrateMock = vi.fn().mockReturnValue(true)
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('success')
    expect(vibrateMock).toHaveBeenCalledWith([50, 50, 100])
    expect(result).toBe(true)
  })

  it('triggers warning haptic with [100, 50, 100] pattern', () => {
    const vibrateMock = vi.fn().mockReturnValue(true)
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('warning')
    expect(vibrateMock).toHaveBeenCalledWith([100, 50, 100])
    expect(result).toBe(true)
  })

  it('handles navigator.vibrate returning false safely', () => {
    const vibrateMock = vi.fn().mockReturnValue(false)
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('light')
    expect(vibrateMock).toHaveBeenCalledWith(15)
    expect(result).toBe(false)
  })

  it('handles navigator.vibrate throwing an error gracefully', () => {
    const vibrateMock = vi.fn().mockImplementation(() => {
      throw new Error('Vibration disabled')
    })
    Object.defineProperty(globalThis, 'navigator', {
      value: { vibrate: vibrateMock },
      writable: true,
      configurable: true
    })

    const result = triggerHaptic('light')
    expect(result).toBe(false)
  })
})
