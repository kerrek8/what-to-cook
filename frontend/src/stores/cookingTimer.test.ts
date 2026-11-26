import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useCookingTimerStore } from './cookingTimer'

describe('useCookingTimerStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    vi.useFakeTimers()
  })

  it('manages timer countdown and formatted string', () => {
    const store = useCookingTimerStore()
    store.setPreset(10)
    expect(store.formattedTime).toBe('10:00')
    store.start()
    expect(store.isRunning).toBe(true)

    vi.advanceTimersByTime(3000)
    expect(store.remainingSeconds).toBe(597)
    expect(store.formattedTime).toBe('09:57')

    store.pause()
    expect(store.isRunning).toBe(false)

    store.reset()
    expect(store.remainingSeconds).toBe(600)
    expect(store.formattedTime).toBe('10:00')
  })

  it('adjusts minutes dynamically', () => {
    const store = useCookingTimerStore()
    store.setPreset(5)
    store.adjustMinutes(2)
    expect(store.remainingSeconds).toBe(420)
    expect(store.formattedTime).toBe('07:00')
  })

  it('decrements timer by 5 minutes when adjustMinutes(-5) is called', () => {
    const store = useCookingTimerStore()
    store.setPreset(10) // 600s
    store.adjustMinutes(-5)
    expect(store.remainingSeconds).toBe(300)
    expect(store.formattedTime).toBe('05:00')
  })

  it('does not allow remainingSeconds to go below 0 on large negative adjustment', () => {
    const store = useCookingTimerStore()
    store.setPreset(2) // 120s
    store.adjustMinutes(-5) // -300s -> should clamp to 0
    expect(store.remainingSeconds).toBe(0)
    expect(store.formattedTime).toBe('00:00')
  })

  it('tracks recipeId and recipeTitle for navigation and pill', () => {
    const store = useCookingTimerStore()
    expect(store.recipeId).toBeNull()
    store.setRecipe(42, 'Паста Карбонара')
    expect(store.recipeId).toBe(42)
    expect(store.recipeTitle).toBe('Паста Карбонара')
  })

  it('resets timer back to initial preset after adjustments and countdown', () => {
    const store = useCookingTimerStore()
    store.setPreset(15)
    store.adjustMinutes(5) // now 20 mins
    expect(store.remainingSeconds).toBe(1200)

    store.start()
    vi.advanceTimersByTime(5000)
    expect(store.remainingSeconds).toBe(1195)

    store.reset()
    expect(store.remainingSeconds).toBe(900)
    expect(store.formattedTime).toBe('15:00')
    expect(store.isRunning).toBe(false)
  })
})
