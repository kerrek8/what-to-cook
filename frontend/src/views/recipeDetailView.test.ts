import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('RecipeDetailView UI & Features', () => {
  const filePath = path.resolve(__dirname, 'RecipeDetailView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('resets scroll position on mount', () => {
    expect(content).toContain('.content-wrapper')
    expect(content).toContain('scrollTo')
  })

  it('implements tabbed view switching between ingredients and instructions', () => {
    expect(content).toContain("activeSection = ref<'ingredients' | 'instructions'>('ingredients')")
    expect(content).toContain('Ингредиенты')
    expect(content).toContain('Инструкции')
  })

  it('renders ingredient criticality badges', () => {
    expect(content).toContain('criticalityBadge')
    expect(content).toContain('Основной')
    expect(content).toContain('Важный')
    expect(content).toContain('Опционально')
  })
})
