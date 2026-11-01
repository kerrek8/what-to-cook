export interface ShoppingItemResponse {
  id: string
  ingredient_id?: number | null
  name: string
  name_en?: string | null
  category: string
  amount?: number | null
  unit?: string | null
  is_bought: boolean
  created_at: string
  updated_at: string
}

export interface ShoppingListResponse {
  items: ShoppingItemResponse[]
  total: number
}

export interface CreateShoppingItemRequest {
  ingredient_id?: number | null
  custom_name?: string | null
  amount?: number | null
  unit?: string | null
}

export interface UpdateShoppingItemRequest {
  ingredient_id?: number | null
  custom_name?: string | null
  amount?: number | null
  unit?: string | null
  is_bought?: boolean
}

export interface TransferToInventoryResponse {
  transferred_count: number
}
