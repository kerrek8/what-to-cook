import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('RecipesView Native Tailwind Implementation', () => {
  const filePath = path.resolve(__dirname, 'RecipesView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('does not contain any van- components', () => {
    expect(content).not.toContain('van-search')
    expect(content).not.toContain('van-skeleton')
    expect(content).not.toContain('van-empty')
    expect(content).not.toContain('van-button')
    expect(content).not.toContain('van-loading')
    expect(content).not.toContain("from 'vant'")
  })

  it('contains search bar and filter tabs', () => {
    expect(content).toContain('recipeStore.searchQuery')
    expect(content).toContain('recipeStore.activeTab')
  })
})
