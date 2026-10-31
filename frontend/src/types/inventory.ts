export type QuantityLevel = 'few' | 'medium' | 'much'

export interface InventoryItemResponse {
  id: string
  ingredient_id?: number | null
  name: string
  name_en?: string | null
  category: string
  amount?: number | null
  unit?: string | null
  approximate_quantity?: QuantityLevel | null
  in_stock: boolean
  expiration_date?: string | null
  created_at: string
  updated_at: string
}

export interface InventoryListResponse {
  items: InventoryItemResponse[]
  total: number
}

export interface CreateInventoryItemPayload {
  ingredient_id?: number | null
  custom_name?: string | null
  amount?: number | null
  unit?: string | null
  approximate_quantity?: QuantityLevel | null
  in_stock?: boolean
  expiration_date?: string | null
}

export interface UpdateInventoryItemPayload {
  ingredient_id?: number | null
  custom_name?: string | null
  amount?: number | null
  unit?: string | null
  approximate_quantity?: QuantityLevel | null
  in_stock?: boolean
  expiration_date?: string | null
}
