import { apiClient } from './client'
import type {
  InventoryItemResponse,
  InventoryListResponse,
  CreateInventoryItemPayload,
  UpdateInventoryItemPayload
} from '@/types/inventory'

export async function getInventoryApi(): Promise<InventoryItemResponse[]> {
  const { data } = await apiClient.get<InventoryListResponse>('/api/v1/inventory')
  return data.items
}

export async function createInventoryApi(
  payload: CreateInventoryItemPayload
): Promise<InventoryItemResponse> {
  const { data } = await apiClient.post<InventoryItemResponse>('/api/v1/inventory', payload)
  return data
}

export async function updateInventoryApi(
  id: string,
  payload: UpdateInventoryItemPayload
): Promise<InventoryItemResponse> {
  const { data } = await apiClient.put<InventoryItemResponse>(`/api/v1/inventory/${id}`, payload)
  return data
}

export async function deleteInventoryApi(id: string): Promise<void> {
  await apiClient.delete(`/api/v1/inventory/${id}`)
}
