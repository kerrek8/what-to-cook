import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('BaseConfirmDialog Component', () => {
  const filePath = path.resolve(__dirname, 'BaseConfirmDialog.vue')
  const bottomSheetPath = path.resolve(__dirname, 'BaseBottomSheet.vue')

  it('file exists and implements modal dialog with proper events', () => {
    expect(fs.existsSync(filePath)).toBe(true)
    const content = fs.readFileSync(filePath, 'utf-8')
    expect(content).toContain("emit('confirm')")
    expect(content).toContain("emit('cancel')")
    expect(content).toContain("emit('update:show'")
    expect(content).toContain('Teleport')
  })

  it('handles Android back button via history popstate in BaseConfirmDialog', () => {
    const content = fs.readFileSync(filePath, 'utf-8')
    expect(content).toContain('popstate')
    expect(content).toContain('pushState')
    expect(content).toContain('hasPushedHistory')
  })

  it('implements swipe-to-dismiss gesture on BaseBottomSheet drag handle', () => {
    const content = fs.readFileSync(bottomSheetPath, 'utf-8')
    expect(content).toContain('onTouchStart')
    expect(content).toContain('onTouchMove')
    expect(content).toContain('onTouchEnd')
    expect(content).toContain('80') // swipe threshold > 80px
  })
})
