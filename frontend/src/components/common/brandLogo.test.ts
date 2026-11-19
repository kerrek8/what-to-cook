import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('BrandLogo Component', () => {
  const filePath = path.resolve(__dirname, 'BrandLogo.vue')

  it('file exists and contains vector SVG/ChefHat icon without emoji', () => {
    expect(fs.existsSync(filePath)).toBe(true)
    const content = fs.readFileSync(filePath, 'utf-8')
    expect(content).not.toContain('🍳')
    expect(content).toContain('ChefHat')
    expect(content).toContain('WhatCook')
  })
})
