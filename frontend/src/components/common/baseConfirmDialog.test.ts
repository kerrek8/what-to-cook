import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('BaseConfirmDialog Component', () => {
  const filePath = path.resolve(__dirname, 'BaseConfirmDialog.vue')

  it('file exists and implements modal dialog with proper events', () => {
    expect(fs.existsSync(filePath)).toBe(true)
    const content = fs.readFileSync(filePath, 'utf-8')
    expect(content).toContain("emit('confirm')")
    expect(content).toContain("emit('cancel')")
    expect(content).toContain("emit('update:show'")
    expect(content).toContain('Teleport')
    expect(content).toContain('popstate')
    expect(content).toContain('confirmDialogOpen')
  })
})
