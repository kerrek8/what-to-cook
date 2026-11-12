export function scaleAmount(
  baseAmount: number | null | undefined,
  baseServings: number,
  targetServings: number
): number | null {
  if (baseAmount == null || typeof baseAmount !== 'number' || Number.isNaN(baseAmount)) {
    return null
  }
  if (baseServings <= 0 || targetServings <= 0) {
    return null
  }

  const ratio = targetServings / baseServings
  const scaled = baseAmount * ratio
  return Math.round(scaled * 10) / 10
}

export function formatScaledAmount(
  amount: number | null | undefined,
  unit: string | null | undefined,
  displayText?: string | null,
  baseServings: number = 2,
  targetServings: number = 2
): string {
  if (displayText && amount == null) {
    return displayText
  }

  if (amount != null && !Number.isNaN(amount)) {
    const scaledAmount = scaleAmount(amount, baseServings, targetServings)
    if (scaledAmount != null) {
      const unitPart = unit ? ` ${unit}` : ''
      return `${scaledAmount}${unitPart}`.trim()
    }
  }

  if (displayText) {
    return displayText
  }

  return 'По вкусу'
}
