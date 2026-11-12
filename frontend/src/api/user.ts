import { apiClient } from './client'
import type { UserBackendResponse } from '@/types/api'

export async function getMeApi(): Promise<UserBackendResponse> {
  const { data } = await apiClient.get<UserBackendResponse>('/api/v1/users/me')
  return data
}

export async function uploadAvatarApi(file: File): Promise<{ avatar_url: string }> {
  const formData = new FormData()
  formData.append('avatar', file)
  const { data } = await apiClient.post<{ avatar_url: string }>('/api/v1/users/me/avatar', formData, {
    headers: {
      'Content-Type': 'multipart/form-data'
    }
  })
  return data
}

export async function deleteAvatarApi(): Promise<void> {
  await apiClient.delete('/api/v1/users/me/avatar')
}

export async function updateAllergensApi(
  excludedIngredientIds: number[]
): Promise<UserBackendResponse> {
  const { data } = await apiClient.put<UserBackendResponse>('/api/v1/users/me/allergens', {
    excluded_ingredient_ids: excludedIngredientIds
  })
  return data
}

export async function updatePantryApi(pantryIngredientIds: number[]): Promise<UserBackendResponse> {
  const { data } = await apiClient.put<UserBackendResponse>('/api/v1/users/me/pantry', {
    pantry_ingredient_ids: pantryIngredientIds
  })
  return data
}

export async function getPantryApi(): Promise<number[]> {
  const { data } = await apiClient.get<{ pantry_ingredient_ids: number[] }>('/api/v1/users/me/pantry')
  return data.pantry_ingredient_ids
}
