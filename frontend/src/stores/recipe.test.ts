import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import 'fake-indexeddb/auto'
import { useRecipeStore } from './recipe'
import { useInventoryStore } from './inventory'
import * as recipeApi from '@/api/recipe'
import type { RecipeResponse, RecipeMatchItem } from '@/types/recipe'

const storage: Record<string, string> = {}
const mockLocalStorage = {
  getItem: (key: string) => storage[key] ?? null,
  setItem: (key: string, val: string) => {
    storage[key] = String(val)
  },
  removeItem: (key: string) => {
    delete storage[key]
  },
  clear: () => {
    Object.keys(storage).forEach((k) => delete storage[k])
  },
  key: (i: number) => Object.keys(storage)[i] ?? null,
  length: 0
}

Object.defineProperty(globalThis, 'localStorage', {
  value: mockLocalStorage,
  writable: true
})

vi.mock('@/api/recipe', () => ({
  getRecipesApi: vi.fn(),
  getRecipeByIdApi: vi.fn(),
  getFavoriteRecipesApi: vi.fn(),
  matchRecipesApi: vi.fn(),
  addFavoriteApi: vi.fn(),
  removeFavoriteApi: vi.fn(),
  addMissingIngredientsToShoppingListApi: vi.fn()
}))

const mockRecipe: RecipeResponse = {
  id: 1,
  title: 'Омлет с сыром и томатами',
  description: 'Вкусный быстрый завтрак',
  instructions: ['Взбейте яйца', 'Нарежьте томаты', 'Жарьте 10 минут на сковороде'],
  cooking_time_minutes: 15,
  difficulty: 'легко',
  is_favorite: false,
  ingredients: [
    {
      ingredient_id: 10,
      name: 'Томаты',
      category: 'Овощи',
      amount: 2,
      unit: 'шт',
      criticality: 'основной',
      is_pantry_essential: false
    },
    {
      ingredient_id: 11,
      name: 'Яйца',
      category: 'Молочные продукты',
      amount: 3,
      unit: 'шт',
      criticality: 'основной',
      is_pantry_essential: false
    }
  ],
  created_at: '2026-11-01T10:00:00Z',
  updated_at: '2026-11-01T10:00:00Z'
}

const mockMatchItem: RecipeMatchItem = {
  recipe: mockRecipe,
  match_percentage: 100,
  total_ingredients: 2,
  available_count: 2,
  used_ingredients: mockRecipe.ingredients || [],
  missing_ingredients: [],
  can_cook_now: true
}

describe('useRecipeStore', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
    localStorage.clear()
    vi.clearAllMocks()
  })

  it('initially has empty recipes and default filters', () => {
    const store = useRecipeStore()
    expect(store.matchedRecipes).toHaveLength(0)
    expect(store.allRecipes).toHaveLength(0)
    expect(store.currentRecipe).toBeNull()
    expect(store.activeTab).toBe('match')
    expect(store.timeFilter).toBe(0)
    expect(store.difficultyFilter).toBe('all')
  })

  it('loads all recipes successfully', async () => {
    vi.mocked(recipeApi.getRecipesApi).mockResolvedValueOnce({
      items: [mockRecipe],
      total: 1
    })

    const store = useRecipeStore()
    await store.loadAllRecipes(1)

    expect(store.allRecipes).toHaveLength(1)
    expect(store.allRecipes[0].title).toBe('Омлет с сыром и томатами')
  })

  it('filters recipes by search query, time, and difficulty', () => {
    const store = useRecipeStore()
    store.allRecipes = [
      mockRecipe,
      {
        ...mockRecipe,
        id: 2,
        title: 'Борщ домашний',
        cooking_time_minutes: 65,
        difficulty: 'сложно'
      }
    ]

    expect(store.filteredAllRecipes).toHaveLength(2)

    store.searchQuery = 'борщ'
    expect(store.filteredAllRecipes).toHaveLength(1)
    expect(store.filteredAllRecipes[0].id).toBe(2)

    store.searchQuery = ''
    store.timeFilter = 15
    expect(store.filteredAllRecipes).toHaveLength(1)
    expect(store.filteredAllRecipes[0].id).toBe(1)

    store.timeFilter = 0
    store.difficultyFilter = 'сложно'
    expect(store.filteredAllRecipes).toHaveLength(1)
    expect(store.filteredAllRecipes[0].id).toBe(2)
  })

  it('toggles favorite state and calls favorite API', async () => {
    vi.mocked(recipeApi.addFavoriteApi).mockResolvedValueOnce()
    vi.mocked(recipeApi.removeFavoriteApi).mockResolvedValueOnce()

    const store = useRecipeStore()
    store.allRecipes = [{ ...mockRecipe, is_favorite: false }]

    await store.toggleFavorite(1)
    expect(store.allRecipes[0].is_favorite).toBe(true)
    expect(recipeApi.addFavoriteApi).toHaveBeenCalledWith(1)

    await store.toggleFavorite(1)
    expect(store.allRecipes[0].is_favorite).toBe(false)
    expect(recipeApi.removeFavoriteApi).toHaveBeenCalledWith(1)
  })

  it('identifies recipes that save expiring products from inventory', async () => {
    const store = useRecipeStore()
    const inventoryStore = useInventoryStore()

    const today = new Date().toISOString().split('T')[0]
    inventoryStore.items = [
      {
        id: 1,
        serverId: null,
        ingredientId: 10,
        name: 'Томаты',
        category: 'Овощи',
        amount: 2,
        unit: 'шт',
        approximateQuantity: null,
        expirationDate: today,
        isPantryEssential: false,
        synced: 1,
        updatedAt: '2026-11-01'
      }
    ]

    const saving = store.getSavingIngredients(mockRecipe.ingredients)
    expect(saving).toHaveLength(1)
    expect(saving[0].name).toBe('Томаты')
  })
})
