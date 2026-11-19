import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('Empty States Styling Parity', () => {
  const views = ['FridgeView.vue', 'ShoppingView.vue', 'RecipesView.vue']

  views.forEach((view) => {
    it(`${view} contains standard squircle container for empty icon`, () => {
      const content = fs.readFileSync(path.resolve(__dirname, view), 'utf-8')
      expect(content).toContain('w-16 h-16 rounded-3xl bg-emerald-50 text-emerald-800 border border-emerald-100 shadow-xs')
    })
  })
})
