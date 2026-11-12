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
  getFavoriteRecipesApi,
  matchRecipesApi,
  addFavoriteApi,
  removeFavoriteApi,
  addMissingIngredientsToShoppingListApi
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
  const totalCount = ref(0)
  const page = ref(1)
  const pageSize = 15
  const currentRecipe = ref<RecipeResponse | null>(null)

  const isLoading = ref(false)
  const isAllRecipesLoading = ref(false)
  const isFavoritesLoading = ref(false)
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

  function filterMatched(
    recipe: RecipeResponse,
    usedIngredients?: RecipeIngredientResponse[]
  ): boolean {
    if (searchQuery.value.trim()) {
      const q = searchQuery.value.trim().toLowerCase()
      const text = `${recipe.title} ${recipe.description ?? ''}`.toLowerCase()
      const hasIngredient = (usedIngredients || recipe.ingredients || []).some(
        (ing) => ing.name.toLowerCase().includes(q)
      )
      if (!text.includes(q) && !hasIngredient) return false
    }

    if (difficultyFilter.value !== 'all' && recipe.difficulty !== difficultyFilter.value) {
      return false
    }

    if (timeFilter.value === 15 && recipe.cooking_time_minutes > 15) return false
    if (timeFilter.value === 30 && recipe.cooking_time_minutes > 30) return false
    if (timeFilter.value === 60 && recipe.cooking_time_minutes > 60) return false
    if (timeFilter.value === 61 && recipe.cooking_time_minutes <= 60) return false

    if (saveExpiringOnly.value && activeTab.value === 'match') {
      const ings = usedIngredients || recipe.ingredients
      const saved = getSavingIngredients(ings)
      if (saved.length === 0) return false
    }

    return true
  }

  const filteredMatchedRecipes = computed(() => {
    return matchedRecipes.value.filter((item) => filterMatched(item.recipe, item.used_ingredients))
  })

  const filteredAllRecipes = computed(() => {
    return allRecipes.value.filter((r) => filterMatched(r))
  })
  const visibleAllRecipes = computed(() => filteredAllRecipes.value)
  const totalPages = computed(() => Math.max(1, Math.ceil(totalCount.value / pageSize)))
  const hasMoreRecipes = computed(() => allRecipes.value.length < totalCount.value)

  const favoriteRecipes = computed(() => {
    return favoriteCatalog.value.filter((r) => r.is_favorite && filterMatched(r))
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

  async function loadAllRecipes(targetPage = 1, append = false) {
    const shouldAppend = append && targetPage > 1
    if (!shouldAppend) {
      isLoading.value = true
    }
    isAllRecipesLoading.value = true
    try {
      const resp = await getRecipesApi({
        limit: pageSize,
        offset: (targetPage - 1) * pageSize,
        q: searchQuery.value.trim() || undefined,
        difficulty: difficultyFilter.value !== 'all' ? difficultyFilter.value : undefined,
        max_time: timeFilter.value > 0 ? timeFilter.value : undefined
      })
      if (shouldAppend) {
        allRecipes.value = [...allRecipes.value, ...resp.items]
      } else {
        allRecipes.value = resp.items
      }
      totalCount.value = resp.total
      page.value = targetPage
    } catch {
      if (!shouldAppend) {
        allRecipes.value = []
      }
    } finally {
      isLoading.value = false
      isAllRecipesLoading.value = false
    }
  }

  async function loadFavorites(force = false) {
    if (!authStore.isAuthenticated) {
      favoriteCatalog.value = []
      return
    }
    if (favoriteCatalog.value.length > 0 && !force && !navigator.onLine) return
    isFavoritesLoading.value = true
    try {
      if (!navigator.onLine) throw new Error('offline')
      const favorites = await getFavoriteRecipesApi()
      favoriteCatalog.value = favorites
      await cacheFavoriteRecipes(favorites)
    } catch {
      favoriteCatalog.value = await getCachedFavoriteRecipes()
    } finally {
      isFavoritesLoading.value = false
    }
  }

  async function setPage(value: number) {
    const next = Math.min(totalPages.value, Math.max(1, value))
    if (next !== page.value) {
      await loadAllRecipes(next)
    }
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
      await cacheFavoriteRecipe(recipe)
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
        let fullRecipe = currentRecipe.value?.id === recipeId ? currentRecipe.value : null
        if (!fullRecipe) {
          try {
            fullRecipe = (await getRecipeByIdApi(recipeId)) ?? target
          } catch {
            fullRecipe = target
          }
        }
        if (fullRecipe) {
          fullRecipe.is_favorite = true
          updateFavoriteState(recipeId, true)
          await cacheFavoriteRecipe(fullRecipe).catch(() => {})
        }
      } else {
        await removeFavoriteApi(recipeId)
        await removeCachedFavoriteRecipe(recipeId).catch(() => {})
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

  return {
    matchedRecipes,
    allRecipes,
    favoriteCatalog,
    totalCount,
    page,
    pageSize,
    totalPages,
    currentRecipe,
    isLoading,
    isAllRecipesLoading,
    hasMoreRecipes,
    isFavoritesLoading,
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
    addMissingToShopping
  }
})
