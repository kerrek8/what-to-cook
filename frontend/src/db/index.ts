import Dexie, { type EntityTable } from 'dexie'
import type { LocalInventoryItem, LocalShoppingItem } from './types'

export class WhatCookDatabase extends Dexie {
  inventory!: EntityTable<LocalInventoryItem, 'id'>
  shoppingList!: EntityTable<LocalShoppingItem, 'id'>

  constructor() {
    super('WhatCookDB')
    this.version(1).stores({
      inventory: '++id, serverId, ingredientId, name, category, expirationDate, synced',
      shoppingList: '++id, serverId, ingredientId, name, category, isBought, synced'
    })
  }
}

export const db = new WhatCookDatabase()

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
