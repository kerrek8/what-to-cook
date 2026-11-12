/**
 * Smoothly scrolls all potential viewport scroll containers to top:
 * window, documentElement, document.body, custom target, and .content-wrapper.
 */
export function scrollToTop(target?: HTMLElement | null): void {
  try {
    if (typeof window !== 'undefined' && typeof window.scrollTo === 'function') {
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }
    if (typeof document !== 'undefined') {
      if (document.documentElement && typeof document.documentElement.scrollTo === 'function') {
        document.documentElement.scrollTo({ top: 0, behavior: 'smooth' })
      }
      if (document.body && typeof document.body.scrollTo === 'function') {
        document.body.scrollTo({ top: 0, behavior: 'smooth' })
      }
      const contentWrapper = document.querySelector('.content-wrapper') as HTMLElement | null
      if (contentWrapper && contentWrapper !== target && typeof contentWrapper.scrollTo === 'function') {
        contentWrapper.scrollTo({ top: 0, behavior: 'smooth' })
      }
    }
    if (target && typeof target.scrollTo === 'function') {
      target.scrollTo({ top: 0, behavior: 'smooth' })
    }
  } catch {
    if (typeof window !== 'undefined' && typeof window.scrollTo === 'function') {
      window.scrollTo(0, 0)
    }
  }
}
