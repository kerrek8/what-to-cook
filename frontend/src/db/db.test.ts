import { describe, it, expect, beforeEach } from 'vitest'
import 'fake-indexeddb/auto'
import {
  db,
  getLocalInventory,
  addLocalInventoryItem,
  updateLocalInventoryItem,
  deleteLocalInventoryItem,
  getLocalShoppingList,
  addLocalShoppingItem,
  toggleLocalShoppingItem,
  clearBoughtShoppingItems
} from './index'

describe('IndexedDB Dexie store', () => {
  beforeEach(async () => {
    await db.inventory.clear()
    await db.shoppingList.clear()
  })

  it('adds and retrieves inventory items', async () => {
    const id = await addLocalInventoryItem({
      name: 'Молоко',
      category: 'Молочные продукты',
      amount: 1,
      unit: 'л',
      approximateQuantity: null,
      expirationDate: '2026-11-05',
      isPantryEssential: false,
      synced: 0,
      updatedAt: new Date().toISOString()
    })

    expect(id).toBeDefined()
    const items = await getLocalInventory()
    expect(items).toHaveLength(1)
    expect(items[0].name).toBe('Молоко')
    expect(items[0].expirationDate).toBe('2026-11-05')
  })

  it('updates and deletes inventory items', async () => {
    const id = await addLocalInventoryItem({
      name: 'Яйца',
      category: 'Яйца',
      amount: 10,
      unit: 'шт',
      approximateQuantity: 'much',
      isPantryEssential: false,
      synced: 1,
      updatedAt: new Date().toISOString()
    })

    await updateLocalInventoryItem(id, { amount: 6 })
    let items = await getLocalInventory()
    expect(items[0].amount).toBe(6)

    await deleteLocalInventoryItem(id)
    items = await getLocalInventory()
    expect(items).toHaveLength(0)
  })

  it('manages shopping list and toggles bought status', async () => {
    const id = await addLocalShoppingItem({
      name: 'Сыр',
      category: 'Молочные продукты',
      amount: 200,
      unit: 'г',
      isBought: false,
      synced: 0,
      updatedAt: new Date().toISOString()
    })

    let items = await getLocalShoppingList()
    expect(items[0].isBought).toBe(false)

    const isBought = await toggleLocalShoppingItem(id)
    expect(isBought).toBe(true)

    items = await getLocalShoppingList()
    expect(items[0].isBought).toBe(true)

    await clearBoughtShoppingItems()
    items = await getLocalShoppingList()
    expect(items).toHaveLength(0)
  })
})
