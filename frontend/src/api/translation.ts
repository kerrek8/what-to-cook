import { apiClient } from './client'

export interface TranslateRequest {
  texts: string[]
  source: 'en' | 'ru'
  target: 'en' | 'ru'
}

export async function translateApi(request: TranslateRequest): Promise<string[]> {
  const { data } = await apiClient.post<{ translations: string[] }>('/api/v1/translations', request, {
    timeout: 12000
  })
  return data.translations
}
