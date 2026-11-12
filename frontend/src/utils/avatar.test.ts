import { describe, it, expect } from 'vitest'
import { getInitials, getAvatarColor, AVATAR_PALETTE } from './avatar'

describe('getInitials', () => {
  it('returns "?" for null or undefined', () => {
    expect(getInitials(null)).toBe('?')
    expect(getInitials(undefined)).toBe('?')
    expect(getInitials()).toBe('?')
  })

  it('returns "?" for empty or whitespace-only strings', () => {
    expect(getInitials('')).toBe('?')
    expect(getInitials('   ')).toBe('?')
    expect(getInitials('\t\n')).toBe('?')
  })

  it('returns capitalized first letter for single-word names', () => {
    expect(getInitials('иван')).toBe('И')
    expect(getInitials('Алексей')).toBe('А')
    expect(getInitials('chef')).toBe('C')
    expect(getInitials('   maria  ')).toBe('M')
  })

  it('returns two letters for two-word names', () => {
    expect(getInitials('Иван Иванов')).toBe('ИИ')
    expect(getInitials('gordon ramsay')).toBe('GR')
    expect(getInitials('  John   Doe  ')).toBe('JD')
  })

  it('handles hyphenated names as separate words', () => {
    expect(getInitials('Анна-Мария')).toBe('АМ')
    expect(getInitials('Jean-Luc')).toBe('JL')
    expect(getInitials('Жан-Поль Сартр')).toBe('ЖП')
  })

  it('takes first two words when three or more words are provided', () => {
    expect(getInitials('Александр Сергеевич Пушкин')).toBe('АС')
    expect(getInitials('Sir Arthur Conan Doyle')).toBe('SA')
  })

  it('handles strings with only punctuation or hyphens', () => {
    expect(getInitials('---')).toBe('?')
  })
})

describe('getAvatarColor', () => {
  it('returns first palette color for null, undefined or empty', () => {
    expect(getAvatarColor(null)).toBe(AVATAR_PALETTE[0])
    expect(getAvatarColor(undefined)).toBe(AVATAR_PALETTE[0])
    expect(getAvatarColor('')).toBe(AVATAR_PALETTE[0])
    expect(getAvatarColor('   ')).toBe(AVATAR_PALETTE[0])
  })

  it('is deterministic: returns identical color for same input', () => {
    const color1 = getAvatarColor('Иван Иванов')
    const color2 = getAvatarColor('Иван Иванов')
    expect(color1).toBe(color2)

    const color3 = getAvatarColor('Gordon Ramsay')
    const color4 = getAvatarColor('Gordon Ramsay')
    expect(color3).toBe(color4)
  })

  it('always returns a color from AVATAR_PALETTE', () => {
    const testNames = [
      'Anna',
      'Борис',
      'Владимир',
      'Дмитрий',
      'Elena',
      'Федор',
      'Галина',
      'Харитон',
      'Илья',
      'Chef123'
    ]

    for (const name of testNames) {
      const color = getAvatarColor(name)
      expect(AVATAR_PALETTE).toContain(color)
    }
  })

  it('has exact culinary palette defined', () => {
    expect(AVATAR_PALETTE).toEqual([
      '#1E392A',
      '#2D5A43',
      '#D35400',
      '#1E3A2F',
      '#C0392B',
      '#7D6608',
      '#117A65',
      '#2874A6'
    ])
  })
})
