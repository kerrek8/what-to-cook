import { describe, it, expect } from 'vitest'
import { getImageUrl } from './imageUrl'

describe('getImageUrl', () => {
  it('returns empty string if url is undefined or null', () => {
    expect(getImageUrl()).toBe('')
    expect(getImageUrl(null)).toBe('')
    expect(getImageUrl('')).toBe('')
  })

  it('returns external HTTP/HTTPS urls untouched', () => {
    expect(getImageUrl('https://images.unsplash.com/photo-123')).toBe(
      'https://images.unsplash.com/photo-123'
    )
    expect(getImageUrl('http://example.com/food.jpg')).toBe(
      'http://example.com/food.jpg'
    )
  })

  it('handles relative local upload urls', () => {
    const result = getImageUrl('/uploads/recipes/recipe_123.jpg')
    expect(result).toContain('/uploads/recipes/recipe_123.jpg')
  })
})
