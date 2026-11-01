import { describe, it, expect } from 'vitest'
import { urlBase64ToUint8Array, isPushSupported } from './push'

describe('push utils', () => {
  it('converts base64 url string to Uint8Array', () => {
    const base64 = 'BA1234567890-_'
    const arr = urlBase64ToUint8Array(base64)
    expect(arr).toBeInstanceOf(Uint8Array)
    expect(arr.length).toBeGreaterThan(0)
  })

  it('checks if push is supported without crashing in node/browser', () => {
    const supported = isPushSupported()
    expect(typeof supported).toBe('boolean')
  })
})
