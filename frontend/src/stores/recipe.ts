import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type {
  RecipeResponse,
  RecipeMatchItem,
  RecipeIngredientResponse
} from '@/types/recipe'
import {
  getRecipesApi,
  getRecipeByIdApi,
  matchRecipesApi,
  addFavoriteApi,
  removeFavoriteApi,
  addMissingIngredientsToShoppingListApi
} from '@/api/recipe'
import { useAuthStore } from './auth'
import { useInventoryStore } from './inventory'
import { getFreshnessInfo } from '@/utils/freshness'

export type CookingTimeFilter = 0 | 15 | 30 | 60 | 61

export const useRecipeStore = defineStore('recipe', () => {
  const matchedRecipes = ref<RecipeMatchItem[]>([])
  const allRecipes = ref<RecipeResponse[]>([])
  const currentRecipe = ref<RecipeResponse | null>(null)

  const isLoading = ref(false)
  const isMatching = ref(false)
  const isDetailLoading = ref(false)

  const activeTab = ref<'match' | 'all' | 'favorites'>('match')
  const searchQuery = ref('')
  const timeFilter = ref<CookingTimeFilter>(0)
  const difficultyFilter = ref<string>('all')
  const saveExpiringOnly = ref(false)

  const authStore = useAuthStore()
  const inventoryStore = useInventoryStore()

  const expiringItems = computed(() => {
    return inventoryStore.items.filter((item) => {
      const { status } = getFreshnessInfo(item.expirationDate)
      return status === 'warning' || status === 'danger'
    })
  })

  function getSavingIngredients(
    ingredients?: RecipeIngredientResponse[]
  ): Array<{ id: number; name: string }> {
    if (!ingredients || ingredients.length === 0 || expiringItems.value.length === 0) {
      return []
    }

    const saved: Array<{ id: number; name: string }> = []
    for (const exp of expiringItems.value) {
      const expName = exp.name.trim().toLowerCase()
      const found = ingredients.some(
        (ing) =>
          (exp.ingredientId != null && ing.ingredient_id === exp.ingredientId) ||
          ing.name.toLowerCase().includes(expName) ||
          expName.includes(ing.name.toLowerCase())
      )
      if (found) {
        saved.push({ id: exp.ingredientId ?? exp.id ?? 0, name: exp.name })
      }
    }
    return saved
  }

  function filterRecipe(
    recipe: RecipeResponse,
    usedIngredients?: RecipeIngredientResponse[]
  ): boolean {
    if (searchQuery.value.trim()) {
      const q = searchQuery.value.trim().toLowerCase()
      const titleMatch = recipe.title.toLowerCase().includes(q)
      const descMatch = recipe.description?.toLowerCase().includes(q) || false
      if (!titleMatch && !descMatch) return false
    }

    if (difficultyFilter.value !== 'all' && recipe.difficulty !== difficultyFilter.value) {
      return false
    }

    if (timeFilter.value === 15 && recipe.cooking_time_minutes > 15) return false
    if (timeFilter.value === 30 && recipe.cooking_time_minutes > 30) return false
    if (timeFilter.value === 60 && recipe.cooking_time_minutes > 60) return false
    if (timeFilter.value === 61 && recipe.cooking_time_minutes <= 60) return false

    if (saveExpiringOnly.value) {
      const ings = usedIngredients || recipe.ingredients
      const saved = getSavingIngredients(ings)
      if (saved.length === 0) return false
    }

    return true
  }

  const filteredMatchedRecipes = computed(() => {
    return matchedRecipes.value.filter((item) => filterRecipe(item.recipe, item.used_ingredients))
  })

  const filteredAllRecipes = computed(() => {
    return allRecipes.value.filter((r) => filterRecipe(r))
  })

  const favoriteRecipes = computed(() => {
    return allRecipes.value.filter((r) => r.is_favorite && filterRecipe(r))
  })

  async function loadMatchedRecipes(force = false) {
    if (!authStore.isAuthenticated) {
      matchedRecipes.value = []
      return
    }

    if (matchedRecipes.value.length > 0 && !force) return

    isMatching.value = true
    try {
      const resp = await matchRecipesApi()
      matchedRecipes.value = resp.items
    } catch {
      matchedRecipes.value = []
    } finally {
      isMatching.value = false
    }
  }

  async function loadAllRecipes(force = false) {
    if (allRecipes.value.length > 0 && !force) return

    isLoading.value = true
    try {
      const resp = await getRecipesApi()
      allRecipes.value = resp.items
    } catch {
      allRecipes.value = []
    } finally {
      isLoading.value = false
    }
  }

  async function loadRecipeById(id: number): Promise<RecipeResponse | null> {
    isDetailLoading.value = true
    try {
      const recipe = await getRecipeByIdApi(id)
      currentRecipe.value = recipe
      return recipe
    } catch {
      currentRecipe.value = null
      return null
    } finally {
      isDetailLoading.value = false
    }
  }

  async function toggleFavorite(recipeId: number) {
    let target = allRecipes.value.find((r) => r.id === recipeId)
    if (!target) {
      const match = matchedRecipes.value.find((m) => m.recipe.id === recipeId)
      if (match) target = match.recipe
    }
    if (!target && currentRecipe.value?.id === recipeId) {
      target = currentRecipe.value
    }

    if (!target) return

    const previousState = target.is_favorite
    const newState = !previousState

    updateFavoriteState(recipeId, newState)

    try {
      if (newState) {
        await addFavoriteApi(recipeId)
      } else {
        await removeFavoriteApi(recipeId)
      }
    } catch {
      updateFavoriteState(recipeId, previousState)
    }
  }

  function updateFavoriteState(recipeId: number, isFav: boolean) {
    for (const r of allRecipes.value) {
      if (r.id === recipeId) r.is_favorite = isFav
    }
    for (const m of matchedRecipes.value) {
      if (m.recipe.id === recipeId) m.recipe.is_favorite = isFav
    }
    if (currentRecipe.value && currentRecipe.value.id === recipeId) {
      currentRecipe.value.is_favorite = isFav
    }
  }

  async function addMissingToShopping(recipeId: number) {
    return await addMissingIngredientsToShoppingListApi(recipeId)
  }

  return {
    matchedRecipes,
    allRecipes,
    currentRecipe,
    isLoading,
    isMatching,
    isDetailLoading,
    activeTab,
    searchQuery,
    timeFilter,
    difficultyFilter,
    saveExpiringOnly,
    expiringItems,
    filteredMatchedRecipes,
    filteredAllRecipes,
    favoriteRecipes,
    getSavingIngredients,
    loadMatchedRecipes,
    loadAllRecipes,
    loadRecipeById,
    toggleFavorite,
    addMissingToShopping
  }
})
