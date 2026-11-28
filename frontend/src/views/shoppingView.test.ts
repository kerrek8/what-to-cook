import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('ShoppingView Transfer-to-Fridge Regression Checks', () => {
  const filePath = path.resolve(__dirname, 'ShoppingView.vue')
  const content = fs.readFileSync(filePath, 'utf-8')

  it('opens prefilled AddProductSheet queue in onQuickTransferAll instead of bypassing the form', () => {
    const quickTransferMatch = content.match(/function onQuickTransferAll\(\)[\s\S]*?\n\}/)
    expect(quickTransferMatch).not.toBeNull()
    const body = quickTransferMatch![0]

    expect(body).toContain('transferQueue.value')
    expect(body).toContain('showTransferSheet.value = true')
    expect(body).not.toContain('transferBoughtToInventory')
  })

  it('binds AddProductSheet with initialItem and keepOpenOnSubmit for multi-item transfer', () => {
    expect(content).toContain(':initial-item="transferInitialData"')
    expect(content).toContain(':keep-open-on-submit="currentTransferIndex < transferQueue.length - 1"')
    expect(content).toContain('@add="onConfirmTransferItem"')
  })
})
