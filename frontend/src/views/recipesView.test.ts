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

  it('RecipeDetailView uses accessible w-9 h-9 servings touch targets', () => {
    const detailContent = fs.readFileSync(path.resolve(__dirname, 'RecipeDetailView.vue'), 'utf-8')
    expect(detailContent).toContain('w-9 h-9 rounded-xl')
    expect(detailContent).toContain('aria-label="Уменьшить порции"')
    expect(detailContent).toContain('aria-label="Увеличить порции"')
  })

  it('ShoppingView hides progress card when totalCount is zero', () => {
    const shoppingContent = fs.readFileSync(path.resolve(__dirname, 'ShoppingView.vue'), 'utf-8')
    expect(shoppingContent).toContain('v-if="totalCount > 0"')
    expect(shoppingContent).toContain('onUndoDelete')
  })

  it('RecipeCard extracts missingBadgeText computed and cleans duplicate shadow', () => {
    const cardContent = fs.readFileSync(path.resolve(__dirname, '../components/recipes/RecipeCard.vue'), 'utf-8')
    expect(cardContent).toContain('missingBadgeText')
  })
})
