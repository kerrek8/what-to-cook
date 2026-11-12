import { describe, it, expect, beforeEach, vi } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import 'fake-indexeddb/auto'
import { useShoppingStore } from './shopping'
import { db } from '@/db'
import * as shoppingApi from '@/api/shopping'

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

vi.mock('@/api/shopping', () => ({
  getShoppingListApi: vi.fn(),
  createShoppingItemApi: vi.fn(),
  updateShoppingItemApi: vi.fn(),
  deleteShoppingItemApi: vi.fn(),
  transferToInventoryApi: vi.fn()
}))

describe('useShoppingStore', () => {
  beforeEach(async () => {
    setActivePinia(createPinia())
    await db.shoppingList.clear()
    await db.inventory.clear()
    localStorage.clear()
    vi.clearAllMocks()
  })

  it('initially has empty items and counters', () => {
    const store = useShoppingStore()
    expect(store.items).toHaveLength(0)
    expect(store.boughtCount).toBe(0)
    expect(store.pendingCount).toBe(0)
    expect(store.totalCount).toBe(0)
  })

  it('adds item to local database and store state', async () => {
    const store = useShoppingStore()

    const id = await store.addItem({
      name: 'Молоко',
      category: 'Молочные продукты',
      amount: 1,
      unit: 'л'
    })

    expect(id).toBeDefined()
    expect(store.items).toHaveLength(1)
    expect(store.items[0].name).toBe('Молоко')
    expect(store.items[0].isBought).toBe(false)
    expect(store.categories).toContain('Молочные продукты')
  })

  it('toggles item bought state', async () => {
    const store = useShoppingStore()

    const id = await store.addItem({
      name: 'Хлеб',
      category: 'Бакалея',
      amount: 1,
      unit: 'шт'
    })

    expect(store.items[0].isBought).toBe(false)
    expect(store.boughtCount).toBe(0)

    await store.toggleBought(id)
    expect(store.items[0].isBought).toBe(true)
    expect(store.boughtCount).toBe(1)

    await store.toggleBought(id)
    expect(store.items[0].isBought).toBe(false)
    expect(store.boughtCount).toBe(0)
  })

  it('groups items by department and puts pending items before bought', async () => {
    const store = useShoppingStore()

    const id1 = await store.addItem({
      name: 'Огурцы',
      category: 'Овощи',
      amount: 500,
      unit: 'г'
    })

    await store.addItem({
      name: 'Помидоры',
      category: 'Овощи',
      amount: 400,
      unit: 'г'
    })

    await store.addItem({
      name: 'Сыр',
      category: 'Молочные продукты',
      amount: 200,
      unit: 'г'
    })

    await store.toggleBought(id1)

    expect(store.groupedCategories).toHaveLength(2)

    const vegGroup = store.groupedCategories.find((g) => g.category === 'Овощи')
    expect(vegGroup).toBeDefined()
    expect(vegGroup!.items).toHaveLength(2)
    expect(vegGroup!.pendingCount).toBe(1)
    expect(vegGroup!.boughtCount).toBe(1)
    expect(vegGroup!.items[0].name).toBe('Помидоры')
    expect(vegGroup!.items[1].name).toBe('Огурцы')
  })

  it('deletes item from local database and store', async () => {
    const store = useShoppingStore()

    const id = await store.addItem({
      name: 'Бананы',
      category: 'Фрукты'
    })

    expect(store.items).toHaveLength(1)

    await store.deleteItem(id)
    expect(store.items).toHaveLength(0)
  })

  it('transfers bought items to inventory and clears them from shopping list', async () => {
    const store = useShoppingStore()

    const id1 = await store.addItem({
      name: 'Сметана',
      category: 'Молочные продукты'
    })
    await store.addItem({
      name: 'Чай',
      category: 'Бакалея'
    })

    await store.toggleBought(id1)
    expect(store.boughtCount).toBe(1)

    const transferred = await store.transferBoughtToInventory()
    expect(transferred).toBe(1)
    expect(store.items).toHaveLength(1)
    expect(store.items[0].name).toBe('Чай')
  })

  it('updates pending count when items are reloaded after external recipe addition', async () => {
    const store = useShoppingStore()
    expect(store.items).toHaveLength(0)
    expect(store.pendingCount).toBe(0)

    vi.mocked(shoppingApi.getShoppingListApi).mockResolvedValueOnce([
      {
        id: 'mock-id-1',
        name: 'Мука',
        amount: 500,
        unit: 'г',
        is_bought: false,
        category: 'Бакалея',
        created_at: '2026-11-12T00:00:00Z',
        updated_at: '2026-11-12T00:00:00Z'
      }
    ])

    await store.loadItems(true)
    expect(store.items).toHaveLength(1)
    expect(store.items.filter((i) => !i.isBought)).toHaveLength(1)
    expect(store.pendingCount).toBe(1)
    expect(store.items[0].name).toBe('Мука')
  })
})
