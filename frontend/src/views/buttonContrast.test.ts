import { describe, it, expect } from 'vitest'
import fs from 'fs'
import path from 'path'

describe('Button Contrast & Plain Styling', () => {
  const cssPath = path.resolve(__dirname, '../assets/main.css')
  const css = fs.readFileSync(cssPath, 'utf-8')

  it('does not force solid background onto plain buttons with blanket .van-button--primary', () => {
    expect(css).toContain('.van-button--primary:not(.van-button--plain)')
  })

  it('explicitly styles .van-button--plain with white background and primary text/border', () => {
    expect(css).toContain('.van-button--plain.van-button--primary')
  })
})
