import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { useAuthStore } from './auth'
import * as authApi from '@/api/auth'
import * as userApi from '@/api/user'

const storage: Record<string, string> = {}
const mockLocalStorage = {
  getItem: (key: string) => storage[key] ?? null,
  setItem: (key: string, val: string) => {
    storage[key] = String(val)
  },
  removeItem: (key: string) => {
    delete storage[key]
  },
  clear: () => {
    Object.keys(storage).forEach((k) => delete storage[k])
  },
  key: (i: number) => Object.keys(storage)[i] ?? null,
  length: 0
}

Object.defineProperty(globalThis, 'localStorage', {
  value: mockLocalStorage,
  writable: true
})

vi.mock('@/api/auth', () => ({
  loginApi: vi.fn(),
  registerApi: vi.fn(),
  logoutApi: vi.fn(),
  refreshApi: vi.fn()
}))

vi.mock('@/api/user', () => ({
  getMeApi: vi.fn(),
  updateAllergensApi: vi.fn()
}))

describe('useAuthStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
    vi.clearAllMocks()
  })

  it('initially has no authenticated user', () => {
    const store = useAuthStore()
    expect(store.isAuthenticated).toBe(false)
    expect(store.user).toBeNull()
    expect(store.accessToken).toBeNull()
  })

  it('logs in and stores user session', async () => {
    const mockUserResponse = {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Иван',
      excluded_ingredient_ids: [42],
      created_at: '2026-10-31T20:00:00Z'
    }

    vi.mocked(authApi.loginApi).mockResolvedValueOnce({
      access_token: 'mock-jwt-token',
      user: mockUserResponse
    })

    const store = useAuthStore()
    await store.login({ email: 'test@example.com', password: 'password123' })

    expect(store.isAuthenticated).toBe(true)
    expect(store.accessToken).toBe('mock-jwt-token')
    expect(store.user?.email).toBe('test@example.com')
    expect(store.user?.excludedIngredientIds).toEqual([42])
    expect(store.primaryAllergenId).toBe(42)
    expect(localStorage.getItem('access_token')).toBe('mock-jwt-token')
  })

  it('updates excluded allergen', async () => {
    const store = useAuthStore()
    store.user = {
      id: 'user-123',
      email: 'test@example.com',
      name: 'Иван',
      excludedIngredientIds: [],
      createdAt: '2026-10-31T20:00:00Z'
    }
    store.accessToken = 'mock-token'

    vi.mocked(userApi.updateAllergensApi).mockResolvedValueOnce({
      id: 'user-123',
      email: 'test@example.com',
      name: 'Иван',
      excluded_ingredient_ids: [15],
      created_at: '2026-10-31T20:00:00Z'
    })

    await store.setAllergen(15)
    expect(userApi.updateAllergensApi).toHaveBeenCalledWith([15])
    expect(store.primaryAllergenId).toBe(15)
  })

  it('logs out and clears session', async () => {
    const store = useAuthStore()
    store.accessToken = 'token-to-clear'
    store.user = {
      id: 'u1',
      email: 'e@e.com',
      name: 'U',
      excludedIngredientIds: [],
      createdAt: ''
    }
    localStorage.setItem('access_token', 'token-to-clear')

    vi.mocked(authApi.logoutApi).mockResolvedValueOnce()

    await store.logout()

    expect(store.isAuthenticated).toBe(false)
    expect(store.accessToken).toBeNull()
    expect(store.user).toBeNull()
    expect(localStorage.getItem('access_token')).toBeNull()
  })
})
