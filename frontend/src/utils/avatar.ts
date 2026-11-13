export const AVATAR_PALETTE = [
  '#022C22',
  '#065F46',
  '#D35400',
  '#064E3B',
  '#C0392B',
  '#7D6608',
  '#117A65',
  '#2874A6'
] as const

export function getInitials(name?: string | null): string {
  if (!name) return '?'
  const trimmed = name.trim()
  if (!trimmed) return '?'

  const parts = trimmed.split(/[\s-]+/).filter(Boolean)
  if (parts.length === 0) return '?'

  if (parts.length === 1) {
    const firstChar = Array.from(parts[0])[0]
    return firstChar ? firstChar.toUpperCase() : '?'
  }

  const firstChar = Array.from(parts[0])[0] || ''
  const secondChar = Array.from(parts[1])[0] || ''
  const initials = (firstChar + secondChar).toUpperCase()
  return initials || '?'
}

export function getAvatarColor(name?: string | null): string {
  if (!name || !name.trim()) {
    return AVATAR_PALETTE[0]
  }

  const str = name.trim()
  let hash = 5381
  for (let i = 0; i < str.length; i++) {
    hash = (hash << 5) + hash + str.charCodeAt(i)
  }

  const index = Math.abs(hash) % AVATAR_PALETTE.length
  return AVATAR_PALETTE[index]
}
