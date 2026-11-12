export interface User {
  id: string
  email: string
  name: string
  avatarUrl?: string | null
  avatar_url?: string | null
  excludedIngredientIds: number[]
  pantryIngredientIds: number[]
  createdAt: string
}

export interface UserBackendResponse {
  id: string
  email: string
  name: string
  avatar_url?: string | null
  excluded_ingredient_ids: number[]
  pantry_ingredient_ids?: number[]
  created_at: string
}

export interface AuthBackendResponse {
  access_token: string
  user: UserBackendResponse
}

export interface RegisterPayload {
  email: string
  password: string
  name: string
}

export interface LoginPayload {
  email: string
  password: string
}

export interface Ingredient {
  id: number
  name: string
  category: string
  defaultUnit: string
  isPantryEssential: boolean
}

export interface IngredientListResponse {
  items: Array<{
    id: number
    name: string
    category: string
    default_unit: string
    is_pantry_essential: boolean
  }>
  total: number
}
