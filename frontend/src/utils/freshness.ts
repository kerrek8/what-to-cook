export type FreshnessStatus = 'fresh' | 'warning' | 'danger' | 'none'

export interface FreshnessInfo {
  status: FreshnessStatus
  daysLeft: number | null
  label: string
  color: string
}

export function getFreshnessInfo(expirationDate?: string | null): FreshnessInfo {
  if (!expirationDate) {
    return {
      status: 'none',
      daysLeft: null,
      label: 'Без срока',
      color: '#969799'
    }
  }

  const today = new Date()
  today.setHours(0, 0, 0, 0)

  const datePart = expirationDate.split('T')[0]
  const [yearStr, monthStr, dayStr] = datePart.split('-')
  const y = Number(yearStr)
  const m = Number(monthStr)
  const d = Number(dayStr)

  const exp = !isNaN(y) && !isNaN(m) && !isNaN(d)
    ? new Date(y, m - 1, d, 0, 0, 0, 0)
    : new Date(expirationDate)
  exp.setHours(0, 0, 0, 0)

  const diffTime = exp.getTime() - today.getTime()
  const daysLeft = Math.round(diffTime / (1000 * 60 * 60 * 24))

  if (daysLeft < 0) {
    const overdue = Math.abs(daysLeft)
    return {
      status: 'danger',
      daysLeft,
      label: `Истек ${overdue} дн. назад`,
      color: '#f44336'
    }
  }

  if (daysLeft === 0) {
    return {
      status: 'danger',
      daysLeft,
      label: 'Истекает сегодня!',
      color: '#f44336'
    }
  }

  if (daysLeft === 1) {
    return {
      status: 'warning',
      daysLeft,
      label: 'Остался 1 день',
      color: '#ff9800'
    }
  }

  if (daysLeft <= 3) {
    return {
      status: 'warning',
      daysLeft,
      label: `Осталось ${daysLeft} дн.`,
      color: '#ff9800'
    }
  }

  return {
    status: 'fresh',
    daysLeft,
    label: `Годен еще ${daysLeft} дн.`,
    color: '#2D5A43'
  }
}

export function formatQuantity(
  amount?: number | null,
  unit?: string | null,
  approx?: string | null
): string {
  if (amount !== null && amount !== undefined) {
    const formattedAmount = Number.isInteger(amount) ? amount : amount.toFixed(1)
    return `${formattedAmount} ${unit || 'шт'}`
  }

  if (approx === 'few') return 'Мало'
  if (approx === 'medium') return 'Средне'
  if (approx === 'much') return 'Много'

  return 'В наличии'
}
