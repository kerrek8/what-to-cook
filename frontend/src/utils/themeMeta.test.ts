import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('PWA & HTML Theme Meta Configuration', () => {
  const htmlPath = path.resolve(__dirname, '../../index.html')
  const viteConfigPath = path.resolve(__dirname, '../../vite.config.ts')
  const html = fs.readFileSync(htmlPath, 'utf-8')
  const viteConfig = fs.readFileSync(viteConfigPath, 'utf-8')

  it('does not contain legacy green in index.html meta theme-color', () => {
    expect(html).not.toContain('#2e7d32')
    expect(html).not.toContain('#2E7D32')
  })

  it('does not contain legacy green in vite.config.ts PWA manifest', () => {
    expect(viteConfig).not.toContain('#2e7d32')
    expect(viteConfig).not.toContain('#2E7D32')
  })

  it('uses modern light/neutral theme-color for OS system bars', () => {
    expect(html).toContain('name="theme-color"')
    expect(viteConfig).toContain('theme_color:')
  })
})
