import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('RecipesView Segmented Control Template Structure', () => {
  const filePath = path.resolve(__dirname, 'RecipesView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('contains concise tab title for match tab ("Подбор") to prevent mobile text collision', () => {
    expect(content).toContain('>Подбор</span>')
    expect(content).not.toContain('>Что приготовить</span>')
  })

  it('contains tab-title class for ellipsis and no-wrap control', () => {
    expect(content).toContain('class="tab-title"')
  })

  it('defines flex: 1 1 0% and min-width 0 in CSS for mobile viewports', () => {
    expect(content).toContain('flex: 1 1 0%')
    expect(content).toContain('min-width: 0')
  })
})
