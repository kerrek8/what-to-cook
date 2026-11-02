import { ref } from 'vue'
import { translateApi } from '@/api/translation'

const cacheKey = 'whatcook:translations:en-ru-v2'
const translations = new Map<string, string>()
export const translationRevision = ref(0)
export type TranslationServiceStatus = 'checking' | 'connected' | 'unavailable'
export const translationServiceStatus = ref<TranslationServiceStatus>('checking')

readCache()

export function displayText(text: string | null | undefined): string {
  if (!text) return ''
  void translationRevision.value
  return translations.get(cacheId(text, 'en', 'ru')) ?? text
}

export function displayIngredientName(name: string, _nameEn?: string | null): string {
  return /[А-Яа-яЁё]/.test(name) ? name : displayText(name)
}

export function displayUnit(unit: string | null | undefined): string {
  if (!unit) return ''
  const units: Record<string, string> = {
    g: 'г', gram: 'г', grams: 'г', kg: 'кг', kilogram: 'кг', ml: 'мл', milliliter: 'мл',
    l: 'л', liter: 'л', litre: 'л', pcs: 'шт', pc: 'шт', piece: 'шт', pieces: 'шт',
    cup: 'стакан', cups: 'стакана', tbsp: 'ст. л.', teaspoon: 'ч. л.', tsp: 'ч. л.'
  }
  return units[unit.trim().toLowerCase()] ?? unit
}

export async function translateTexts(texts: string[], source: 'en' | 'ru' = 'en', target: 'en' | 'ru' = 'ru'): Promise<string[]> {
  const unique = [...new Set(texts.map(text => text.trim()).filter(text => text.length > 0 && text.length <= 2000))]
  if (unique.length === 0) return texts
  const missing = unique.filter(text => !isAlreadyTarget(text, target) && !translations.has(cacheId(text, source, target)))

  translationServiceStatus.value = 'checking'
  for (let offset = 0; offset < missing.length; offset += 10) {
    const batch = missing.slice(offset, offset + 10)
    try {
      const result = await translateApi({ texts: batch, source, target })
      batch.forEach((text, index) => {
        const translated = result[index]?.trim()
        if (translated) translations.set(cacheId(text, source, target), translated)
      })
      saveCache()
      translationRevision.value++
      translationServiceStatus.value = 'connected'
    } catch {
      translationServiceStatus.value = 'unavailable'
      break
    }
  }

  if (missing.length === 0) translationServiceStatus.value = 'connected'
  return texts.map(text => translations.get(cacheId(text, source, target)) ?? text)
}

export async function translateSearchQuery(query: string): Promise<string> {
  if (!/[А-Яа-яЁё]/.test(query)) return query.trim()
  const result = await translateTexts([query], 'ru', 'en')
  return result[0] ?? query
}

export async function checkTranslationService(): Promise<TranslationServiceStatus> {
  await translateTexts([`WhatCook ${Date.now()}`], 'en', 'ru')
  return translationServiceStatus.value
}

function cacheId(text: string, source: string, target: string): string {
  return `${source}:${target}:${text}`
}

function isAlreadyTarget(text: string, target: 'en' | 'ru'): boolean {
  return target === 'ru' ? !/[A-Za-z]{2,}/.test(text) : !/[А-Яа-яЁё]/.test(text)
}

function readCache() {
  try {
    const stored = localStorage.getItem(cacheKey)
    if (stored) {
      for (const [key, value] of Object.entries(JSON.parse(stored) as Record<string, string>)) {
        translations.set(key, value)
      }
    }
  } catch {
    // Local translation cache is optional.
  }
}

function saveCache() {
  try {
    localStorage.setItem(cacheKey, JSON.stringify(Object.fromEntries(translations)))
  } catch {
    // Local translation cache is optional.
  }
}
