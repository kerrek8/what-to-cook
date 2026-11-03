export type RecipeDifficulty = 'easy' | 'medium' | 'hard'
export type IngredientCriticality = 'critical' | 'essential' | 'optional'

export interface RecipeIngredientResponse {
  ingredient_id: number
  name: string
  name_en?: string | null
  category: string
  amount?: number | null
  unit?: string | null
  display_text?: string | null
  criticality: IngredientCriticality | string
  is_pantry_essential: boolean
  localized_name?: string
  localized_display_text?: string | null
}

export interface RecipeResponse {
  id: number
  external_id?: string | null
  title: string
  description?: string | null
  instructions: string[]
  cooking_time_minutes: number
  difficulty: RecipeDifficulty | string
  image_url?: string | null
  is_favorite: boolean
  ingredients?: RecipeIngredientResponse[]
  created_at: string
  updated_at: string
  localized_title?: string
  localized_description?: string | null
  localized_instructions?: string[]
}

export interface RecipeListResponse {
  items: RecipeResponse[]
  total: number
  pending_translations?: number
}

export interface RecipeQuery {
  q?: string
  difficulty?: string
  max_time?: number
  limit?: number
  offset?: number
}

export interface RecipeMatchItem {
  recipe: RecipeResponse
  match_percentage: number
  total_ingredients: number
  available_count: number
  used_ingredients: RecipeIngredientResponse[]
  missing_ingredients: RecipeIngredientResponse[]
  can_cook_now: boolean
}

export interface RecipeMatchResponse {
  items: RecipeMatchItem[]
  total: number
}

export interface AddFromRecipeResponse {
  recipe_id: number
  added_count: number
  items: Array<{
    id: string
    ingredient_id?: number | null
    name: string
    category: string
    amount?: number | null
    unit?: string | null
    is_bought: boolean
  }>
}
