import { apiClient } from './client'
import type { Ingredient, IngredientListResponse } from '@/types/api'

export async function getIngredientsApi(params?: {
  q?: string
  category?: string
}): Promise<Ingredient[]> {
  const { data } = await apiClient.get<IngredientListResponse>('/api/v1/ingredients', {
    params
  })

  return data.items.map((item) => ({
    id: item.id,
    name: item.name,
    nameEn: item.name_en,
    category: item.category,
    defaultUnit: item.default_unit,
    isPantryEssential: item.is_pantry_essential
  }))
}
