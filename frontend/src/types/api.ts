export interface User {
  id: string
  email: string
  name: string
  excludedIngredientIds: number[]
  createdAt: string
}

export interface UserBackendResponse {
  id: string
  email: string
  name: string
  excluded_ingredient_ids: number[]
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
  nameEn?: string
  category: string
  defaultUnit: string
  isPantryEssential: boolean
}

export interface IngredientListResponse {
  items: Array<{
    id: number
    name: string
    name_en?: string
    category: string
    default_unit: string
    is_pantry_essential: boolean
  }>
  total: number
}
