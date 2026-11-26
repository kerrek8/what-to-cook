import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('Button Contrast & Plain Styling (Tailwind Design System)', () => {
  const tailwindPath = path.resolve(__dirname, '../../tailwind.config.js')
  const tailwindConfig = fs.readFileSync(tailwindPath, 'utf-8')

  it('defines high-contrast emerald colors in tailwind config', () => {
    expect(tailwindConfig).toContain("950: '#165337'")
    expect(tailwindConfig).toContain("700: '#2E6950'")
    expect(tailwindConfig).toContain("500: '#10B981'")
  })

  it('defines kitchen dark theme colors for high contrast reading', () => {
    expect(tailwindConfig).toContain("dark: '#061811'")
    expect(tailwindConfig).toContain("surface: '#0A261B'")
  })
})
