import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('LoginView Figma Redesign', () => {
  const filePath = path.resolve(__dirname, 'LoginView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('implements emerald hero header banner without raw emoji', () => {
    expect(content).not.toContain('🍳')
    expect(content).toContain('bg-gradient-to-br from-emerald-950')
    expect(content).toContain('rounded-t-3xl')
  })

  it('preserves authentication handlers and inputs', () => {
    expect(content).toContain('authStore.login')
    expect(content).toContain('type="email"')
    expect(content).toContain('password')
  })

  it('provides a password visibility toggle button with aria-label', () => {
    expect(content).toContain('showPassword')
    expect(content).toContain('Показать пароль')
  })

  it('provides inline field validation errors', () => {
    expect(content).toContain('errors.email')
    expect(content).toContain('errors.password')
  })
})
