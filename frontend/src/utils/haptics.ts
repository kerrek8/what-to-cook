export type HapticType = 'light' | 'medium' | 'success' | 'warning'

const HAPTIC_PATTERNS: Record<HapticType, VibratePattern> = {
  light: 15,
  medium: 35,
  success: [50, 50, 100],
  warning: [100, 50, 100]
}

export function triggerHaptic(type: HapticType = 'light'): boolean {
  if (typeof navigator === 'undefined' || !('vibrate' in navigator) || typeof navigator.vibrate !== 'function') {
    return false
  }

  try {
    const pattern = HAPTIC_PATTERNS[type] ?? 15
    const result = navigator.vibrate(pattern)
    return typeof result === 'boolean' ? result : true
  } catch {
    return false
  }
}
