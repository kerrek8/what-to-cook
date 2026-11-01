import { ref } from 'vue'

const cacheKey = 'whatcook:translations:en-ru-v1'
const translations = new Map<string, string>()
export const translationRevision = ref(0)

const knownTranslations: Record<string, string> = {
  produce: 'Овощи и фрукты', vegetables: 'Овощи', vegetable: 'Овощи', fruit: 'Фрукты', fruits: 'Фрукты',
  dairy: 'Молочные продукты', 'dairy products': 'Молочные продукты', meat: 'Мясо', poultry: 'Птица',
  'meat and poultry': 'Мясо и птица', seafood: 'Морепродукты', fish: 'Рыба', eggs: 'Яйца',
  grains: 'Крупы', 'grains and cereals': 'Крупы и злаки', bakery: 'Выпечка', bread: 'Хлеб и выпечка',
  spices: 'Специи', 'herbs and spices': 'Травы и специи', nuts: 'Орехи', legumes: 'Бобовые',
  beverages: 'Напитки', frozen: 'Замороженные продукты', 'frozen food': 'Замороженные продукты',
  condiments: 'Соусы и приправы', pantry: 'Бакалея', 'pantry staples': 'Бакалея', other: 'Другое',
  dessert: 'Десерт', side: 'Гарнир', starter: 'Закуска', vegan: 'Веганское',
  vegetarian: 'Вегетарианское', breakfast: 'Завтрак', goat: 'Козлятина', miscellaneous: 'Разное',
  chicken: 'Курица', beef: 'Говядина', pork: 'Свинина', lamb: 'Баранина', turkey: 'Индейка',
  milk: 'Молоко', cheese: 'Сыр', butter: 'Сливочное масло', potato: 'Картофель',
  potatoes: 'Картофель', tomato: 'Помидор', tomatoes: 'Помидоры', onion: 'Лук', garlic: 'Чеснок',
  carrot: 'Морковь', carrots: 'Морковь', rice: 'Рис', flour: 'Мука', sugar: 'Сахар', salt: 'Соль',
  'olive oil': 'Оливковое масло', 'vegetable oil': 'Растительное масло', 'black pepper': 'Чёрный перец',
  'chocolate cake': 'Шоколадный торт', 'apple pie': 'Яблочный пирог'
}

function readCache() {
  try {
    const stored = localStorage.getItem(cacheKey)
    if (stored) {
      for (const [source, translated] of Object.entries(JSON.parse(stored) as Record<string, string>)) {
        translations.set(source, translated)
      }
    }
  } catch {
    // Translation cache is optional.
  }
}

readCache()

function saveCache() {
  try {
    localStorage.setItem(cacheKey, JSON.stringify(Object.fromEntries(translations)))
  } catch {
    // Translation cache is optional.
  }
}

export function displayText(text: string | null | undefined): string {
  if (!text) return ''
  void translationRevision.value
  return knownTranslations[text.trim().toLowerCase()] ?? translations.get(text) ?? text
}

export function displayIngredientName(name: string, nameEn?: string | null): string {
  const source = /[А-Яа-яЁё]/.test(name) ? name : (nameEn || name)
  return displayText(source)
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

function translatorUrl(): string {
  return (import.meta.env.VITE_LIBRETRANSLATE_URL || '').replace(/\/+$/, '')
}

export async function translateTexts(texts: string[], source = 'en', target = 'ru'): Promise<string[]> {
  const unique = [...new Set(texts.map(text => text.trim()).filter(Boolean))]
  const missing = unique.filter(text => !/[А-Яа-яЁё]/.test(text) && !translations.has(text) && !knownTranslations[text.toLowerCase()])
  const baseUrl = translatorUrl()

  if (baseUrl && missing.length > 0 && navigator.onLine) {
    for (let offset = 0; offset < missing.length; offset += 40) {
      const batch = missing.slice(offset, offset + 40)
      try {
        const response = await fetch(`${baseUrl}/translate`, {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ q: batch, source, target, format: 'text' })
        })
        if (!response.ok) continue
        const result = await response.json() as { translatedText?: string | string[] }
        const translated = Array.isArray(result.translatedText) ? result.translatedText : [result.translatedText]
        batch.forEach((text, index) => {
          const value = translated[index]?.trim()
          if (value) translations.set(text, value)
        })
        translationRevision.value++
        saveCache()
      } catch {
        // Keep source text visible when LibreTranslate is unavailable.
      }
    }
  }

  return texts.map(text => {
    const trimmed = text.trim()
    return knownTranslations[trimmed.toLowerCase()] ?? translations.get(trimmed) ?? text
  })
}

export async function translateSearchQuery(query: string): Promise<string> {
  const normalized = query.trim()
  if (!normalized || !/[А-Яа-яЁё]/.test(normalized)) return normalized
  const baseUrl = translatorUrl()
  if (baseUrl && navigator.onLine) {
    try {
      const response = await fetch(`${baseUrl}/translate`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ q: normalized, source: 'ru', target: 'en', format: 'text' })
      })
      if (response.ok) {
        const result = await response.json() as { translatedText?: string }
        if (result.translatedText?.trim()) return result.translatedText.trim()
      }
    } catch {
      // Use known query translations when LibreTranslate is unavailable.
    }
  }
  return knownTranslations[normalized.toLowerCase()] ?? normalized
}
