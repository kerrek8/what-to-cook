import Dexie, { type EntityTable } from 'dexie'
import type { CachedFavoriteRecipe, LocalInventoryItem, LocalShoppingItem } from './types'
import type { RecipeResponse } from '@/types/recipe'
import type { InventoryItemResponse } from '@/types/inventory'
import type { ShoppingItemResponse } from '@/types/shopping'

export class WhatCookDatabase extends Dexie {
  inventory!: EntityTable<LocalInventoryItem, 'id'>
  shoppingList!: EntityTable<LocalShoppingItem, 'id'>
  favoriteRecipes!: EntityTable<CachedFavoriteRecipe, 'id'>

  constructor() {
    super('WhatCookDB')
    this.version(1).stores({
      inventory: '++id, serverId, ingredientId, name, category, expirationDate, synced',
      shoppingList: '++id, serverId, ingredientId, name, category, isBought, synced'
    })
    this.version(2).stores({
      inventory: '++id, serverId, ingredientId, name, category, expirationDate, synced',
      shoppingList: '++id, serverId, ingredientId, name, category, isBought, synced',
      favoriteRecipes: 'id, updatedAt'
    })
  }
}

export const db = new WhatCookDatabase()

export async function getCachedFavoriteRecipes(): Promise<RecipeResponse[]> {
  const entries = await db.favoriteRecipes.toArray()
  return entries.map(entry => entry.recipe)
}

export async function cacheFavoriteRecipes(recipes: RecipeResponse[]): Promise<void> {
  const now = new Date().toISOString()
  const plain = JSON.parse(JSON.stringify(recipes))
  await db.transaction("rw", db.favoriteRecipes, async () => {
    await db.favoriteRecipes.clear()
    await db.favoriteRecipes.bulkPut(plain.map((recipe: RecipeResponse) => ({ id: recipe.id, recipe, updatedAt: now })))
  })
}

export async function cacheFavoriteRecipe(recipe: RecipeResponse): Promise<void> {
  const plain = JSON.parse(JSON.stringify(recipe))
  await db.favoriteRecipes.put({ id: recipe.id, recipe: plain, updatedAt: new Date().toISOString() })
}

export async function removeCachedFavoriteRecipe(id: number): Promise<void> {
  await db.favoriteRecipes.delete(id)
}

export async function getCachedFavoriteRecipe(id: number): Promise<RecipeResponse | undefined> {
  return (await db.favoriteRecipes.get(id))?.recipe
}

export async function getLocalInventory(): Promise<LocalInventoryItem[]> {
  return await db.inventory.toArray()
}

export async function addLocalInventoryItem(
  item: Omit<LocalInventoryItem, 'id'>
): Promise<number> {
  return (await db.inventory.add({
    ...item,
    updatedAt: new Date().toISOString()
  })) as number
}

export async function updateLocalInventoryItem(
  id: number,
  changes: Partial<LocalInventoryItem>
): Promise<number> {
  return await db.inventory.update(id, {
    ...changes,
    updatedAt: new Date().toISOString()
  })
}

export async function deleteLocalInventoryItem(id: number): Promise<void> {
  await db.inventory.delete(id)
}

export async function syncServerInventory(
  serverItems: InventoryItemResponse[]
): Promise<LocalInventoryItem[]> {
  const localItems = await db.inventory.toArray()
  const serverMap = new Map(serverItems.map((s) => [s.id, s]))

  for (const local of localItems) {
    if (local.serverId) {
      if (serverMap.has(local.serverId)) {
        const s = serverMap.get(local.serverId)!
        await db.inventory.update(local.id!, {
          name: s.name,
          category: s.category,
          amount: s.amount,
          unit: s.unit,
          approximateQuantity: s.approximate_quantity,
          expirationDate: s.expiration_date,
          synced: 1,
          updatedAt: s.updated_at
        })
        serverMap.delete(local.serverId)
      } else if (local.synced === 1) {
        await db.inventory.delete(local.id!)
      }
    }
  }

  for (const s of serverMap.values()) {
    await db.inventory.add({
      serverId: s.id,
      ingredientId: s.ingredient_id,
      name: s.name,
      category: s.category,
      amount: s.amount,
      unit: s.unit,
      approximateQuantity: s.approximate_quantity,
      expirationDate: s.expiration_date,
      isPantryEssential: false,
      synced: 1,
      updatedAt: s.updated_at
    })
  }

  return await db.inventory.toArray()
}

export async function getLocalShoppingList(): Promise<LocalShoppingItem[]> {
  return await db.shoppingList.toArray()
}

export async function addLocalShoppingItem(
  item: Omit<LocalShoppingItem, 'id'>
): Promise<number> {
  return (await db.shoppingList.add({
    ...item,
    updatedAt: new Date().toISOString()
  })) as number
}

export async function updateLocalShoppingItem(
  id: number,
  changes: Partial<LocalShoppingItem>
): Promise<number> {
  return await db.shoppingList.update(id, {
    ...changes,
    updatedAt: new Date().toISOString()
  })
}

export async function toggleLocalShoppingItem(id: number): Promise<boolean> {
  const item = await db.shoppingList.get(id)
  if (!item) return false
  const isBought = !item.isBought
  await db.shoppingList.update(id, {
    isBought,
    synced: 0,
    updatedAt: new Date().toISOString()
  })
  return isBought
}

export async function deleteLocalShoppingItem(id: number): Promise<void> {
  await db.shoppingList.delete(id)
}

export async function clearBoughtShoppingItems(): Promise<void> {
  await db.shoppingList.filter((item) => item.isBought).delete()
}

export async function syncServerShoppingList(
  serverItems: ShoppingItemResponse[]
): Promise<LocalShoppingItem[]> {
  const localItems = await db.shoppingList.toArray()
  const serverMap = new Map(serverItems.map((s) => [s.id, s]))

  for (const local of localItems) {
    if (local.serverId) {
      if (serverMap.has(local.serverId)) {
        const s = serverMap.get(local.serverId)!
        await db.shoppingList.update(local.id!, {
          name: s.name,
          category: s.category,
          amount: s.amount,
          unit: s.unit,
          isBought: s.is_bought,
          synced: 1,
          updatedAt: s.updated_at
        })
        serverMap.delete(local.serverId)
      } else if (local.synced === 1) {
        await db.shoppingList.delete(local.id!)
      }
    }
  }

  for (const s of serverMap.values()) {
    await db.shoppingList.add({
      serverId: s.id,
      ingredientId: s.ingredient_id,
      name: s.name,
      category: s.category,
      amount: s.amount,
      unit: s.unit,
      isBought: s.is_bought,
      synced: 1,
      updatedAt: s.updated_at
    })
  }

  return await db.shoppingList.toArray()
}
