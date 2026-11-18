import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useToastStore } from './toast'

describe('useToastStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.useFakeTimers()
  })

  it('adds and auto-removes a toast after timeout', () => {
    const store = useToastStore()
    store.show('Продукт сохранен', 'success', 1000)
    expect(store.toasts.length).toBe(1)
    expect(store.toasts[0].message).toBe('Продукт сохранен')
    expect(store.toasts[0].type).toBe('success')

    vi.advanceTimersByTime(1100)
    expect(store.toasts.length).toBe(0)
  })

  it('allows manual dismissal of a toast', () => {
    const store = useToastStore()
    const id = store.show('Внимание', 'fail')
    expect(store.toasts.length).toBe(1)
    store.dismiss(id)
    expect(store.toasts.length).toBe(0)
  })
})
