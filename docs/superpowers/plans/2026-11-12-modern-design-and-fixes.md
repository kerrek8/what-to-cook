# Редизайн UI, фильтрация подбора >60%, виртуальный скролл и багфиксы Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Полный визуальный редизайн карточек и списков рецептов под современный кулинарный стиль, фильтрация вкладки «Что приготовить» по порогу совпадения >60% с бесконечным скроллом, быстрый скролл наверх по тапу на таббар, устранение бага фоновой реактивности бейджей и починка плавающего мини-таймера.

**Architecture:** 
1. Глобальная реактивность бейджей через немедленную инициализацию `inventoryStore` и `shoppingStore` в `App.vue` и авто-рефреш при `addMissingToShopping`.
2. Починка плавающего таймера в `RecipeDetailView.vue` через событийную модель `@update:running` из `CookingTimer.vue` и надежный скролл-трекинг `getBoundingClientRect()`.
3. Порог `match_percentage > 60` в `stores/recipe.ts` и виртуализированный бесконечный скролл вкладки «Что приготовить» в `RecipesView.vue`.
4. Скролл наверх при повторном клике на таб «Рецепты» в `AppTabBar.vue`.
5. Полная стилизация `RecipeCard.vue` и сопутствующих компонентов на современном Tailwind/CSS стеке.

**Tech Stack:** Vue 3, Pinia, TypeScript, Tailwind CSS v3, Lucide Icons, `@tanstack/vue-virtual`, Vant UI.

**Spec:** Запрос пользователя от 2026-11-12 на редизайн и исправление 4 проблем взаимодействия.

## Global Constraints

- Сохранять строгую типизацию TypeScript и прохождение всех тестов (`bun run type-check && bun run test`).
- Mobile-first: touch-зоны не менее 44x44px.
- Безопасная работа без интернета и при отсутствии сенсоров/вибрации.

## Review Focus

1. Проверка обновления бейджа корзины при добавлении ингредиентов из рецепта без перезагрузки страницы.
2. Проверка всплытия плавающего таймера при запуске и скролле рецепта вниз на мобильных экранах.
3. Проверка отсечения рецептов с совпадением <= 60% во вкладке «Что приготовить».
4. Проверка скролла к началу страницы при повторном тапе по кнопке «Рецепты» в нижнем таббаре.
5. Проверка сохранения высокой производительности и отсутствия лагов при виртуальном скролле совпадений.

---

### Task 1: Глобальная реактивность бейджей таббара и авто-обновление корзины

**Files:**
- Modify: `frontend/src/App.vue:1-38`
- Modify: `frontend/src/views/RecipeDetailView.vue:185-200`
- Modify: `frontend/src/stores/shopping.test.ts`

**Interfaces:**
- Consumes: `shoppingStore.loadItems(force?: boolean)`, `inventoryStore.loadInventory()`
- Produces: актуальные счетчики `pendingShoppingCount` и `hasExpiringProducts` сразу при старте приложения и немедленно после добавления ингредиентов из деталей рецепта.

- [ ] **Step 1: Написать тест в `stores/shopping.test.ts` на фоновое обновление счетчика**

```typescript
it('updates pending count when items are reloaded after external recipe addition', async () => {
  const store = useShoppingStore()
  expect(store.items).toHaveLength(0)
  vi.mocked(shoppingApi.getShoppingListApi).mockResolvedValueOnce({
    items: [
      { id: 1, name: 'Мука', amount: 500, unit: 'г', is_bought: false, category: 'Бакалея', created_at: '' }
    ]
  })
  await store.loadItems(true)
  expect(store.items).toHaveLength(1)
  expect(store.items.filter(i => !i.isBought)).toHaveLength(1)
})
```

- [ ] **Step 2: Запустить тест и убедиться в успехе базовой логики**

Run: `cd frontend && bun test src/stores/shopping.test.ts`
Expected: PASS

- [ ] **Step 3: Внедрить инициализацию в `frontend/src/App.vue`**

В `App.vue`:
```typescript
onMounted(() => {
  window.addEventListener('online', onOnline)
  inventoryStore.loadInventory()
  shoppingStore.loadItems()
})
```

- [ ] **Step 4: Добавить вызов `shoppingStore.loadItems(true)` в `RecipeDetailView.vue`**

В функции `addMissingIngredients`:
```typescript
await recipeStore.addMissingToShopping(recipe.value.id)
await shoppingStore.loadItems(true)
```

- [ ] **Step 5: Прогнать тесты и проверку типов**

Run: `cd frontend && bun run type-check && bun run test`
Expected: PASS

- [ ] **Step 6: Коммит**

```bash
git add frontend/src/App.vue frontend/src/views/RecipeDetailView.vue frontend/src/stores/shopping.test.ts
git commit -m "fix(shopping): eagerly load store items and reactively refresh badge on recipe additions"
```

---

### Task 2: Починка плавающего мини-таймера при скролле

**Files:**
- Modify: `frontend/src/components/recipes/CookingTimer.vue`
- Modify: `frontend/src/views/RecipeDetailView.vue`

**Interfaces:**
- Consumes: события таймера `@status-change="(running: boolean, formattedTime: string) => void"`
- Produces: гарантированно видимая плавающая плашка таймера `⏱️ MM:SS` в правом нижнем углу при работающем таймере вне зоны видимости.

- [ ] **Step 1: Добавить эмит статуса в `CookingTimer.vue`**

```typescript
const emit = defineEmits<{
  (e: 'close'): void
  (e: 'status-change', status: { isRunning: boolean; formattedTime: string }): void
}>()

// Вызывать emit('status-change', { isRunning: isRunning.value, formattedTime: formattedTime.value })
// при старте, паузе, тике (watch remainingSeconds) и сбросе
```

- [ ] **Step 2: В `RecipeDetailView.vue` перевести видимость таймера на реактивное локальное состояние**

```typescript
const activeTimerState = ref<{ isRunning: boolean; formattedTime: string }>({
  isRunning: false,
  formattedTime: '00:00'
})

function onTimerStatusChange(status: { isRunning: boolean; formattedTime: string }) {
  activeTimerState.value = status
}
```

- [ ] **Step 3: Реализовать надежный scroll-трекер на контейнере контента**

Вместо капризного `IntersectionObserver` с фиксированным рутом, слушать событие `scroll` на `.content-wrapper` (с троттлингом через `requestAnimationFrame`):
```typescript
function updateTimerVisibility() {
  if (!timerSectionRef.value) {
    isTimerOutOfView.value = false
    return
  }
  const rect = timerSectionRef.value.getBoundingClientRect()
  // Таймер скрылся за верхнюю границу или еще не доскроллен
  isTimerOutOfView.value = rect.bottom < 60 || rect.top > window.innerHeight
}
```

- [ ] **Step 4: Проверить условие отображения кнопки в шаблоне**

```html
<button
  v-if="showTimer && activeTimerState.isRunning && isTimerOutOfView"
  type="button"
  class="floating-timer-pill"
  @click="scrollToTimer"
>
  <span class="timer-dot animate-ping"></span>
  <span class="font-mono font-bold">{{ activeTimerState.formattedTime }}</span>
</button>
```

- [ ] **Step 5: Прогнать тесты и проверку типов**

Run: `cd frontend && bun run type-check && bun run test`
Expected: PASS

- [ ] **Step 6: Коммит**

```bash
git add frontend/src/components/recipes/CookingTimer.vue frontend/src/views/RecipeDetailView.vue
git commit -m "fix(timer): ensure floating timer pill reactively tracks timer state and scroll position"
```

---

### Task 3: Вкладка «Что приготовить»: порог совпадения >60% и бесконечный виртуальный скролл

**Files:**
- Modify: `frontend/src/stores/recipe.ts`
- Modify: `frontend/src/stores/recipe.test.ts`
- Modify: `frontend/src/views/RecipesView.vue`

**Interfaces:**
- Consumes: `matchItem.match_percentage > 60`
- Produces: список `filteredMatchedRecipes` с фильтрацией `match_percentage > 60` и виртуализированный бесконечный скролл без пагинации.

- [ ] **Step 1: Написать тест в `stores/recipe.test.ts` на отсечение рецептов <= 60%**

```typescript
it('filters matched recipes by threshold > 60% match percentage', () => {
  const store = useRecipeStore()
  store.matchedRecipes = [
    {
      recipe: { ...mockRecipe, id: 1 },
      match_percentage: 75,
      total_ingredients: 4,
      available_count: 3,
      used_ingredients: [],
      missing_ingredients: [],
      can_cook_now: false
    },
    {
      recipe: { ...mockRecipe, id: 2 },
      match_percentage: 50,
      total_ingredients: 4,
      available_count: 2,
      used_ingredients: [],
      missing_ingredients: [],
      can_cook_now: false
    }
  ]
  expect(store.filteredMatchedRecipes).toHaveLength(1)
  expect(store.filteredMatchedRecipes[0].recipe.id).toBe(1)
})
```

- [ ] **Step 2: Запустить тест и убедиться в падении**

Run: `cd frontend && bun test src/stores/recipe.test.ts`
Expected: FAIL

- [ ] **Step 3: Реализовать фильтрацию `match_percentage > 60` в `stores/recipe.ts`**

```typescript
const filteredMatchedRecipes = computed(() => {
  return matchedRecipes.value.filter(
    (item) => item.match_percentage > 60 && filterMatched(item.recipe, item.used_ingredients)
  )
})
```

- [ ] **Step 4: Запустить тест и убедиться в прохождении**

Run: `cd frontend && bun test src/stores/recipe.test.ts`
Expected: PASS

- [ ] **Step 5: Внедрить виртуализированный рендеринг для вкладки «Что приготовить» в `RecipesView.vue`**

- Использовать `useVirtualizer` для вкладки совпадений (или единый виртуализатор с динамическим `count` в зависимости от `activeTab`).
- Удалить устаревший блок `<van-pagination>` из таба `match`.
- Обеспечить плавную прокрутку сотен карточек на 60fps.

- [ ] **Step 6: Прогнать тесты и проверку типов**

Run: `cd frontend && bun run type-check && bun run test`
Expected: PASS

- [ ] **Step 7: Коммит**

```bash
git add frontend/src/stores/recipe.ts frontend/src/stores/recipe.test.ts frontend/src/views/RecipesView.vue
git commit -m "feat(recipes): filter matched recipes above 60% and enable virtual infinite scroll"
```

---

### Task 4: Быстрый возврат к началу списка (Скролл вверх при нажатии на «Рецепты»)

**Files:**
- Modify: `frontend/src/components/layout/AppTabBar.vue`

**Interfaces:**
- Consumes: клик по таббар-элементу «Рецепты»
- Produces: плавный скролл `.content-wrapper` к `top: 0`, если пользователь уже находится на `/recipes`.

- [ ] **Step 1: Реализовать функцию `handleRecipesTabClick` в `AppTabBar.vue`**

```typescript
function handleRecipesTabClick() {
  if (route.path === '/recipes') {
    const scrollContainer = document.querySelector('.content-wrapper')
    if (scrollContainer) {
      scrollContainer.scrollTo({ top: 0, behavior: 'smooth' })
    }
  }
}
```

- [ ] **Step 2: Подключить `@click="handleRecipesTabClick"` к `<van-tabbar-item to="/recipes">`**

- [ ] **Step 3: Прогнать тесты и проверку типов**

Run: `cd frontend && bun run type-check && bun run test`
Expected: PASS

- [ ] **Step 4: Коммит**

```bash
git add frontend/src/components/layout/AppTabBar.vue
git commit -m "feat(navigation): scroll recipes list to top on tabbar item click"
```

---

### Task 5: Радикальный редизайн карточки рецепта и каталога (по выбранному стилю)

**Files:**
- Modify: `frontend/src/components/recipes/RecipeCard.vue`
- Modify: `frontend/src/views/RecipesView.vue`
- Modify: `frontend/src/assets/main.css`

**Interfaces:**
- Consumes: утвержденная цветовая палитра, типографика и геометрия карточки из выбранного варианта дизайна.
- Produces: современный, эстетичный и премиальный внешний вид каталога и карточек рецептов.

- [ ] **Step 1: Применить выбранные дизайн-токены в `RecipeCard.vue`**
- Карточки с современным радиусом (16-20px), обновленными тенями `shadow-sm hover:shadow-md`.
- Соотношение фото 16:9 или 4:3 с мягким затемняющим градиентом.
- Стеклянные бейджи готовности (матовый Glassmorphism) с читаемым контрастным текстом.
- Выразительная типографика названия и времени приготовления с Lucide иконками (`Clock`, `ChefHat`, `Sparkles`).

- [ ] **Step 2: Обновить чипы фильтров и вкладки каталога в `RecipesView.vue`**
- Модернизировать табы переключения режимов («Что приготовить», «Все рецепты», «Избранное») с мягким фоном-подложкой (Segmented Control).
- Освежить чипы фильтров по времени и сложности.

- [ ] **Step 3: Прогнать тесты и проверить сборку**

Run: `cd frontend && bun run type-check && bun run test && bun run build`
Expected: PASS

- [ ] **Step 4: Коммит**

```bash
git add frontend/src/components/recipes/RecipeCard.vue frontend/src/views/RecipesView.vue frontend/src/assets/main.css
git commit -m "style(recipes): modernize recipe card and catalog UI according to selected design system"
```

---

### Task 6: Релиз v0.8.1 и актуализация документации

**Files:**
- Modify: `frontend/package.json`
- Modify: `frontend/src/views/ProfileView.vue`
- Modify: `docs/roadmap.md`

- [ ] **Step 1: Обновить версию до `v0.8.1`**
- [ ] **Step 2: Запустить сквозные тесты бэкенда и фронтенда**
- [ ] **Step 3: Зафиксировать статус этапа в `docs/roadmap.md`**
- [ ] **Step 4: Финальный коммит**

```bash
git add frontend/package.json frontend/src/views/ProfileView.vue docs/roadmap.md
git commit -m "chore(release): bump version to v0.8.1 and finalize modern ui fixes"
```
