import { apiClient } from './client'
import type {
  ShoppingItemResponse,
  ShoppingListResponse,
  CreateShoppingItemRequest,
  UpdateShoppingItemRequest,
  TransferToInventoryResponse
} from '@/types/shopping'

export async function getShoppingListApi(): Promise<ShoppingItemResponse[]> {
  const { data } = await apiClient.get<ShoppingListResponse>('/api/v1/shopping-list')
  return data.items
}

export async function createShoppingItemApi(
  payload: CreateShoppingItemRequest
): Promise<ShoppingItemResponse> {
  const { data } = await apiClient.post<ShoppingItemResponse>('/api/v1/shopping-list', payload)
  return data
}

export async function updateShoppingItemApi(
  id: string,
  payload: UpdateShoppingItemRequest
): Promise<ShoppingItemResponse> {
  const { data } = await apiClient.patch<ShoppingItemResponse>(`/api/v1/shopping-list/${id}`, payload)
  return data
}

export async function deleteShoppingItemApi(id: string): Promise<void> {
  await apiClient.delete(`/api/v1/shopping-list/${id}`)
}

export async function transferToInventoryApi(): Promise<TransferToInventoryResponse> {
  const { data } = await apiClient.post<TransferToInventoryResponse>(
    '/api/v1/shopping-list/transfer-to-inventory'
  )
  return data
}
