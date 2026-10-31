import { apiClient } from './client'
import type { AuthBackendResponse, LoginPayload, RegisterPayload } from '@/types/api'

export async function registerApi(payload: RegisterPayload): Promise<AuthBackendResponse> {
  const { data } = await apiClient.post<AuthBackendResponse>('/api/v1/auth/register', payload)
  return data
}

export async function loginApi(payload: LoginPayload): Promise<AuthBackendResponse> {
  const { data } = await apiClient.post<AuthBackendResponse>('/api/v1/auth/login', payload)
  return data
}

export async function refreshApi(): Promise<AuthBackendResponse> {
  const { data } = await apiClient.post<AuthBackendResponse>('/api/v1/auth/refresh')
  return data
}

export async function logoutApi(): Promise<void> {
  await apiClient.post('/api/v1/auth/logout')
}
