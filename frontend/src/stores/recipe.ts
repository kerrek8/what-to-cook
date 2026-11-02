import { defineStore } from 'pinia'
import { ref, computed, watch } from 'vue'
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
  addMissingIngredientsToShoppingListApi,
  syncRecipesApi
} from '@/api/recipe'
import { useAuthStore } from './auth'
import { useInventoryStore } from './inventory'
import { getFreshnessInfo } from '@/utils/freshness'
import {
  cacheFavoriteRecipe,
  cacheFavoriteRecipes,
  getCachedFavoriteRecipe,
  getCachedFavoriteRecipes,
  removeCachedFavoriteRecipe
} from '@/db'

export type CookingTimeFilter = 0 | 15 | 30 | 60 | 61

export const useRecipeStore = defineStore('recipe', () => {
  const matchedRecipes = ref<RecipeMatchItem[]>([])
  const allRecipes = ref<RecipeResponse[]>([])
  const favoriteCatalog = ref<RecipeResponse[]>([])
  const page = ref(1)
  const pageSize = 20
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
      const text = `${recipe.title} ${recipe.description ?? ''} ${recipe.localized_title ?? ''} ${recipe.localized_description ?? ''}`.toLowerCase()
      if (!text.includes(q)) return false
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
  const visibleAllRecipes = computed(() => filteredAllRecipes.value.slice((page.value - 1) * pageSize, page.value * pageSize))
  const totalPages = computed(() => Math.max(1, Math.ceil(filteredAllRecipes.value.length / pageSize)))
  watch([searchQuery, timeFilter, difficultyFilter, saveExpiringOnly], () => {
    page.value = 1
  })

  const favoriteRecipes = computed(() => {
    return favoriteCatalog.value.filter((r) => r.is_favorite && filterRecipe(r))
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
      const first = await getRecipesApi({ limit: 100, offset: 0 })
      const remaining = await Promise.all(Array.from({ length: Math.ceil(first.total / 100) - 1 }, (_, i) => getRecipesApi({ limit: 100, offset: (i + 1) * 100 })))
      allRecipes.value = [...first.items, ...remaining.flatMap(response => response.items)]
    } catch {
      allRecipes.value = []
    } finally {
      isLoading.value = false
    }
  }

  async function loadFavorites(force = false) {
    if (!authStore.isAuthenticated) { favoriteCatalog.value = []; return }
    if (favoriteCatalog.value.length && !force && !navigator.onLine) return
    isLoading.value = true
    try {
      if (!navigator.onLine) throw new Error('offline')
      const first = await getRecipesApi({ limit: 100, offset: 0 })
      const pages = Math.ceil(first.total / 100)
      const rest = await Promise.all(Array.from({ length: Math.max(0, pages - 1) }, (_, i) => getRecipesApi({ limit: 100, offset: (i + 1) * 100 })))
      const favorites = [...first.items, ...rest.flatMap(result => result.items)].filter(recipe => recipe.is_favorite)
      const detailed: RecipeResponse[] = []
      for (let i = 0; i < favorites.length; i += 4) {
        const chunk = favorites.slice(i, i + 4)
        const details = await Promise.all(chunk.map(recipe => getRecipeByIdApi(recipe.id).catch(() => recipe)))
        detailed.push(...details.map(recipe => ({ ...recipe, is_favorite: true })))
      }
      favoriteCatalog.value = detailed
      await cacheFavoriteRecipes(detailed)
    } catch {
      favoriteCatalog.value = await getCachedFavoriteRecipes()
    } finally { isLoading.value = false }
  }

  async function setPage(value: number) {
    const next = Math.min(totalPages.value, Math.max(1, value))
    page.value = next
  }

  async function loadRecipeById(id: number): Promise<RecipeResponse | null> {
    isDetailLoading.value = true
    try {
      if (!navigator.onLine) {
        const cached = await getCachedFavoriteRecipe(id)
        currentRecipe.value = cached ?? null
        return currentRecipe.value
      }
      const recipe = await getRecipeByIdApi(id)
      currentRecipe.value = recipe
      if (currentRecipe.value.is_favorite) await cacheFavoriteRecipe(recipe)
      return currentRecipe.value
    } catch {
      const cached = await getCachedFavoriteRecipe(id)
      currentRecipe.value = cached ?? null
      return currentRecipe.value
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
        const fullRecipe = currentRecipe.value?.id === recipeId
          ? currentRecipe.value
          : await getRecipeByIdApi(recipeId).catch(() => target)
        if (fullRecipe) {
          fullRecipe.is_favorite = true
          updateFavoriteState(recipeId, true)
          await cacheFavoriteRecipe(fullRecipe)
        }
      } else {
        await removeFavoriteApi(recipeId)
        await removeCachedFavoriteRecipe(recipeId)
      }
    } catch {
      updateFavoriteState(recipeId, previousState)
    }
  }

  function updateFavoriteState(recipeId: number, isFav: boolean) {
    for (const r of allRecipes.value) {
      if (r.id === recipeId) r.is_favorite = isFav
    }
    for (const r of favoriteCatalog.value) if (r.id === recipeId) r.is_favorite = isFav
    const source = [...allRecipes.value, ...matchedRecipes.value.map(m => m.recipe), ...(currentRecipe.value ? [currentRecipe.value] : [])].find(r => r.id === recipeId)
    if (isFav && source && !favoriteCatalog.value.some(r => r.id === recipeId)) favoriteCatalog.value.unshift(source)
    if (!isFav) favoriteCatalog.value = favoriteCatalog.value.filter(r => r.id !== recipeId)
    if (!isFav) void removeCachedFavoriteRecipe(recipeId)
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

  async function searchExternalRecipes(query: string): Promise<number> {
    const count = await syncRecipesApi(query.trim())
    if (count > 0) {
      page.value = 1
      await loadAllRecipes(true)
      if (authStore.isAuthenticated) await loadMatchedRecipes(true)
    }
    return count
  }

  return {
    matchedRecipes,
    allRecipes,
    favoriteCatalog,
    page,
    pageSize,
    totalPages,
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
    visibleAllRecipes,
    favoriteRecipes,
    getSavingIngredients,
    loadMatchedRecipes,
    loadAllRecipes,
    loadFavorites,
    setPage,
    loadRecipeById,
    toggleFavorite,
    addMissingToShopping,
    searchExternalRecipes
  }
})
