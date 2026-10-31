import { describe, it, expect } from 'vitest'
import { getFreshnessInfo, formatQuantity } from './freshness'

describe('freshness utility', () => {
  it('returns none status for null or empty expiration date', () => {
    expect(getFreshnessInfo(null).status).toBe('none')
    expect(getFreshnessInfo(undefined).status).toBe('none')
    expect(getFreshnessInfo('').status).toBe('none')
  })

  it('identifies overdue or today as danger', () => {
    const todayStr = new Date().toISOString().split('T')[0]
    const todayInfo = getFreshnessInfo(todayStr)
    expect(todayInfo.status).toBe('danger')
    expect(todayInfo.label).toContain('сегодня')

    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 2)
    const yesterdayStr = yesterday.toISOString().split('T')[0]
    const overdueInfo = getFreshnessInfo(yesterdayStr)
    expect(overdueInfo.status).toBe('danger')
    expect(overdueInfo.label).toContain('Истек')
  })

  it('identifies 1 to 3 days as warning', () => {
    const tomorrow = new Date()
    tomorrow.setDate(tomorrow.getDate() + 1)
    const tomorrowStr = tomorrow.toISOString().split('T')[0]
    const tomorrowInfo = getFreshnessInfo(tomorrowStr)
    expect(tomorrowInfo.status).toBe('warning')
    expect(tomorrowInfo.label).toContain('1 день')

    const in3Days = new Date()
    in3Days.setDate(in3Days.getDate() + 3)
    const in3DaysStr = in3Days.toISOString().split('T')[0]
    const in3DaysInfo = getFreshnessInfo(in3DaysStr)
    expect(in3DaysInfo.status).toBe('warning')
  })

  it('identifies more than 3 days as fresh', () => {
    const nextWeek = new Date()
    nextWeek.setDate(nextWeek.getDate() + 7)
    const nextWeekStr = nextWeek.toISOString().split('T')[0]
    const info = getFreshnessInfo(nextWeekStr)
    expect(info.status).toBe('fresh')
    expect(info.daysLeft).toBe(7)
  })

  it('formats exact and qualitative quantities correctly', () => {
    expect(formatQuantity(500, 'г')).toBe('500 г')
    expect(formatQuantity(1.5, 'л')).toBe('1.5 л')
    expect(formatQuantity(null, null, 'few')).toBe('Мало')
    expect(formatQuantity(null, null, 'medium')).toBe('Средне')
    expect(formatQuantity(null, null, 'much')).toBe('Много')
    expect(formatQuantity(null, null, null)).toBe('В наличии')
  })
})
