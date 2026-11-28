import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('RecipeCard Match Count Display', () => {
  const filePath = path.resolve(__dirname, 'RecipeCard.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('displays ingredient match ratio as available_count/total_ingredients instead of percentage', () => {
    expect(content).toContain('matchItem.available_count')
    expect(content).toContain('matchItem.total_ingredients')
    expect(content).not.toContain('matchItem.match_percentage }}%')
    expect(content).not.toContain('matchItem.match_percentage}%')
  })

  it('safely handles null missing_ingredients without throwing TypeError on .length', () => {
    expect(content).toContain('missing_ingredients?.length')
    expect(content).not.toContain('props.matchItem.missing_ingredients.length')
  })
})
