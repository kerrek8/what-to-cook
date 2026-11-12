import { describe, it, expect } from 'vitest'
import { scaleAmount, formatScaledAmount } from './servings'

describe('servings utility', () => {
  describe('scaleAmount', () => {
    it('returns null if baseAmount is null or undefined', () => {
      expect(scaleAmount(null, 2, 4)).toBeNull()
      expect(scaleAmount(undefined, 2, 4)).toBeNull()
      expect(scaleAmount(NaN, 2, 4)).toBeNull()
    })

    it('returns null if baseServings is less than or equal to 0', () => {
      expect(scaleAmount(100, 0, 4)).toBeNull()
      expect(scaleAmount(100, -1, 4)).toBeNull()
      expect(scaleAmount(100, -5, 4)).toBeNull()
    })

    it('returns null if targetServings is less than or equal to 0', () => {
      expect(scaleAmount(100, 2, 0)).toBeNull()
      expect(scaleAmount(100, 2, -1)).toBeNull()
    })

    it('scales amounts proportionally and returns exact integers', () => {
      expect(scaleAmount(200, 2, 4)).toBe(400)
      expect(scaleAmount(200, 4, 2)).toBe(100)
      expect(scaleAmount(150, 2, 2)).toBe(150)
      expect(scaleAmount(0, 2, 4)).toBe(0)
    })

    it('rounds fractional results to 1 decimal place', () => {
      // 100 * (2 / 3) = 66.6666... -> 66.7
      expect(scaleAmount(100, 3, 2)).toBe(66.7)
      // 1 * (1 / 2) = 0.5
      expect(scaleAmount(1, 2, 1)).toBe(0.5)
      // 100 * (1 / 3) = 33.3333... -> 33.3
      expect(scaleAmount(100, 3, 1)).toBe(33.3)
      // 100 * (4 / 3) = 133.3333... -> 133.3
      expect(scaleAmount(100, 3, 4)).toBe(133.3)
    })
  })

  describe('formatScaledAmount', () => {
    it('returns displayText when amount is null or undefined and displayText is provided', () => {
      expect(formatScaledAmount(null, 'г', '1 щепотка')).toBe('1 щепотка')
      expect(formatScaledAmount(undefined, null, 'По вкусу (Базовый)')).toBe('По вкусу (Базовый)')
    })

    it('formats amount with unit when scaled', () => {
      expect(formatScaledAmount(200, 'г', null, 2, 4)).toBe('400 г')
      expect(formatScaledAmount(150, 'мл', undefined, 2, 2)).toBe('150 мл')
    })

    it('formats amount without unit or with null/whitespace unit', () => {
      expect(formatScaledAmount(2, null, null, 2, 4)).toBe('4')
      expect(formatScaledAmount(2, undefined, null, 2, 3)).toBe('3')
      expect(formatScaledAmount(2, '   ', null, 2, 4)).toBe('4')
    })

    it('formats decimals correctly with unit', () => {
      expect(formatScaledAmount(100, 'г', null, 3, 2)).toBe('66.7 г')
      expect(formatScaledAmount(1, 'шт.', null, 2, 1)).toBe('0.5 шт.')
    })

    it('defaults baseServings and targetServings to 2', () => {
      expect(formatScaledAmount(200, 'г')).toBe('200 г')
      expect(formatScaledAmount(3, 'шт.')).toBe('3 шт.')
    })

    it('returns "По вкусу" when both amount and displayText are null or undefined', () => {
      expect(formatScaledAmount(null, null)).toBe('По вкусу')
      expect(formatScaledAmount(undefined, undefined, undefined)).toBe('По вкусу')
      expect(formatScaledAmount(null, 'г', null)).toBe('По вкусу')
    })

    it('handles amount of 0', () => {
      expect(formatScaledAmount(0, 'г', null, 2, 4)).toBe('0 г')
    })

    it('falls back to displayText if scaleAmount returns null due to invalid servings', () => {
      expect(formatScaledAmount(100, 'г', 'Около 100г', 0, 4)).toBe('Около 100г')
      expect(formatScaledAmount(100, 'г', null, 0, 4)).toBe('По вкусу')
    })
  })
})
