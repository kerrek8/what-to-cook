# Modern Culinary UI (Shadcn/Tailwind), Virtual Scroll & Avatar Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Перевести интерфейс WhatCook PWA на современный кулинарный дизайн-код (Tailwind CSS + Shadcn-примитивы + Lucide Icons), внедрить высокопроизводительный виртуализированный скролл каталога (`@tanstack/vue-virtual`), 3-уровневую систему готовности рецептов, full-stack загрузку аватара пользователя, калькулятор порций, плавающий таймер и тактильный отклик.

**Architecture:** 
- **Backend (Go / Gin / PostgreSQL / SQLC)**: Миграция `000004_user_avatar`, встроенный билинейный оптимизатор аватаров (256x256 JPEG Quality 80) в пакете `storage`, защищенные эндпоинты `POST /api/v1/users/me/avatar` (валидация MIME и размера 5 МБ) и `DELETE /api/v1/users/me/avatar`.
- **Frontend (Vue 3 / TypeScript / Tailwind CSS / Bun)**: Tailwind CSS для стилизации и токенов дизайн-системы («Culinary Modern»: теплый молочный фон `#FAF8F5`, глубокий шеф-зеленый `#1E392A`, сквирклы 18-20px), виртуальный скроллер `@tanstack/vue-virtual` для каталога с динамическим замером высоты, адаптивные бейджи готовности в `RecipeCard.vue`, загрузка аватара с офлайн-инициалами, калькулятор порций `servings.ts` и тактильный отклик `haptics.ts`.

**Tech Stack:** Go 1.22+, Gin, PostgreSQL 16+, SQLC, Vue 3, TypeScript, Bun, Vite, Tailwind CSS, Lucide Icons, `@tanstack/vue-virtual`, Pinia, Vitest, Testify.

**Spec:** Сводка UI/UX аудита v0.7.0 и продуктовые правила [`AGENTS.md`](file:///D:/projects/whatcook/AGENTS.md).

## Global Constraints

- **Пакетный менеджер**: Строго Bun (`bun add`, `bun test`, `bun run type-check`, `bun run build`). Никогда не использовать `npm` или `pnpm`.
- **Строгий TypeScript и DTO**: Вся интеграция строго через DTO (`internal/dto`) и типизированные интерфейсы TypeScript. Никаких `any`.
- **Mobile-First UX**: Минимальные сенсорные зоны 44x44px, идеальный рендеринг на узких экранах смартфонов от 360px.
- **Офлайн-надежность**: Никаких внешних CDN (изображения аватара и иконки полностью локализованы). При отсутствии сети или фото — рендеринг локальных инициалов.
- **Версионирование**: Перед фиксацией ветки поднять версию приложения до `v0.8.0` в `frontend/package.json` и `frontend/src/views/ProfileView.vue`.
- **Ветка разработки**: Все изменения ведутся в ветке `feat/f20-modern-ui-and-virtual-scroll`.

## Review Focus

1. **Безопасность загрузки аватара**: Защита от path traversal, лимит файла 5 МБ, строгая проверка `image/jpeg`, `image/png`, `image/webp`.
2. **Плавность виртуального скролла**: `@tanstack/vue-virtual` должен корректно измерять высоту карточек с разным количеством строк и тегов без скачков скролла при lazy-loading изображений.
3. **Корректный сброс виртуального скролла**: При смене вкладки, фильтров времени/сложности или поискового запроса виртуальный скроллер должен мгновенно сбрасываться к началу (`scrollToIndex(0)`).
4. **Дробные числа в калькуляторе порций**: При пересчете (например, 1 яйцо на 3 порции или 250 г на 3 порции) значения должны красиво форматироваться (округление до 1 знака или целого), без бесконечных дробей и `NaN`.
5. **Безопасность Haptic Feedback**: На устройствах без поддержки `navigator.vibrate` (iOS Safari, десктоп) вызов не должен выбрасывать исключений.

---

### Task 1: Бэкенд: Схема БД, хранилище и эндпоинты аватара пользователя

**Files:**
- Create: `backend/migrations/000004_user_avatar.up.sql`
- Create: `backend/migrations/000004_user_avatar.down.sql`
- Modify: `backend/queries/users.sql:1-25`
- Modify: `backend/internal/store/users.sql.go`
- Modify: `backend/internal/storage/storage.go`
- Modify: `backend/internal/storage/storage_test.go`
- Modify: `backend/internal/dto/user.go`
- Modify: `backend/internal/handler/user.go`
- Modify: `backend/internal/handler/user_test.go`
- Modify: `backend/internal/server/server.go`

**Interfaces:**
- Produces:
  - `POST /api/v1/users/me/avatar` (multipart file -> `{"avatar_url": "/uploads/avatars/..."}`)
  - `DELETE /api/v1/users/me/avatar` (`204 No Content`)
  - `UserResponse.AvatarURL *string`

- [ ] **Step 1: Создать миграцию `000004_user_avatar`**

```sql
-- backend/migrations/000004_user_avatar.up.sql
ALTER TABLE users ADD COLUMN avatar_url TEXT;

-- backend/migrations/000004_user_avatar.down.sql
ALTER TABLE users DROP COLUMN IF EXISTS avatar_url;
```

- [ ] **Step 2: Добавить запрос обновления аватара в `backend/queries/users.sql`**

```sql
-- name: UpdateUserAvatar :one
UPDATE users
SET avatar_url = $2, updated_at = NOW()
WHERE id = $1
RETURNING id, email, password_hash, name, token_version, excluded_ingredient_ids, pantry_ingredient_ids, avatar_url, created_at, updated_at;
```

Запустить генерацию SQLC: `cd backend && sqlc generate`.

- [ ] **Step 3: Написать модульный тест для `OptimizeAvatarImage` в `backend/internal/storage/storage_test.go`**

```go
func TestOptimizeAvatarImage(t *testing.T) {
    // Тест проверяет, что входящее изображение масштабируется до квадрата 256x256 в формате JPEG
}
```

- [ ] **Step 4: Реализовать `OptimizeAvatarImage` в `backend/internal/storage/storage.go`**

Билинейное масштабирование до 256x256 и сжатие JPEG Quality 80 в папку `backend/uploads/avatars/`.

- [ ] **Step 5: Реализовать хэндлеры `UploadAvatar` и `DeleteAvatar` в `backend/internal/handler/user.go`**

Валидация MIME (`image/jpeg`, `image/png`, `image/webp`), размера (5 МБ), вызов `storage.Save` и обновление БД через `store.UpdateUserAvatar`.

- [ ] **Step 6: Зарегистрировать эндпоинты в `backend/internal/server/server.go` и прогнать тесты**

```go
userGroup.POST("/me/avatar", userHandler.UploadAvatar)
userGroup.DELETE("/me/avatar", userHandler.DeleteAvatar)
```
Run: `cd backend && go test ./... && go vet ./...`
Expected: PASS

- [ ] **Step 7: Коммит**

```bash
git add backend/
git commit -m "feat(user): add user avatar database migration, storage optimizer and api endpoints"
```

---

### Task 2: Фронтенд: Подключение Tailwind CSS, Lucide Icons и `@tanstack/vue-virtual`

**Files:**
- Modify: `frontend/package.json`
- Create: `frontend/tailwind.config.js`
- Create: `frontend/postcss.config.js`
- Modify: `frontend/src/assets/main.css`

**Interfaces:**
- Produces: Tailwind utility-классы, Lucide иконки и `@tanstack/vue-virtual` в среде Bun.

- [ ] **Step 1: Установить зависимости через Bun**

Run: `cd frontend && bun add tailwindcss postcss autoprefixer lucide-vue-next @tanstack/vue-virtual`
Run: `cd frontend && bun add -d @types/node`

- [ ] **Step 2: Создать `frontend/postcss.config.js` и `frontend/tailwind.config.js`**

```javascript
// frontend/tailwind.config.js
export default {
  content: ['./index.html', './src/**/*.{vue,js,ts,jsx,tsx}'],
  theme: {
    extend: {
      colors: {
        culinary: {
          bg: '#FAF8F5',
          card: '#FFFFFF',
          primary: '#1E392A',
          primaryLight: '#2D5A43',
          accent: '#E67E22',
          accentMuted: '#FFF8F0',
          border: '#EBE7DF',
          textMain: '#1A1C19',
          textMuted: '#71766F'
        }
      },
      borderRadius: {
        'squircle-sm': '12px',
        'squircle-md': '18px',
        'squircle-lg': '24px'
      },
      boxShadow: {
        'soft': '0 4px 20px -2px rgba(26, 28, 25, 0.05)',
        'elevated': '0 10px 30px -4px rgba(26, 28, 25, 0.08)'
      }
    }
  },
  plugins: []
}
```

- [ ] **Step 3: Подключить Tailwind директивы в `frontend/src/assets/main.css`**

```css
@tailwind base;
@tailwind components;
@tailwind utilities;
```
Настроить фон приложения: `body { background-color: #F0ECE4; }`, `.mobile-container { background-color: #FAF8F5; }`.

- [ ] **Step 4: Проверить сборку фронтенда**

Run: `cd frontend && bun run type-check && bun test`
Expected: PASS

- [ ] **Step 5: Коммит**

```bash
git add frontend/
git commit -m "feat(ui): setup tailwind css, lucide icons and tanstack virtual scroller"
```

---

### Task 3: Фронтенд: Загрузка аватара и автономный генератор инициалов

**Files:**
- Create: `frontend/src/utils/avatar.ts`
- Test: `frontend/src/utils/avatar.test.ts`
- Modify: `frontend/src/api/user.ts`
- Modify: `frontend/src/stores/auth.ts`
- Modify: `frontend/src/views/ProfileView.vue`

**Interfaces:**
- Produces:
  ```typescript
  export function getInitials(name?: string | null): string
  export function getAvatarColor(name?: string | null): string
  ```

- [ ] **Step 1: Написать падающий тест для `getInitials` и `getAvatarColor`**

```typescript
// frontend/src/utils/avatar.test.ts
import { describe, it, expect } from 'vitest'
import { getInitials, getAvatarColor } from './avatar'

describe('avatar utility', () => {
  it('returns fallback question mark for empty name', () => {
    expect(getInitials('')).toBe('?')
    expect(getInitials(null)).toBe('?')
  })

  it('extracts initials from single and multi-word names', () => {
    expect(getInitials('Иван Петров')).toBe('ИП')
    expect(getInitials('Chef')).toBe('C')
  })

  it('generates consistent color', () => {
    expect(getAvatarColor('Иван')).toBe(getAvatarColor('Иван'))
    expect(getAvatarColor('Иван')).toMatch(/^#[0-9a-f]{6}$/i)
  })
})
```

- [ ] **Step 2: Запустить тест и убедиться в ошибке**

Run: `cd frontend && bun test src/utils/avatar.test.ts`
Expected: FAIL

- [ ] **Step 3: Реализовать `frontend/src/utils/avatar.ts`**

Реализовать функции генерации инициалов и детерминированного цвета из теплой кулинарной палитры.

- [ ] **Step 4: Добавить API вызовы `uploadAvatarApi` и `deleteAvatarApi` в `src/api/user.ts` и `stores/auth.ts`**

Методы загрузки файла на сервер и синхронизации поля `user.avatar_url`.

- [ ] **Step 5: Обновить компонент `ProfileView.vue`**

- Удалить внешнюю ссылку на `cat.jpeg`.
- Оформить аватар в современном стиле: круглое фото с мягкой тенью, кнопка с иконкой камеры поверх аватара, выбор файла через скрытый `<input type="file" accept="image/jpeg,image/png,image/webp">` с мгновенным локальным превью.
- При отсутствии фото или офлайн — отображение стильного круга с инициалами `getInitials(user.name)`.

- [ ] **Step 6: Прогнать тесты и проверку типов**

Run: `cd frontend && bun test src/utils/avatar.test.ts && bun run type-check`
Expected: PASS

- [ ] **Step 7: Коммит**

```bash
git add frontend/src/utils/avatar.ts frontend/src/utils/avatar.test.ts frontend/src/api/user.ts frontend/src/stores/auth.ts frontend/src/views/ProfileView.vue
git commit -m "feat(profile): implement custom avatar upload and offline initials avatar"
```

---

### Task 4: Адаптивная 3-уровневая система бейджей готовности рецепта (RecipeCard)

**Files:**
- Modify: `frontend/src/components/recipes/RecipeCard.vue`
- Test: `frontend/src/stores/recipe.test.ts`

**Interfaces:**
- Consumes: `matchItem` (`match_percentage`, `can_cook_now`, `missing_ingredients`)
- Produces: 3 уровня оформления карточки:
  - `ready` (100% готовность): зеленая окантовка `border-2 border-emerald-700`, бейдж `✓ Можно готовить`.
  - `almost` (не хватает 1 продукта): янтарный бейдж `🟡 1 докупить` с названием недостающего ингредиента.
  - `partial` (частичное совпадение): нейтральный бейдж процента.

- [ ] **Step 1: Реализовать вычисляемое свойство `readinessTier` в `RecipeCard.vue`**

```typescript
const readinessTier = computed<'ready' | 'almost' | 'partial' | 'none'>(() => {
  if (!props.matchItem) return 'none'
  if (props.matchItem.can_cook_now || props.matchItem.match_percentage === 100) return 'ready'
  if (props.matchItem.missing_ingredients.length === 1 || props.matchItem.match_percentage >= 80) return 'almost'
  return 'partial'
})
```

- [ ] **Step 2: Оформить карточку с использованием Tailwind сквирклов и бейджей**

- Скругления `rounded-squircle-md` (18px), мягкая тень `shadow-soft`.
- Бейдж `ready`: `bg-emerald-800 text-white font-semibold`.
- Бейдж `almost`: `bg-amber-50 text-amber-900 border border-amber-200/60 font-medium`.
- При `readinessTier === 'ready'` — карточка подсвечивается акцентной окантовкой.

- [ ] **Step 3: Прогнать проверку типов и тесты**

Run: `cd frontend && bun run type-check && bun test`
Expected: PASS

- [ ] **Step 4: Коммит**

```bash
git add frontend/src/components/recipes/RecipeCard.vue
git commit -m "feat(recipes): implement 3-tier readiness badges and card highlights"
```

---

### Task 5: Виртуализированный скролл каталога на `@tanstack/vue-virtual`

**Files:**
- Modify: `frontend/src/views/RecipesView.vue`
- Modify: `frontend/src/stores/recipe.ts`

**Interfaces:**
- Consumes: `useVirtualizer` из `@tanstack/vue-virtual`, `recipeStore.allRecipes`
- Produces: 60fps виртуальный рендеринг каталога рецептов внутри скролл-контейнера `.content-wrapper`.

- [ ] **Step 1: Настроить подгрузку рецептов в `stores/recipe.ts`**

Метод `loadAllRecipes` поддерживает сквозную загрузку страниц без очистки массива, пока `allRecipes.length < totalCount`.

- [ ] **Step 2: Интегрировать `useVirtualizer` в `RecipesView.vue`**

```typescript
import { useVirtualizer } from '@tanstack/vue-virtual'

const parentRef = ref<HTMLElement | null>(null)

const rowVirtualizer = useVirtualizer({
  get count() {
    return recipeStore.allRecipes.length
  },
  getScrollElement: () => document.querySelector('.content-wrapper') as HTMLElement,
  estimateSize: () => 320, // примерная высота карточки
  overscan: 2
})
```

- [ ] **Step 3: Настроить разметку виртуального контейнера**

```html
<div
  ref="parentRef"
  class="relative w-full"
  :style="{ height: `${rowVirtualizer.getTotalSize()}px` }"
>
  <div
    v-for="virtualRow in rowVirtualizer.getVirtualItems()"
    :key="virtualRow.key"
    :ref="rowVirtualizer.measureElement"
    :data-index="virtualRow.index"
    class="absolute top-0 left-0 w-full pb-3"
    :style="{ transform: `translateY(${virtualRow.start}px)` }"
  >
    <RecipeCard :recipe="recipeStore.allRecipes[virtualRow.index]" />
  </div>
</div>
```

- [ ] **Step 4: Автодогрузка при скролле к последним элементам**

Когда последний видимый виртуальный элемент приближается к концу списка (`virtualRow.index >= recipeStore.allRecipes.length - 3`), вызывать загрузку следующей порции с бэкенда.

- [ ] **Step 5: Прогнать тесты и сборку**

Run: `cd frontend && bun run type-check && bun test`
Expected: PASS

- [ ] **Step 6: Коммит**

```bash
git add frontend/src/stores/recipe.ts frontend/src/views/RecipesView.vue
git commit -m "feat(recipes): implement high-performance virtual scrolling via tanstack virtual"
```

---

### Task 6: Калькулятор порций (Serving Scaler) в деталях рецепта

**Files:**
- Create: `frontend/src/utils/servings.ts`
- Test: `frontend/src/utils/servings.test.ts`
- Modify: `frontend/src/views/RecipeDetailView.vue`

**Interfaces:**
- Produces:
  ```typescript
  export function scaleAmount(baseAmount: number | null | undefined, baseServings: number, targetServings: number): number | null
  export function formatScaledAmount(amount: number | null | undefined, unit: string | null | undefined, displayText?: string | null, baseServings?: number, targetServings?: number): string
  ```

- [ ] **Step 1: Написать падающий тест для `scaleAmount` и `formatScaledAmount`**

```typescript
// frontend/src/utils/servings.test.ts
import { describe, it, expect } from 'vitest'
import { scaleAmount, formatScaledAmount } from './servings'

describe('servings utility', () => {
  it('handles null amounts', () => {
    expect(scaleAmount(null, 2, 4)).toBeNull()
  })

  it('scales numbers proportionally and rounds to 1 decimal place', () => {
    expect(scaleAmount(200, 2, 4)).toBe(400)
    expect(scaleAmount(100, 3, 2)).toBe(66.7)
  })

  it('formats display text without breaking', () => {
    expect(formatScaledAmount(200, 'г', null, 2, 4)).toBe('400 г')
    expect(formatScaledAmount(null, null, 'По вкусу', 2, 4)).toBe('По вкусу')
  })
})
```

- [ ] **Step 2: Запустить тест и убедиться в ошибке**

Run: `cd frontend && bun test src/utils/servings.test.ts`
Expected: FAIL

- [ ] **Step 3: Реализовать `frontend/src/utils/servings.ts`**

Реализовать функции с защитой от деления на ноль и красивым округлением.

- [ ] **Step 4: Внедрить степпер порций в `RecipeDetailView.vue`**

В блоке мета-информации рецепта добавить интерактивный селектор порций `[-] N порций [+]` и применить `formatScaledAmount` к спискам ингредиентов.

- [ ] **Step 5: Прогнать тесты и проверку типов**

Run: `cd frontend && bun test src/utils/servings.test.ts && bun run type-check`
Expected: PASS

- [ ] **Step 6: Коммит**

```bash
git add frontend/src/utils/servings.ts frontend/src/utils/servings.test.ts frontend/src/views/RecipeDetailView.vue
git commit -m "feat(recipes): add dynamic serving size scaler for ingredient amounts"
```

---

### Task 7: Плавающий мини-таймер и тактильный отклик (Haptics)

**Files:**
- Create: `frontend/src/utils/haptics.ts`
- Test: `frontend/src/utils/haptics.test.ts`
- Modify: `frontend/src/components/recipes/CookingTimer.vue`
- Modify: `frontend/src/views/RecipeDetailView.vue`
- Modify: `frontend/src/components/shopping/ShoppingItemCard.vue`

**Interfaces:**
- Produces:
  ```typescript
  export function triggerHaptic(type?: 'light' | 'medium' | 'success'): boolean
  ```

- [ ] **Step 1: Написать тест и реализовать безопасную утилиту `triggerHaptic`**

- `frontend/src/utils/haptics.ts`: безопасная проверка `typeof navigator !== 'undefined' && 'vibrate' in navigator`.
- Подключить `triggerHaptic('light')` при отметке чекбокса в `ShoppingItemCard.vue`.
- Подключить `triggerHaptic('success')` при окончании таймера в `CookingTimer.vue`.

- [ ] **Step 2: Экспортировать состояние из `CookingTimer.vue` и добавить плавающий бейдж**

В `RecipeDetailView.vue`: когда таймер активен, но пользователь проскроллил экран ниже блока таймера, в правом нижнем углу всплывает плавающая кнопка `⏱️ MM:SS`. Тап по ней плавно скроллит к таймеру.

- [ ] **Step 3: Прогнать тесты и проверку типов**

Run: `cd frontend && bun test src/utils/haptics.test.ts && bun run type-check`
Expected: PASS

- [ ] **Step 4: Коммит**

```bash
git add frontend/src/utils/haptics.ts frontend/src/utils/haptics.test.ts frontend/src/components/recipes/CookingTimer.vue frontend/src/views/RecipeDetailView.vue frontend/src/components/shopping/ShoppingItemCard.vue
git commit -m "feat(ux): add floating mini-timer and safe haptic feedback"
```

---

### Task 8: Список покупок: сворачивание купленного и бейджи на таббаре

**Files:**
- Modify: `frontend/src/views/ShoppingView.vue`
- Modify: `frontend/src/components/layout/AppTabBar.vue`

- [ ] **Step 1: Добавить сворачиваемый аккордеон «Куплено (N)» в `ShoppingView.vue`**

Купленные товары перемещаются вниз в сворачиваемый блок с мягкой плашкой, очищая рабочее пространство для фокуса на покупках в магазине.

- [ ] **Step 2: Подключить реактивные бейджи в `AppTabBar.vue`**

- Количество оставшихся покупок на табе «Покупки».
- Точка на табе «Холодильник» при наличии скоропортящихся продуктов.

- [ ] **Step 3: Прогнать проверку типов и тесты**

Run: `cd frontend && bun run type-check && bun test`
Expected: PASS

- [ ] **Step 4: Коммит**

```bash
git add frontend/src/views/ShoppingView.vue frontend/src/components/layout/AppTabBar.vue
git commit -m "feat(shopping): collapse bought items and add reactive tabbar badges"
```

---

### Task 9: Версионирование (v0.8.0), сквозная верификация и документация

**Files:**
- Modify: `frontend/package.json:3`
- Modify: `frontend/src/views/ProfileView.vue:220`
- Modify: `docs/roadmap.md`

- [ ] **Step 1: Обновить версию приложения до `v0.8.0`**

- В `frontend/package.json`: `"version": "0.8.0"`
- В `frontend/src/views/ProfileView.vue`: `value="WhatCook v0.8.0"`

- [ ] **Step 2: Запустить сквозные тесты бэкенда и фронтенда**

Run:
1. `cd backend && go test ./... && go vet ./...` (Expected: PASS, 0 ошибок)
2. `cd frontend && bun run type-check` (Expected: 0 ошибок)
3. `cd frontend && bun test` (Expected: все тесты пройдены)
4. `cd frontend && bun run build` (Expected: сборка успешна)

- [ ] **Step 3: Зафиксировать статус этапа в `docs/roadmap.md`**

Добавить запись о реализации современного дизайн-кода, виртуального скролла и загрузки аватара в v0.8.0.

- [ ] **Step 4: Финальный коммит этапа**

```bash
git add frontend/package.json frontend/src/views/ProfileView.vue docs/roadmap.md
git commit -m "chore: bump version to v0.8.0 and update roadmap with modern ui and virtual scroll"
```
