export type QuantityLevel = 'few' | 'medium' | 'much'

export interface LocalInventoryItem {
  id?: number
  serverId?: string | null
  ingredientId?: string | null
  name: string
  category: string
  amount?: number | null
  unit?: string | null
  approximateQuantity?: QuantityLevel | null
  expirationDate?: string | null
  isPantryEssential: boolean
  synced: number
  updatedAt: string
}

export interface LocalShoppingItem {
  id?: number
  serverId?: string | null
  ingredientId?: string | null
  name: string
  category: string
  amount?: number | null
  unit?: string | null
  approximateQuantity?: QuantityLevel | null
  isBought: boolean
  synced: number
  updatedAt: string
}
