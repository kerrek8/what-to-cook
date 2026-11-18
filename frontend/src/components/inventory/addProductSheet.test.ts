import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('AddProductSheet Shelf-Life Presets & Native Implementation', () => {
  const filePath = path.resolve(__dirname, 'AddProductSheet.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('does not contain any van- components', () => {
    expect(content).not.toContain('van-action-sheet')
    expect(content).not.toContain('van-calendar')
    expect(content).not.toContain('van-field')
    expect(content).not.toContain('van-popup')
    expect(content).not.toContain("from 'vant'")
  })

  it('uses BaseBottomSheet component', () => {
    expect(content).toContain('BaseBottomSheet')
  })

  it('implements quick shelf-life preset chips', () => {
    expect(content).toContain('+3 дня')
    expect(content).toContain('1 неделя')
    expect(content).toContain('2 недели')
    expect(content).toContain('В заморозку')
    expect(content).toContain('setPresetDays')
  })

  it('supports native date input for custom expiration date', () => {
    expect(content).toContain('type="date"')
  })
})
