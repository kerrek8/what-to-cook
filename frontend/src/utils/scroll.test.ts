import { describe, it, expect, vi, beforeEach, afterEach } from 'vitest'
import { scrollToTop } from './scroll'

describe('scrollToTop', () => {
  const origWindow = globalThis.window
  const origDocument = globalThis.document

  let mockWindow: { scrollTo: ReturnType<typeof vi.fn> }
  let mockDocEl: { scrollTo: ReturnType<typeof vi.fn> }
  let mockDocBody: { scrollTo: ReturnType<typeof vi.fn> }
  let mockDocument: {
    documentElement: typeof mockDocEl
    body: typeof mockDocBody
    querySelector: ReturnType<typeof vi.fn>
  }

  beforeEach(() => {
    vi.restoreAllMocks()
    mockWindow = { scrollTo: vi.fn() }
    mockDocEl = { scrollTo: vi.fn() }
    mockDocBody = { scrollTo: vi.fn() }
    mockDocument = {
      documentElement: mockDocEl,
      body: mockDocBody,
      querySelector: vi.fn().mockReturnValue(null)
    }

    // @ts-expect-error mock window in node environment
    globalThis.window = mockWindow
    // @ts-expect-error mock document in node environment
    globalThis.document = mockDocument
  })

  afterEach(() => {
    globalThis.window = origWindow
    globalThis.document = origDocument
  })

  it('calls scrollTo on window, documentElement, and body with top: 0 and smooth behavior', () => {
    scrollToTop()
    expect(mockWindow.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
    expect(mockDocEl.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
    expect(mockDocBody.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
  })

  it('calls scrollTo on target element if provided', () => {
    const el = { scrollTo: vi.fn() } as unknown as HTMLElement
    scrollToTop(el)
    expect(el.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
  })

  it('also calls scrollTo on .content-wrapper if found in document and not target', () => {
    const wrapper = { scrollTo: vi.fn() }
    mockDocument.querySelector.mockReturnValue(wrapper)

    scrollToTop()
    expect(mockDocument.querySelector).toHaveBeenCalledWith('.content-wrapper')
    expect(wrapper.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
  })
})
