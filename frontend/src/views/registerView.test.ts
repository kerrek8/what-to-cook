import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('RegisterView Figma Redesign', () => {
  const filePath = path.resolve(__dirname, 'RegisterView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('implements emerald hero header banner without raw emoji', () => {
    expect(content).not.toContain('🍳')
    expect(content).toContain('bg-gradient-to-br from-emerald-950')
    expect(content).toContain('rounded-t-3xl')
  })

  it('preserves registration inputs and registration store logic', () => {
    expect(content).toContain('authStore.register')
    expect(content).toContain('name')
    expect(content).toContain('email')
    expect(content).toContain('password')
    expect(content).toContain('confirmPassword')
  })
})
