import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { LoginPayload, RegisterPayload, User, UserBackendResponse } from '@/types/api'
import { loginApi, registerApi, logoutApi, refreshApi } from '@/api/auth'
import { getMeApi, updateAllergensApi, updatePantryApi } from '@/api/user'

function mapUser(res: UserBackendResponse): User {
  return {
    id: res.id,
    email: res.email,
    name: res.name,
    excludedIngredientIds: res.excluded_ingredient_ids || [],
    pantryIngredientIds: res.pantry_ingredient_ids || [],
    createdAt: res.created_at
  }
}

export const useAuthStore = defineStore('auth', () => {
  const user = ref<User | null>(null)
  const accessToken = ref<string | null>(localStorage.getItem('access_token'))
  const isLoading = ref<boolean>(false)
  const isInitialized = ref<boolean>(false)

  const isAuthenticated = computed(() => Boolean(accessToken.value && user.value))
  const primaryAllergenId = computed<number | null>(() => {
    if (!user.value || !user.value.excludedIngredientIds.length) {
      return null
    }
    return user.value.excludedIngredientIds[0]
  })

  function setSession(token: string, userData: UserBackendResponse) {
    accessToken.value = token
    user.value = mapUser(userData)
    localStorage.setItem('access_token', token)
  }

  function clearSession() {
    accessToken.value = null
    user.value = null
    localStorage.removeItem('access_token')
  }

  async function login(payload: LoginPayload): Promise<void> {
    isLoading.value = true
    try {
      const res = await loginApi(payload)
      setSession(res.access_token, res.user)
    } finally {
      isLoading.value = false
    }
  }

  async function register(payload: RegisterPayload): Promise<void> {
    isLoading.value = true
    try {
      const res = await registerApi(payload)
      setSession(res.access_token, res.user)
    } finally {
      isLoading.value = false
    }
  }

  async function logout(): Promise<void> {
    isLoading.value = true
    try {
      await logoutApi()
    } catch {
      // Ignore network errors on logout
    } finally {
      clearSession()
      isLoading.value = false
    }
  }

  async function fetchProfile(): Promise<User | null> {
    if (!accessToken.value) {
      return null
    }

    try {
      const userData = await getMeApi()
      user.value = mapUser(userData)
      return user.value
    } catch (err) {
      clearSession()
      throw err
    }
  }

  async function setAllergen(ingredientId: number | null): Promise<void> {
    const ids = ingredientId !== null ? [ingredientId] : []
    const updated = await updateAllergensApi(ids)
    if (user.value) {
      user.value = mapUser(updated)
    }
  }

  async function setPantry(ids: number[]): Promise<void> {
    const updated = await updatePantryApi(ids)
    if (user.value) user.value = mapUser(updated)
  }

  async function init(): Promise<void> {
    if (isInitialized.value) return

    if (accessToken.value) {
      try {
        await fetchProfile()
      } catch {
        // Handled in fetchProfile
      }
    } else {
      // Try refresh token from cookie if available
      try {
        const res = await refreshApi()
        setSession(res.access_token, res.user)
      } catch {
        // User not logged in, guest mode
      }
    }

    isInitialized.value = true
  }

  if (typeof window !== 'undefined') {
    window.addEventListener('auth:expired', () => {
      clearSession()
    })
  }

  return {
    user,
    accessToken,
    isLoading,
    isInitialized,
    isAuthenticated,
    primaryAllergenId,
    login,
    register,
    logout,
    fetchProfile,
    setAllergen,
    setPantry,
    init,
    clearSession
  }
})
