import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('ProductCard Tailwind Implementation', () => {
  const filePath = path.resolve(__dirname, 'ProductCard.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('does not contain any van- components', () => {
    expect(content).not.toContain('van-swipe-cell')
    expect(content).not.toContain('van-button')
    expect(content).not.toContain('van-icon')
    expect(content).not.toContain("from 'vant'")
  })

  it('emits edit and delete events and handles card tap', () => {
    expect(content).toContain("emit('edit', props.item)")
    expect(content).toContain("emit('delete', props.item.id)")
    expect(content).toContain('onCardClick')
  })

  it('renders freshness badge and category icon', () => {
    expect(content).toContain('getCategoryIcon')
    expect(content).toContain('freshness')
  })
})
