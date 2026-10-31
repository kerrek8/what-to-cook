import { describe, it, expect, beforeEach, vi } from 'vitest'
import 'fake-indexeddb/auto'
import { setActivePinia, createPinia } from 'pinia'
import { useInventoryStore } from './inventory'
import { db } from '@/db'
import * as inventoryApi from '@/api/inventory'

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

vi.mock('@/api/inventory', () => ({
  getInventoryApi: vi.fn(),
  createInventoryApi: vi.fn(),
  updateInventoryApi: vi.fn(),
  deleteInventoryApi: vi.fn()
}))

describe('useInventoryStore', () => {
  beforeEach(async () => {
    setActivePinia(createPinia())
    await db.inventory.clear()
    vi.clearAllMocks()
  })

  it('initially has empty items', () => {
    const store = useInventoryStore()
    expect(store.items).toHaveLength(0)
    expect(store.filteredItems).toHaveLength(0)
  })

  it('adds an item to local storage and updates state', async () => {
    const store = useInventoryStore()

    await store.addItem({
      name: 'Томаты',
      category: 'Овощи',
      amount: 4,
      unit: 'шт',
      expirationDate: '2026-11-10'
    })

    expect(store.items).toHaveLength(1)
    expect(store.items[0].name).toBe('Томаты')
    expect(store.categories).toContain('Овощи')
  })

  it('filters items by search query and category', async () => {
    const store = useInventoryStore()

    await store.addItem({
      name: 'Сыр Чеддер',
      category: 'Молочные продукты',
      amount: 200,
      unit: 'г'
    })

    await store.addItem({
      name: 'Курица',
      category: 'Мясо',
      amount: 1,
      unit: 'кг'
    })

    expect(store.items).toHaveLength(2)

    store.searchQuery = 'сыр'
    expect(store.filteredItems).toHaveLength(1)
    expect(store.filteredItems[0].name).toBe('Сыр Чеддер')

    store.searchQuery = ''
    store.activeCategory = 'Мясо'
    expect(store.filteredItems).toHaveLength(1)
    expect(store.filteredItems[0].name).toBe('Курица')
  })

  it('deletes an item from local storage and store state', async () => {
    const store = useInventoryStore()

    const id = await store.addItem({
      name: 'Бананы',
      category: 'Фрукты',
      amount: 3,
      unit: 'шт'
    })

    expect(store.items).toHaveLength(1)

    await store.deleteItem(id)
    expect(store.items).toHaveLength(0)
  })
})
