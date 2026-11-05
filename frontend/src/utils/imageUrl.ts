export function getImageUrl(url?: string | null): string {
  if (!url) return ''
  if (url.startsWith('http://') || url.startsWith('https://')) return url
  const apiBase = import.meta.env.VITE_API_URL || ''
  return `${apiBase}${url}`
}
