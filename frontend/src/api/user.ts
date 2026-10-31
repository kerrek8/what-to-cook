import { apiClient } from './client'
import type { UserBackendResponse } from '@/types/api'

export async function getMeApi(): Promise<UserBackendResponse> {
  const { data } = await apiClient.get<UserBackendResponse>('/api/v1/users/me')
  return data
}

export async function updateAllergensApi(
  excludedIngredientIds: number[]
): Promise<UserBackendResponse> {
  const { data } = await apiClient.put<UserBackendResponse>('/api/v1/users/me/allergens', {
    excluded_ingredient_ids: excludedIngredientIds
  })
  return data
}
