import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('Button Contrast & Plain Styling (Tailwind Design System)', () => {
  const tailwindPath = path.resolve(__dirname, '../../tailwind.config.js')
  const tailwindConfig = fs.readFileSync(tailwindPath, 'utf-8')

  it('defines high-contrast emerald colors in tailwind config', () => {
    expect(tailwindConfig).toContain("950: '#064E3B'")
    expect(tailwindConfig).toContain("700: '#047857'")
    expect(tailwindConfig).toContain("500: '#10B981'")
  })

  it('defines kitchen dark theme colors for high contrast reading', () => {
    expect(tailwindConfig).toContain("dark: '#0F172A'")
    expect(tailwindConfig).toContain("surface: '#022C22'")
  })
})
