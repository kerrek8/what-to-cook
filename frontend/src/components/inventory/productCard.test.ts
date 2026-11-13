import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('ProductCard Tap-to-Open and Swipe Hint Affordance', () => {
  const filePath = path.resolve(__dirname, 'ProductCard.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('declares swipeCellRef and connects it to van-swipe-cell', () => {
    expect(content).toContain('ref="swipeCellRef"')
    expect(content).toContain('const swipeCellRef = ref')
  })

  it('implements tap-to-open click handler with haptics and stops click bubbling to prevent instant close', () => {
    expect(content).toContain('@click.stop="onCardClick"')
    expect(content).toContain("swipeCellRef.value?.open('right')")
    expect(content).toContain('triggerHaptic')
    expect(content).toContain(':right-width="154"')
  })

  it('renders visual swipe affordance chevron in template', () => {
    expect(content).toContain('class="swipe-hint"')
    expect(content).toContain('name="arrow-left"')
  })

  it('styles swipe-hint with transition and open rotation', () => {
    expect(content).toContain('.swipe-hint')
    expect(content).toContain('rotate(180deg)')
  })
})
