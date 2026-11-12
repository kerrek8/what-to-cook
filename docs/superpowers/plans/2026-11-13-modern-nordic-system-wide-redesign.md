# Modern Nordic System-Wide Redesign & UX Polish Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Perform an end-to-end visual overhaul in the Modern Nordic Gastro aesthetic across the entire app shell and all screens, fix the segmented control text overlapping on mobile viewports, and provide robust tap-to-scroll-to-top functionality across the bottom tabbar and top navigation header.

**Architecture:** 
1. Establish a single source of truth for the Modern Nordic Gastro design system in `frontend/src/assets/main.css` by overriding Vant UI CSS custom properties and defining unified utility tokens (Deep Sage `#1E3A2F`, Forest Accent `#2D5A43`, Nordic Peach/Terracotta `#E8A87C` / `#D97757`, Warm Canvas `#FAF8F5`, Linen `#F0ECE4`, 20px squircle cards, Glassmorphism).
2. Eliminate all remaining hardcoded legacy green colors (`#2e7d32`, `#e8f5e9`, `#f1f8e9`) across all views (`FridgeView.vue`, `ShoppingView.vue`, `ProfileView.vue`, `RecipeDetailView.vue`, `ProductCard.vue`, `ShoppingItemCard.vue`).
3. Refactor the segmented control on `RecipesView.vue` with mobile-responsive flex ergonomics (`flex: 1 1 0%`, `min-width: 0`, concise labels: "Подбор", "Все рецепты", "Избранное", micro-pill counter badges) so text never collides or truncates awkwardly on narrow screens (>=320px).
4. Implement a centralized `scrollToTop()` utility in `frontend/src/utils/scroll.ts` targeting `window`, `document.documentElement`, `document.body`, and `.content-wrapper`, wired to both bottom TabBar clicks and top AppHeader clicks.

**Tech Stack:** Vue 3, TypeScript, Vant UI 4, Tailwind CSS, Lucide icons, Vitest.

**Spec:** User feedback from session 2026-11-13:
- "скролл по тапу не работает"
- "дизайн практически не изменился, где то да, поменялись немного цвета (на незначительных плашках), но в основном по приложению цвета остались стандартные и изменений не видно"
- "в segmented control надписи наезжают друг на друга"

## Global Constraints

- **Mobile-First UX**: Responsive across narrow screens down to 320px; minimum touch target >= 44x44px.
- **Strict Typing**: Strict TypeScript, zero untyped `any`.
- **Zero Legacy Colors**: No `#2e7d32`, `#e8f5e9`, or `#f1f8e9` anywhere in frontend templates or styles.
- **Package Manager**: Exclusively `bun` (`bun run test`, `bun run type-check`, `bun run build`).
- **SemVer Versioning**: Version bump to `v0.8.2` in `frontend/package.json` and `ProfileView.vue`.

## Review Focus

1. **Segmented control text collision on 320px–375px screens**: Counter badges must remain visible and legible without pushing adjacent tab text or clipping.
2. **Scroll-to-top execution across different mobile browser scroll roots**: Both `window` scrolling (when height expands) and `.content-wrapper` scrolling (if fixed container) must smoothly animate to `top: 0`.
3. **App Header & TabBar Glassmorphism contrast**: Title, back arrow, tab icons, and badges must have WCAG AA contrast against `#FAF8F5` and blurred card backgrounds.
4. **Swipe actions in Fridge and Shopping**: Swipe actions (`van-swipe-cell`) must use Deep Sage `#1E3A2F` and Terracotta `#C0392B` without visual glitches.
5. **Form sheets and dialogs**: Modals, action sheets, and search inputs across all views must inherit Nordic canvas and sage focus states.

---

### Task 1: Centralized `scrollToTop` Utility & App Shell Scroll Triggers

**Files:**
- Create: `frontend/src/utils/scroll.ts`
- Test: `frontend/src/utils/scroll.test.ts`
- Modify: `frontend/src/components/layout/AppTabBar.vue`
- Modify: `frontend/src/components/layout/AppHeader.vue`

**Interfaces:**
- Produces: `scrollToTop(target?: HTMLElement | null): void` in `frontend/src/utils/scroll.ts`
- Consumes: `useRoute` in `AppTabBar.vue` and `AppHeader.vue`

- [ ] **Step 1: Write the failing unit test for `scrollToTop`**

Create `frontend/src/utils/scroll.test.ts`:
```ts
import { describe, it, expect, vi, beforeEach } from 'vitest'
import { scrollToTop } from './scroll'

describe('scrollToTop', () => {
  beforeEach(() => {
    vi.restoreAllMocks()
    window.scrollTo = vi.fn()
    document.documentElement.scrollTo = vi.fn()
    document.body.scrollTo = vi.fn()
  })

  it('calls scrollTo on window, documentElement, and body with top: 0 and smooth behavior', () => {
    scrollToTop()
    expect(window.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
    expect(document.documentElement.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
    expect(document.body.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
  })

  it('calls scrollTo on target element if provided', () => {
    const el = document.createElement('div')
    el.scrollTo = vi.fn()
    scrollToTop(el)
    expect(el.scrollTo).toHaveBeenCalledWith({ top: 0, behavior: 'smooth' })
  })
})
```

- [ ] **Step 2: Run test to verify it fails**

Run: `cd frontend && bun run test src/utils/scroll.test.ts`
Expected: FAIL ("Cannot find module './scroll'")

- [ ] **Step 3: Implement `scrollToTop` in `frontend/src/utils/scroll.ts`**

```ts
/**
 * Smoothly scrolls all potential viewport scroll containers to top:
 * window, documentElement, document.body, custom target, and .content-wrapper.
 */
export function scrollToTop(target?: HTMLElement | null): void {
  try {
    if (typeof window !== 'undefined') {
      window.scrollTo({ top: 0, behavior: 'smooth' })
    }
    if (typeof document !== 'undefined') {
      document.documentElement?.scrollTo({ top: 0, behavior: 'smooth' })
      document.body?.scrollTo({ top: 0, behavior: 'smooth' })
      const contentWrapper = document.querySelector('.content-wrapper') as HTMLElement | null
      if (contentWrapper && contentWrapper !== target) {
        contentWrapper.scrollTo({ top: 0, behavior: 'smooth' })
      }
    }
    if (target && typeof target.scrollTo === 'function') {
      target.scrollTo({ top: 0, behavior: 'smooth' })
    }
  } catch {
    // Fallback for environments lacking smooth scroll options
    if (typeof window !== 'undefined') window.scrollTo(0, 0)
  }
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd frontend && bun run test src/utils/scroll.test.ts`
Expected: PASS (2 tests passed)

- [ ] **Step 5: Wire `scrollToTop` into `AppTabBar.vue` and `AppHeader.vue`**

In `frontend/src/components/layout/AppTabBar.vue`:
```ts
import { scrollToTop } from '@/utils/scroll'

function handleTabClick(path: string) {
  if (route.path === path) {
    scrollToTop()
  }
}
```
Attach `@click="handleTabClick('/recipes')"` to the Recipes tab, and similarly for `/fridge`, `/shopping`.
In `frontend/src/components/layout/AppHeader.vue`:
Add `@click-title="scrollToTop()"` or a wrapper `@click="onHeaderClick"` so tapping the header scrolls the current view to top.

- [ ] **Step 6: Commit**

```bash
git add frontend/src/utils/scroll.ts frontend/src/utils/scroll.test.ts frontend/src/components/layout/AppTabBar.vue frontend/src/components/layout/AppHeader.vue
git commit -m "feat(ux): implement unified scrollToTop utility and wire into tabbar and header"
```

---

### Task 2: Segmented Control & Mobile Typography in `RecipesView.vue`

**Files:**
- Modify: `frontend/src/views/RecipesView.vue`
- Test: `frontend/src/views/RecipesView.test.ts`

**Interfaces:**
- Consumes: `useRecipeStore()`
- Produces: Responsive 3-segment control ("Подбор", "Все рецепты", "Избранное") with non-overlapping counter badges.

- [ ] **Step 1: Write a component test for `RecipesView` segmented tabs**

Create `frontend/src/views/RecipesView.test.ts`:
```ts
import { describe, it, expect, beforeEach } from 'vitest'
import { setActivePinia, createPinia } from 'pinia'
import { mount } from '@vue/test-utils'
import RecipesView from './RecipesView.vue'
import { useRecipeStore } from '@/stores/recipe'

describe('RecipesView Segmented Control', () => {
  beforeEach(() => {
    setActivePinia(createPinia())
  })

  it('renders three segmented tabs with concise labels and active state tracking', async () => {
    const wrapper = mount(RecipesView, {
      global: {
        stubs: {
          'van-search': true,
          'van-icon': true,
          'van-empty': true,
          'van-button': true,
          RecipeCard: true
        }
      }
    })

    const tabs = wrapper.findAll('.tab-btn')
    expect(tabs.length).toBe(3)
    expect(tabs[0].text()).toContain('Подбор')
    expect(tabs[1].text()).toContain('Все рецепты')
    expect(tabs[2].text()).toContain('Избранное')

    const recipeStore = useRecipeStore()
    await tabs[1].trigger('click')
    expect(recipeStore.activeTab).toBe('all')
  })
})
```

- [ ] **Step 2: Run test to verify failure or differences**

Run: `cd frontend && bun run test src/views/RecipesView.test.ts`
Expected: FAIL (currently tab 0 text is "Что приготовить", not "Подбор")

- [ ] **Step 3: Update `RecipesView.vue` segmented tabs structure and CSS**

In `frontend/src/views/RecipesView.vue`:
1. Change tab 1 label to `"Подбор"` (concise, clear, doesn't collide).
2. Update `.tabs-segmented` and `.tab-btn`:
```css
.tabs-segmented {
  background-color: #EAE6DF;
  padding: 4px;
  border-radius: 16px;
  display: flex;
  gap: 3px;
  width: 100%;
}

.tab-btn {
  flex: 1 1 0%;
  min-width: 0;
  border: none;
  background: transparent;
  padding: 8px 4px;
  min-height: 42px;
  border-radius: 12px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

.tab-btn span.tab-title {
  font-size: 12px;
  font-weight: 500;
  color: #57534e;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.tab-btn.active span.tab-title {
  font-weight: 600;
  color: #1E3A2F;
}

.tab-btn.active {
  background-color: #ffffff;
  box-shadow: 0 1px 4px rgba(30, 58, 47, 0.08), 0 1px 2px rgba(30, 58, 47, 0.04);
}

.count-badge {
  font-size: 10px;
  font-weight: 700;
  padding: 1px 5px;
  border-radius: 9999px;
  line-height: 1.2;
  flex-shrink: 0;
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `cd frontend && bun run test src/views/RecipesView.test.ts`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add frontend/src/views/RecipesView.vue frontend/src/views/RecipesView.test.ts
git commit -m "fix(recipes): make segmented control mobile-responsive and prevent text collision"
```

---

### Task 3: Global Nordic Design System Foundation in `main.css`

**Files:**
- Modify: `frontend/src/assets/main.css`

**Interfaces:**
- Produces: Complete Vant 4 theme overrides and global Modern Nordic tokens.

- [ ] **Step 1: Check existing CSS color tokens**

Review `frontend/src/assets/main.css` for any leftover green colors (`#2e7d32`, `#e8f5e9`, etc.).

- [ ] **Step 2: Update `main.css` with complete Modern Nordic Design System tokens and component overrides**

Update `:root` in `frontend/src/assets/main.css`:
```css
:root {
  /* Nordic Gastro Theme Palette */
  --van-primary-color: #1E3A2F;
  --van-success-color: #2D5A43;
  --van-warning-color: #E8A87C;
  --van-danger-color: #C0392B;
  --van-background: #FAF8F5;
  --van-background-2: #FFFFFF;
  --van-text-color: #1C1917;
  --van-text-color-2: #57534E;
  --van-text-color-3: #A8A29E;
  --van-border-color: rgba(30, 58, 47, 0.08);

  /* Component specifics */
  --van-nav-bar-background: rgba(250, 248, 245, 0.92);
  --van-nav-bar-title-text-color: #1E3A2F;
  --van-nav-bar-icon-color: #1E3A2F;
  --van-nav-bar-height: 52px;
  --van-tabbar-background: rgba(250, 248, 245, 0.94);
  --van-tabbar-item-active-color: #1E3A2F;
  --van-tabbar-item-text-color: #8C827A;
  --van-button-primary-background: #1E3A2F;
  --van-button-primary-border-color: #1E3A2F;
  --van-search-background: transparent;
  --van-search-content-background: #FFFFFF;

  /* Nordic gastro custom variables */
  --nordic-canvas: #FAF8F5;
  --nordic-card-bg: #FFFFFF;
  --nordic-sage: #1E3A2F;
  --nordic-sage-light: #2D5A43;
  --nordic-peach: #E8A87C;
  --nordic-terracotta: #D97757;
  --nordic-linen: #F0ECE4;
  --nordic-card-radius: 20px;
  --nordic-card-shadow: 0 4px 20px -2px rgba(30, 58, 47, 0.06), 0 2px 6px -1px rgba(30, 58, 47, 0.04);
  --nordic-card-border: 1px solid rgba(30, 58, 47, 0.06);
}
```

Add global Vant component enhancements:
- Rounded search inputs with Nordic border and subtle shadow.
- Pill buttons with soft hover/active transitions.
- Global squircle radius (`20px`) for cards and dialogs.
- Clean typography rules.

- [ ] **Step 3: Run existing frontend test suite to ensure no breakage**

Run: `cd frontend && bun run test`
Expected: PASS (all tests pass)

- [ ] **Step 4: Commit**

```bash
git add frontend/src/assets/main.css
git commit -m "style(theme): establish global Modern Nordic Gastro tokens and Vant overrides"
```

---

### Task 4: App Shell Modern Nordic Overhaul (`AppHeader.vue` & `AppTabBar.vue`)

**Files:**
- Modify: `frontend/src/components/layout/AppHeader.vue`
- Modify: `frontend/src/components/layout/AppTabBar.vue`

**Interfaces:**
- Consumes: Vant UI components `<van-nav-bar>`, `<van-tabbar>`, `<van-tabbar-item>`
- Produces: Translucent blurred header with deep sage brand title; blurred floating tabbar with active indicator dot and terracotta badges.

- [ ] **Step 1: Restyle `AppHeader.vue`**

In `frontend/src/components/layout/AppHeader.vue`:
- Apply backdrop blur: `backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); background-color: rgba(250, 248, 245, 0.88);`
- Border: `border-bottom: 1px solid rgba(30, 58, 47, 0.06);`
- Title: `color: #1E3A2F; font-weight: 700; letter-spacing: -0.02em; font-size: 18px;`
- Arrow: `color: #1E3A2F;`
- Add `@click.stop="scrollToTop()"` to header title.

- [ ] **Step 2: Restyle `AppTabBar.vue`**

In `frontend/src/components/layout/AppTabBar.vue`:
- TabBar background: `backdrop-filter: blur(16px); -webkit-backdrop-filter: blur(16px); background-color: rgba(250, 248, 245, 0.92);`
- Border: `border-top: 1px solid rgba(30, 58, 47, 0.06);`
- Active color: `#1E3A2F`
- Inactive color: `#8C827A`
- Badge style: terracotta background `#D97757`, white text, 10px bold font.
- Active tab indicator: add a subtle small dot or active pill indicator.

- [ ] **Step 3: Run type check and tests**

Run: `cd frontend && bun run type-check && bun run test`
Expected: PASS

- [ ] **Step 4: Commit**

```bash
git add frontend/src/components/layout/AppHeader.vue frontend/src/components/layout/AppTabBar.vue
git commit -m "style(layout): redesign AppHeader and AppTabBar with Nordic glassmorphism"
```

---

### Task 5: Deep Restyling of Screens (`FridgeView`, `ProductCard`, `ShoppingView`, `ShoppingItemCard`, `ProfileView`, `RecipeDetailView`)

**Files:**
- Modify: `frontend/src/views/FridgeView.vue`
- Modify: `frontend/src/components/inventory/ProductCard.vue`
- Modify: `frontend/src/views/ShoppingView.vue`
- Modify: `frontend/src/components/shopping/ShoppingItemCard.vue`
- Modify: `frontend/src/views/ProfileView.vue`
- Modify: `frontend/src/views/RecipeDetailView.vue`

**Interfaces:**
- Consumes: Nordic tokens from `main.css`
- Produces: Harmonious Modern Nordic Gastro appearance across all screens.

- [ ] **Step 1: Restyle `FridgeView.vue` & `ProductCard.vue`**
  - Replace all `#2e7d32` with `#1E3A2F`.
  - Update FAB button: `background-color: #1E3A2F`, shadow `0 4px 16px rgba(30, 58, 47, 0.25)`.
  - Filter chips: Nordic stone border, active deep sage background.
  - `ProductCard.vue`: `border-radius: 18px`, `box-shadow: 0 4px 16px -2px rgba(30, 58, 47, 0.05)`, swipe action button in Deep Sage `#1E3A2F`.

- [ ] **Step 2: Restyle `ShoppingView.vue` & `ShoppingItemCard.vue`**
  - Replace all `#2e7d32` and `#e8f5e9` with `#1E3A2F` and `rgba(30, 58, 47, 0.06)`.
  - Checkbox checked state: `#1E3A2F`.
  - Transfer button and FAB button: `#1E3A2F`.
  - Department cards: 20px squircle radius, soft shadow, subtle header typography.

- [ ] **Step 3: Restyle `ProfileView.vue`**
  - Replace `#2e7d32` in avatar badge, actions, and buttons with `#1E3A2F`.
  - User cards and guest cards: 20px squircle radius, Nordic shadow.
  - Cell groups: clean rounded cards on canvas `#FAF8F5`.

- [ ] **Step 4: Restyle `RecipeDetailView.vue`**
  - Replace any remaining `#2e7d32` in primary buttons, timer action buttons, or step checkboxes with `#1E3A2F`.
  - Ensure floating timer pill matches Nordic terracotta/sage aesthetic.

- [ ] **Step 5: Run type check and all unit tests**

Run: `cd frontend && bun run type-check && bun run test`
Expected: PASS (all tests pass)

- [ ] **Step 6: Commit**

```bash
git add frontend/src/views/FridgeView.vue frontend/src/components/inventory/ProductCard.vue frontend/src/views/ShoppingView.vue frontend/src/components/shopping/ShoppingItemCard.vue frontend/src/views/ProfileView.vue frontend/src/views/RecipeDetailView.vue
git commit -m "style(views): eliminate legacy green colors and apply Nordic styling across all views"
```

---

### Task 6: Final Verification, Version Bump (v0.8.2), and Documentation Update

**Files:**
- Modify: `frontend/package.json`
- Modify: `frontend/src/views/ProfileView.vue`
- Modify: `docs/roadmap.md`

- [ ] **Step 1: Bump SemVer version to `0.8.2`**
  - Update `version: "0.8.2"` in `frontend/package.json`.
  - Update `WhatCook v0.8.2` in `frontend/src/views/ProfileView.vue`.

- [ ] **Step 2: Run all verification commands**
  - Frontend type check: `cd frontend && bun run type-check`
  - Frontend unit tests: `cd frontend && bun run test`
  - Frontend build: `cd frontend && bun run build` (outside sandbox if workbox requires)
  - Backend tests: `cd backend && go test -count=1 ./...`
  - Backend vet: `cd backend && go vet ./...`

- [ ] **Step 3: Update `docs/roadmap.md`**
  - Mark new release section as completed with full task details.

- [ ] **Step 4: Commit and push**
  - Commit on feature branch `feat/f22-nordic-system-wide-polish`.
  - Push branch to `origin`.
  - Merge into `master` and push `master` to `origin`.
