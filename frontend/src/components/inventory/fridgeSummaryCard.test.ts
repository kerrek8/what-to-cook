import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('FridgeSummaryCard Compact Light Layout', () => {
  const filePath = path.resolve(__dirname, 'FridgeSummaryCard.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('uses compact light 3-column strip instead of heavy dark emerald hero banner', () => {
    expect(content).toContain('bg-white')
    expect(content).toContain('grid-cols-3')
    expect(content).not.toContain('bg-gradient-to-br from-emerald-950')
  })

  it('supports filtering by all, expiring, and expired', () => {
    expect(content).toContain("onSelect('all')")
    expect(content).toContain("onSelect('expiring')")
    expect(content).toContain("onSelect('expired')")
  })
})
