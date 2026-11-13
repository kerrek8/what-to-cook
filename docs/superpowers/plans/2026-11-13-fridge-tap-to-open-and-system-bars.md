# Tap-to-Open in Fridge & System Bars Calibration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement interactive "Tap-to-Open" behavior and visual swipe affordance on fridge product cards ([ProductCard.vue](frontend/src/components/inventory/ProductCard.vue)), and calibrate mobile system bar theme-colors to pure `#FFFFFF` across [index.html](frontend/index.html) and [vite.config.ts](frontend/vite.config.ts) to eliminate tone mismatch with the app header and configure PWA background color.

**Architecture & Key Decisions:**
1. **Tap-to-Open on ProductCard**:
   - `SwipeCell` from Vant exposes `.open('right')` and `.close()` methods.
   - Clicking `.product-card` toggles the swipe state: if closed, opens right buttons with light haptic feedback (`triggerLightHaptic()`); if open, closes them.
   - Native touch swiping is preserved completely.
   - Visual affordance: an understated swipe hint chevron `<van-icon name="arrow-left" />` next to quantity that cues horizontal dragging and rotates/fades when opened.
2. **System Bar Theme Calibration**:
   - `<meta name="theme-color" content="#FFFFFF">` in `index.html`.
   - `theme_color: '#FFFFFF'`, `background_color: '#FFFFFF'` in `vite.config.ts` PWA manifest.
   - Ensures the status bar and the white header (`AppHeader.vue`) render as a single unified white surface without any gray seam.
3. **Target Release Version**: `v0.8.4`.
4. **Git Branch**: `feat/f24-fridge-tap-to-open-and-system-bars`.

---

## Tasks

### Task 1: System Bars & PWA Manifest Tone Calibration (`#FFFFFF`)

**Files:**
- Modify: `frontend/src/utils/themeMeta.test.ts`
- Modify: `frontend/index.html`
- Modify: `frontend/vite.config.ts`

- [ ] **Step 1: Update unit test to require pure `#FFFFFF` theme-color**

Update `frontend/src/utils/themeMeta.test.ts` to assert that `index.html` has `<meta name="theme-color" content="#FFFFFF">` and `vite.config.ts` has `theme_color: '#FFFFFF'`:
```ts
it('configures index.html meta theme-color as pure white #FFFFFF', () => {
  expect(html).toContain('content="#FFFFFF"')
})

it('configures vite.config.ts manifest theme_color and background_color as #FFFFFF', () => {
  expect(viteConfig).toContain("theme_color: '#FFFFFF'")
  expect(viteConfig).toContain("background_color: '#FFFFFF'")
})
```

- [ ] **Step 2: Run test to verify failure**

Run: `cd frontend && bun run test src/utils/themeMeta.test.ts`
Expected: FAIL

- [ ] **Step 3: Update `index.html` and `vite.config.ts` to `#FFFFFF`**

In `frontend/index.html`:
```html
<meta name="theme-color" content="#FFFFFF" />
```

In `frontend/vite.config.ts`:
```ts
theme_color: '#FFFFFF',
background_color: '#FFFFFF',
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd frontend && bun run test src/utils/themeMeta.test.ts`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add frontend/src/utils/themeMeta.test.ts frontend/index.html frontend/vite.config.ts
git commit -m "fix(theme): calibrate system theme-color and PWA manifest to pure white #FFFFFF"
```

---

### Task 2: Tap-to-Open & Swipe Hint Affordance on ProductCard

**Files:**
- Create: `frontend/src/components/inventory/productCard.test.ts`
- Modify: `frontend/src/components/inventory/ProductCard.vue`

- [ ] **Step 1: Write failing unit tests for ProductCard tap-to-open and swipe hint**

Create `frontend/src/components/inventory/productCard.test.ts`:
```ts
import { describe, it, expect, vi } from 'vitest'
import { mount } from '@vue/test-utils'
import ProductCard from './ProductCard.vue'
import type { LocalInventoryItem } from '@/db/types'

describe('ProductCard Tap-to-Open and Swipe Hint', () => {
  const sampleItem: LocalInventoryItem = {
    id: 1,
    userId: 'user-1',
    name: 'Молоко',
    category: 'Молочные продукты',
    amount: 1,
    unit: 'л',
    approximateQuantity: 'much',
    expirationDate: '2026-11-20',
    synced: 1,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString()
  }

  it('renders swipe hint chevron affordance', () => {
    const wrapper = mount(ProductCard, {
      props: { item: sampleItem },
      global: {
        stubs: {
          'van-swipe-cell': {
            template: '<div class="van-swipe-cell"><slot /><slot name="right" /></div>',
            methods: {
              open: vi.fn(),
              close: vi.fn()
            }
          },
          'van-icon': true,
          'van-button': true
        }
      }
    })

    expect(wrapper.find('.swipe-hint').exists()).toBe(true)
  })

  it('triggers open on van-swipe-cell when product-card is clicked', async () => {
    const openMock = vi.fn()
    const closeMock = vi.fn()

    const wrapper = mount(ProductCard, {
      props: { item: sampleItem },
      global: {
        stubs: {
          'van-swipe-cell': {
            template: '<div class="van-swipe-cell"><slot /><slot name="right" /></div>',
            methods: {
              open: openMock,
              close: closeMock
            }
          },
          'van-icon': true,
          'van-button': true
        }
      }
    })

    await wrapper.find('.product-card').trigger('click')
    expect(openMock).toHaveBeenCalledWith('right')
  })
})
```

- [ ] **Step 2: Run test to verify failure**

Run: `cd frontend && bun run test src/components/inventory/productCard.test.ts`
Expected: FAIL

- [ ] **Step 3: Implement Tap-to-Open and visual chevron in `ProductCard.vue`**

In `frontend/src/components/inventory/ProductCard.vue`:
1. Import `ref` and `type SwipeCellInstance` from `vant`.
2. Import `triggerLightHaptic` from `@/utils/haptics`.
3. Add `const swipeCellRef = ref<SwipeCellInstance | null>(null)` and `const isOpen = ref(false)`.
4. Connect `@open="isOpen = true"` and `@close="isOpen = false"` on `<van-swipe-cell ref="swipeCellRef">`.
5. Add click handler:
```ts
function onCardClick() {
  if (!isOpen.value) {
    swipeCellRef.value?.open('right')
    triggerLightHaptic()
  } else {
    swipeCellRef.value?.close()
  }
}
```
6. In template:
```html
<div class="product-qty-wrapper">
  <span class="product-qty">{{ formattedQuantity }}</span>
  <span class="swipe-hint" :class="{ 'is-open': isOpen }" aria-hidden="true">
    <van-icon name="arrow-left" />
  </span>
</div>
```
7. Style `.swipe-hint`:
```css
.product-qty-wrapper {
  display: flex;
  align-items: center;
  gap: 4px;
}

.swipe-hint {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #94A3B8;
  font-size: 13px;
  transition: transform 0.25s ease, opacity 0.2s ease, color 0.2s ease;
}

.swipe-hint.is-open {
  transform: rotate(180deg);
  color: #064E3B;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd frontend && bun run test src/components/inventory/productCard.test.ts`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add frontend/src/components/inventory/ProductCard.vue frontend/src/components/inventory/productCard.test.ts
git commit -m "feat(fridge): add tap-to-open gesture and swipe hint affordance to ProductCard"
```

---

### Task 3: Full Verification, Version Bump (v0.8.4) & Roadmap Documentation

**Files:**
- Modify: `frontend/package.json`
- Modify: `frontend/src/views/ProfileView.vue`
- Modify: `docs/roadmap.md`

- [ ] **Step 1: Bump SemVer to `0.8.4`**
  - Update `frontend/package.json` to `"version": "0.8.4"`.
  - Update `frontend/src/views/ProfileView.vue` to `WhatCook v0.8.4`.

- [ ] **Step 2: Run full verification suite**
  - `cd frontend && bun run type-check && bun run test`
  - `cd frontend && bun run build`
  - `cd backend && go test -count=1 ./... && go vet ./...`

- [ ] **Step 3: Update `docs/roadmap.md` and commit**

Append completed section in `docs/roadmap.md` for `v0.8.4`.
Commit:
```bash
git add frontend/package.json frontend/src/views/ProfileView.vue docs/roadmap.md docs/superpowers/plans/2026-11-13-fridge-tap-to-open-and-system-bars.md
git commit -m "chore(release): bump version to v0.8.4 and update roadmap"
```

- [ ] **Step 4: Push feature branch, merge into master, and push master**
  - `git push -u origin feat/f24-fridge-tap-to-open-and-system-bars`
  - `git checkout master` && `git pull origin master`
  - `git merge feat/f24-fridge-tap-to-open-and-system-bars --no-ff -m "Merge branch 'feat/f24-fridge-tap-to-open-and-system-bars' into master"`
  - `git push origin master`
