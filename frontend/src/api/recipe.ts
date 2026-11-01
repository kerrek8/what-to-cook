import { apiClient } from './client'
import type {
  RecipeListResponse,
  RecipeResponse,
  RecipeMatchResponse,
  RecipeQuery,
  AddFromRecipeResponse
} from '@/types/recipe'

export async function getRecipesApi(query?: RecipeQuery): Promise<RecipeListResponse> {
  const { data } = await apiClient.get<RecipeListResponse>('/api/v1/recipes', { params: query })
  return data
}

export async function getRecipeByIdApi(id: number): Promise<RecipeResponse> {
  const { data } = await apiClient.get<RecipeResponse>(`/api/v1/recipes/${id}`)
  return data
}

export async function matchRecipesApi(): Promise<RecipeMatchResponse> {
  const { data } = await apiClient.get<RecipeMatchResponse>('/api/v1/recipes/match')
  return data
}

export async function addFavoriteApi(id: number): Promise<void> {
  await apiClient.post(`/api/v1/recipes/${id}/favorite`)
}

export async function removeFavoriteApi(id: number): Promise<void> {
  await apiClient.delete(`/api/v1/recipes/${id}/favorite`)
}

export async function addMissingIngredientsToShoppingListApi(
  recipeId: number
): Promise<AddFromRecipeResponse> {
  const { data } = await apiClient.post<AddFromRecipeResponse>(
    `/api/v1/shopping-list/from-recipe/${recipeId}`
  )
  return data
}
