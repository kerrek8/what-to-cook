import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('ProfileView Figma Modal Integration', () => {
  const filePath = path.resolve(__dirname, 'ProfileView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('uses BaseConfirmDialog instead of window.confirm', () => {
    expect(content).toContain('BaseConfirmDialog')
    expect(content).not.toContain("confirm('Вы уверены")
  })
})
