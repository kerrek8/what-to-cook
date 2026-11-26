# Реестр замечаний и улучшений WhatCook (Android Mobile PWA)

> **Контекст продукта**: WhatCook — это **строго мобильное PWA-приложение для платформы Android** (`display: standalone`, запуск через движок Android Chromium / Chrome). 
> Приложение проектируется под экраны современных Android-смартфонов, управление одной рукой, жестовую системную навигацию Android (Back gesture), работу в режиме офлайн и специфический кухонный сценарий (hands-free, телефон на подставке/столе, мокрые руки). Поддержка десктопных браузеров и iOS на данном этапе не предполагается.

> ### ⚠️ Статус и роль дизайн-макета (`docs/design-system/preview.html`)
> Интерактивный HTML-прототип и макет (`preview.html`) служат **ориентировочным визуальным гайдом** для демонстрации выбранной цветовой темы (Warm Editorial), общей компоновки экранов и настроения UI.
> 
> **Макет не является догмой, идеалом или строгой спецификацией «пиксель-в-пиксель». В коде приложения не следует слепо воспроизводить каждую деталь или артефакт верстки прототипа.**
> 
> Реализация в коде должна в первую очередь опираться на:
> 1. Реальную архитектуру компонентов Vue 3 и существующую структуру данных приложения.
> 2. Эргономику реального мобильного взаимодействия на Android (тач-таргеты от 48dp, свайпы, системная навигация).
> 3. Здравый смысл и удобство пользователя: если в реальном приложении элемент работает логичнее или чище, чем набросано в прототипе — приоритет отдается надежному инженерному решению, а не слепому копированию макета.

Документ содержит полный перечень выявленных проблем, багов, эргономических недочетов и мест для полировки с привязкой к архитектуре Android PWA и согласованной дизайн-системе.

---

## Содержание

1. [Android PWA Shell, мета-теги и системные панели](#1-android-pwa-shell-мета-теги-и-системные-панели)
2. [Критические функциональные баги и логические ошибки](#2-критические-функциональные-баги-и-логические-ошибки)
3. [Android-эргономика, тач-таргеты (Material 48dp) и A11y](#3-android-эргономика-тач-таргеты-material-48dp-и-a11y)
4. [Сценарий «Кухня и готовка» (Cook Mode на Android)](#4-сценарий-кухня-и-готовка-cook-mode-на-android)
5. [Системная навигация Android (Back Gesture) и жесты](#5-системная-навигация-android-back-gesture-и-жесты)
6. [Дизайн-система, верстка и адаптация под экраны Android](#6-дизайн-система-верстка-и-адаптация-под-экраны-android)
7. [Чистота кода и устранение мертвого кода](#7-чистота-кода-и-устранение-мертвого-кода)
8. [Бэкенд-стыки и поддержка Android-форматов (WebP)](#8-бэкенд-стыки-и-поддержка-android-форматов-webp)
9. [Сводная матрица задач (Android PWA Focus)](#9-сводная-матрица-задач-android-pwa-focus)

---

## 1. Android PWA Shell, мета-теги и системные панели

### 1.1. Отсутствие флага `interactive-widget=resizes-content` в viewport
* **Файл**: [`frontend/index.html`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/index.html#L8-L10)
* **Проблема**: В Android Chrome при открытии экранной клавиатуры (Gboard, Samsung Keyboard) по умолчанию происходит сжатие видимой области (`resize`), либо клавиатура перекрывает нижние шторки ввода (`BaseBottomSheet`). Без явного указания режима поведения виртуальной клавиатуры Android интерфейс шторок скроллится некорректно.
* **Решение**: Добавить в мета-тег `viewport` директиву `interactive-widget=resizes-content`:
  ```html
  <meta
    name="viewport"
    content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no, viewport-fit=cover, interactive-widget=resizes-content"
  />
  ```

### 1.2. Управление цветом Status Bar и Navigation Bar в Android
* **Файлы**:
  * [`frontend/index.html`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/index.html#L13)
  * [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue#L27-L35)
* **Проблема**: В `index.html` жестко зашит `theme-color` `#FFFFFF`. В `CookModeView` цвет меняется на `#061811`, но системная нижняя полоса навигации Android (3-кнопочная или жестовая полоска) в манифесте не синхронизирована с цветом темы.
* **Решение**: Убедиться, что в `vite.config.ts` в блоке `manifest` задан `theme_color: '#165337'` (фирменный изумрудный цвет приложения в обычном режиме), а в `CookModeView` динамически переключается мета-тег:
  ```ts
  metaTheme.setAttribute('content', '#061811')
  ```

### 1.3. Коллизия плавающих кнопок (FAB) с системной панелью навигации Android
* **Файлы**:
  * [`frontend/src/views/FridgeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/FridgeView.vue#L165) (`bottom-20`)
  * [`frontend/src/views/ShoppingView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/ShoppingView.vue#L261) (`bottom-20`)
  * [`frontend/src/components/common/ReloadPrompt.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/common/ReloadPrompt.vue#L17) (`bottom-20`)
* **Проблема**: На Android-устройствах с включенной 3-кнопочной навигацией («Назад», «Домой», «Недавние») или высокой панелью жестов `bottom-20` (80px) впритирку наползает на верхнюю кромку таб-бара.
* **Решение**: Рассчитывать отступ плавающей кнопки динамически с учетом safe-area:
  ```html
  class="fixed bottom-[calc(4.5rem+env(safe-area-inset-bottom,0px))] inset-x-0 ..."
  ```

### 1.4. Настройка клавиатуры Android под типы данных (`inputmode` и `enterkeyhint`)
* **Файлы**:
  * [`frontend/src/components/inventory/AddProductSheet.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/AddProductSheet.vue#L298)
  * [`frontend/src/components/shopping/AddShoppingItemSheet.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/shopping/AddShoppingItemSheet.vue#L172)
  * [`frontend/src/views/FridgeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/FridgeView.vue#L68)
* **Проблема**: 
  * В полях веса/количества используется обычный `type="number"`. На клавиатурах Android Gboard это открывает базовый цифровой блок, в котором на некоторых прошивках скрыта запятая/точка для ввода дробных чисел (`0.5 кг`).
  * В полях поиска на клавиатуре отображается стандартная кнопка перехода на новую строку вместо синей кнопки с лупой («Поиск»).
* **Решение**: 
  * Для количества: добавить `inputmode="decimal"`.
  * Для поиска: добавить `enterkeyhint="search"`.
  * Для полей добавления продукта: добавить `enterkeyhint="next"`.

### 1.5. [Исключено из скоупа] Отсутствие визуальной индикации офлайн-режима в шапке
* **Статус**: Исключено по решению пользователя, чтобы не загромождать минималистичную шапку приложения лишними статусами и бейджами.

---

## 2. Критические функциональные баги и логические ошибки

### 2.1. Поломка фильтра «Просрочено» в инвентаре
* **Файлы**:
  * [`frontend/src/components/inventory/FridgeSummaryCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/FridgeSummaryCard.vue#L92)
  * [`frontend/src/stores/inventory.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/stores/inventory.ts#L80-L82)
* **Проблема**: 
  1. В карточке сводки клик по плашке «Просрочено» ошибочно вызывает `@click="onSelect('expiring')"`.
  2. В `inventory.ts` отсутствует ветка фильтра `'expired'`. Значение проваливается в поиск категории `item.category === 'expired'`, из-за чего список всегда пуст.
* **Решение**:
  1. В `FridgeSummaryCard.vue` исправить на `@click="onSelect('expired')"`.
  2. В `inventory.ts` добавить фильтрацию просроченных позиций:
     ```ts
     if (activeCategory.value === 'expired') {
       result = result.filter((item) => {
         if (!item.expirationDate) return false
         return new Date(item.expirationDate) < new Date()
       })
     }
     ```
  3. В `FridgeView.vue` вывести чип-фильтр «⚠️ Просрочено».

### 2.2. Дублирование шапки (Double Header) на экранах авторизации
* **Файлы**:
  * [`frontend/src/router/index.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/router/index.ts#L46-L56)
  * [`frontend/src/views/LoginView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/LoginView.vue#L57)
  * [`frontend/src/views/RegisterView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RegisterView.vue#L64)
* **Проблема**: `LoginView` и `RegisterView` имеют собственный hero-баннер с кнопкой «Назад» и логотипом. В роутере для них не указан `hideHeader: true`. В результате над экраном отображается белая системная шапка `AppHeader` с дублирующей стрелкой «Назад» и текстом «Вход».
* **Решение**: Добавить `hideHeader: true` в мета-данные маршрутов `/login` и `/register`.

### 2.3. Утечка и рассинхронизация `ingredientId` при редактировании названия
* **Файлы**:
  * [`frontend/src/components/inventory/AddProductSheet.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/AddProductSheet.vue#L105-L112)
  * [`frontend/src/components/shopping/AddShoppingItemSheet.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/shopping/AddShoppingItemSheet.vue#L69-L76)
* **Проблема**: Пользователь выбирает из выпадающих подсказок «Сыр пармезан» (`ingredientId = 5`), а затем стирает часть слова и пишет «Сыр Российский». `selectedIngredientId` остается равным 5 и отправляется на сервер, ломая умный алгоритм сопоставления рецептов.
* **Решение**: Добавить сброс ID при ручном изменении текста:
  ```ts
  watch(productName, (newVal) => {
    if (selectedIngredientId.value) {
      const match = catalog.value.find(i => i.id === selectedIngredientId.value)
      if (!match || match.name.toLowerCase() !== newVal.trim().toLowerCase()) {
        selectedIngredientId.value = null
      }
    }
  })
  ```

### 2.4. Ловушка навигации кнопки «Назад» (Hardcoded Redirect)
* **Файл**: [`frontend/src/composables/useBackPressExit.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/composables/useBackPressExit.ts#L66-L68)
* **Проблема**: Если неавторизованный пользователь перешел на логин со страницы рецепта или списка покупок, жест «Назад» на Android принудительно перенаправляет его в `/profile`, игнорируя параметр `route.query.redirect` и исходный экран.
* **Решение**: Проверять `route.query.redirect` перед редиректом на `/profile`.

### 2.5. Карточка «Прогресс покупок» отображается при пустом списке
* **Файл**: [`frontend/src/views/ShoppingView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/ShoppingView.vue#L143)
* **Проблема**: Когда список покупок пуст, пользователь видит карточку «Прогресс покупок: 0 из 0 (0%)», под ней инпут поиска и пустое состояние «Список покупок пуст».
* **Решение**: Добавить `v-if="totalCount > 0"` на блок карточки прогресса.

### 2.6. Мгновенное удаление товара из списка покупок без возможности отмены
* **Файл**: [`frontend/src/components/shopping/ShoppingItemCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/shopping/ShoppingItemCard.vue#L103-L111)
* **Проблема**: В условиях супермаркета случайное касание иконки корзины на ходу сразу безвозвратно удаляет пункт.
* **Решение**: Добавить короткий всплывающий тост с действием «Отмена» (Undo Action).

### 2.7. Неточности в клиентском сопоставлении ингредиентов (Ложные срабатывания)
* **Файл**: [`frontend/src/views/RecipeDetailView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RecipeDetailView.vue#L53-L61)
* **Проблема**: Проверка `localName.includes(ingName) || ingName.includes(localName)` дает ложные совпадения для коротких слов («лук», «сыр», «рис»).
* **Решение**: Приоритезировать проверку по `ingredient_id`, а при текстовом сравнении проверять границы слов.

### 2.8. Отсутствие сортировки продуктов в инвентаре холодильника
* **Файлы**:
  * [`frontend/src/views/FridgeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/FridgeView.vue)
  * [`frontend/src/stores/inventory.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/stores/inventory.ts)
* **Проблема**: Список продуктов в `FridgeView` выводится в порядке добавления (или порядке первичной синхронизации). Пользователь не может отсортировать продукты: по сроку годности (сначала те, что скоро испортятся), по алфавиту (для быстрого поиска глазами) или по дате добавления. При наличии более 20 позиций инвентарь превращается в неструктурированный список.
* **Решение**: Добавить компактную кнопку переключения порядка сортировки рядом с поиском («По сроку годности», «По алфавиту», «Сначала новые») и сохранять выбор в `localStorage`.

### 2.9. Вводящее в заблуждение пустое состояние при фильтрации по категории
* **Файл**: [`frontend/src/views/FridgeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/FridgeView.vue#L140-L155)
* **Проблема**: Если у пользователя есть продукты в холодильнике, но он выбирает категорию, где пока ничего нет (например, «Напитки»), на экране отображается глобальная заглушка: *«Холодильник пуст. Добавьте первый продукт»*. Пользователь может испугаться, что все его продукты стерлись.
* **Решение**: Разделять состояние: если продуктов вообще 0 — показывать «Холодильник пуст», если же активен фильтр категории — показывать: *«В категории «{Название}» пока нет продуктов»* с кнопкой сброса фильтра или быстрого добавления в эту категорию.

### 2.10. Утечка локальных данных в IndexedDB при выходе из профиля (Logout Privacy Leak)
* **Файлы**:
  * [`frontend/src/stores/auth.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/stores/auth.ts)
  * [`frontend/src/services/db.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/services/db.ts)
* **Проблема**: При вызове метода `logout()` удаляются только токены авторизации в `localStorage`, но таблицы локальной базы IndexedDB Dexie (`inventory`, `shoppingList`, `favoriteRecipes`) остаются нетронутыми. Если на этом же телефоне войдет другой пользователь, он до первой перезагрузки увидит чужие продукты и покупки.
* **Решение**: При вызове `logout()` принудительно очищать все таблицы Dexie `await Promise.all(db.tables.map(table => table.clear()))` и сбрасывать состояние соответствующих Pinia-сторов.

---

## 3. Android-эргономика, тач-таргеты (Material 48dp) и A11y

### 3.1. Недопустимый размер кнопок переключения порций (20×20px)
* **Файл**: [`frontend/src/views/RecipeDetailView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RecipeDetailView.vue#L233-L249)
* **Проблема**: Кнопки `+` и `-` имеют размер `w-5 h-5` (20×20px). Согласно **Android Material Design Guidelines**, минимальный размер сенсорного таргета должен составлять **48×48dp** (в крайнем случае 44×44dp). Попасть по кнопкам 20px пальцем на экране смартфона крайне тяжело.
* **Решение**: Увеличить кнопки до `w-9 h-9` (36×36px) с тач-зоной 48px:
  ```html
  <button type="button" class="w-9 h-9 rounded-xl bg-[#EBF3EF] text-[#165337] font-bold flex items-center justify-center text-sm active:scale-90 ...">
  ```

### 3.2. Маленькие тач-зоны вспомогательных контролов
* **Файлы**:
  * [`frontend/src/components/layout/AppHeader.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/layout/AppHeader.vue#L41-L49) — кнопка «Назад» (`p-1 -ml-1`, фактически ~28×28px).
  * [`frontend/src/views/ProfileView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/ProfileView.vue#L247-L253) — кнопка смены фото профиля (`w-6 h-6`).
* **Решение**: Увеличить размер тач-контейнеров до минимум 44–48px.

### 3.3. Недоступность интерактивных карточек для TalkBack (Android Screen Reader)
* **Файлы**:
  * [`frontend/src/components/inventory/ProductCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/ProductCard.vue#L59) — открытие действий по тапу на `div` без `role="button"`, `tabindex="0"` и `aria-expanded`.
  * [`frontend/src/components/shopping/ShoppingItemCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/shopping/ShoppingItemCard.vue#L57) — чекбокс выполнен через `div` без `role="checkbox"` и `aria-checked`.
  * [`frontend/src/components/recipes/RecipeCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/recipes/RecipeCard.vue#L86) — карточка рецепта без семантики ссылки/кнопки перехода.
* **Решение**: Добавить соответствующие ARIA-атрибуты, `role="button"`, `role="checkbox"`, `aria-checked` и `tabindex="0"`.

### 3.4. Низкий контраст неактивных элементов интерфейса
* **Файлы**:
  * [`frontend/src/components/layout/AppTabBar.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/layout/AppTabBar.vue#L46) — неактивные табы `text-slate-400` на белом фоне (контраст 2.34:1 при норме 4.5:1).
  * [`frontend/src/components/inventory/ProductCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/ProductCard.vue#L73) — подпись категории `text-slate-400`.
  * [`frontend/src/views/RecipeDetailView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RecipeDetailView.vue#L215) — подписи метрик «Время», «Сложность» `text-slate-400`.
* **Решение**: Заменить `text-slate-400` на `text-stone-500` или `text-zinc-500`.

### 3.5. Отсутствие кнопки показа/скрытия пароля в полях аутентификации
* **Файлы**:
  * [`frontend/src/views/LoginView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/LoginView.vue)
  * [`frontend/src/views/RegisterView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RegisterView.vue)
* **Проблема**: В полях ввода пароля на экранах логина и регистрации используется обычный `type="password"` без кнопки `Eye`/`EyeOff`. На сенсорной клавиатуре Android пользователи регулярно опечатываются, а невозможность подсмотреть введенный символ вызывает раздражение.
* **Решение**: Добавить кнопку переключения видимости пароля с тач-таргетом 48dp, меняющую `type` между `password` и `text`, с корректными атрибутами `aria-label="Показать пароль"` / `aria-label="Скрыть пароль"`.

### 3.6. Отсутствие инлайн-валидации и подсказок ошибок в полях ввода
* **Файлы**:
  * [`frontend/src/views/LoginView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/LoginView.vue)
  * [`frontend/src/views/RegisterView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RegisterView.vue)
* **Проблема**: Ошибки валидации (некорректный email, слишком короткий пароль) возникают только после нажатия на кнопку отправки в виде тоста сверху экрана. Поле с ошибкой не подсвечивается красной рамкой, а текст ошибки не выводится непосредственно под инпутом.
* **Решение**: Реализовать валидацию по событию `blur`: подсвечивать инпут `border-red-500` и выводить подсказку `text-xs text-red-600` под полем с атрибутом `aria-errormessage`.

### 3.7. Индикация свежести опирается исключительно на цвет (Colorblind Inaccessible)
* **Файлы**:
  * [`frontend/src/components/inventory/ProductCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/ProductCard.vue)
  * [`frontend/src/components/inventory/FridgeSummaryCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/FridgeSummaryCard.vue)
* **Проблема**: Статус срока годности (свежий, истекает, просрочен) обозначается исключительно цветом текста/фона (`text-emerald-600`, `text-amber-500`, `text-red-500`). Согласно WCAG 2.1 (Критерий 1.4.1 «Использование цвета»), цвет не должен быть единственным средством передачи информации. Люди с нарушением цветовосприятия (дейтеранопия) не могут отличить истекающий продукт от свежего.
* **Решение**: Дополнить цвет семантическими иконками и текстом: галочка `✓` для свежих продуктов (> 3 дней), песочные часы `⏳` для истекающих (1–3 дня), знак предупреждения `⚠️` для просроченных.

---

## 4. Сценарий «Кухня и готовка» (Cook Mode на Android)

### 4.1. Отсутствие блокировки засыпания экрана (Screen Wake Lock API в Chrome Android)
* **Файл**: [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue)
* **Проблема**: В Android экран смартфона стандартно блокируется через 30–60 секунд бездействия. Когда пользователь готовит по рецепту, руки могут быть в муке, масле или воде. Постоянная необходимость трогать экран для разблокировки делает Cook Mode неудобным. В Android Chrome API `navigator.wakeLock` поддерживается на 100%.
* **Решение**: Активировать Wake Lock при входе в режим готовки и освобождать при выходе:
  ```ts
  let wakeLock: WakeLockSentinel | null = null
  onMounted(async () => {
    if ('wakeLock' in navigator) {
      try {
        wakeLock = await navigator.wakeLock.request('screen')
      } catch {}
    }
  })
  onUnmounted(() => {
    wakeLock?.release()
  })
  ```

### 4.2. Отсутствие звукового сигнала (Chime) при окончании таймера
* **Файлы**:
  * [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue)
  * [`frontend/src/stores/cookingTimer.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/stores/cookingTimer.ts#L48)
* **Проблема**: При завершении отсчета вызывается только `triggerHaptic('warning')`. Если Android-смартфон стоит на подставке на расстоянии 1 метра, вибрацию не слышно — блюдо сгорит. В мертвом компоненте `CookingTimer.vue` звук на Web Audio API (`playTimerChime`) уже был написан, но не перенесен в глобальный таймер `cookingTimer.ts`.
* **Решение**: Добавить воспроизведение звукового колокольчика через Web Audio API в `cookingTimer.ts` при нулевом остатке времени.

### 4.3. Несоответствие быстрых кнопок коррекции времени
* **Файл**: [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue#L148-L170)
* **Проблема**: Доступны кнопки `-1 мин`, `+1 мин`, `+5 мин`. Кнопка `-5 мин` отсутствует.
* **Решение**: Добавить симметричную кнопку `-5 мин` в едином визуальном стиле со всеми кнопками регулировки.

### 4.4. Разрыв сквозного сценария: отсутствие умного списания продуктов при завершении готовки (Smart Consumption)
* **Файлы**:
  * [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue)
  * [`frontend/src/stores/inventory.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/stores/inventory.ts)
* **Проблема**: Когда пользователь завершает последний шаг рецепта, приложение просто показывает поздравительный экран («Приятного аппетита!»). Использованные ингредиенты остаются в инвентаре холодильника в неизменном количестве. Пользователю приходится вручную идти в холодильник, вспоминать, что он потратил, и вручную уменьшать или удалять позиции. Это разрывает ключевой продуктовый цикл приложения: *«Нашел рецепт -> Приготовил -> Обновил запасы»*.
* **Решение**: По завершении готовки показывать модальное окно / шторку со списком распознанных ингредиентов рецепта, присутствующих в холодильнике, и чекбоксами (по умолчанию все отмечены). По кнопке «Списать из холодильника» вычитать израсходованные количества в один клик.

### 4.5. Отсутствие плавающего мини-таймера при навигации по приложению (Floating Mini Kitchen Timer)
* **Файлы**:
  * [`frontend/src/App.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/App.vue)
  * [`frontend/src/stores/cookingTimer.ts`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/stores/cookingTimer.ts)
  * [`frontend/src/components/common/FloatingTimerPill.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/common/FloatingTimerPill.vue)
* **Проблема**: Если пользователь запустил таймер в `CookModeView` (например, выпекание на 20 минут) и свернул рецепт или перешел в другой раздел (посмотреть рецепты соусов или список покупок), таймер тикает в фоновом Pinia-сторе, но пользователь не видит оставшееся время. Нет возможности быстро поставить его на паузу или вернуться в рецепт.
* **Решение**: Создать плавающий виджет-пилюлю (Floating Timer Pill), прикрепленный над таб-баром (`bottom-20`), активный на всех страницах (кроме самого `CookModeView`): индикатор времени `04:32`, кнопка паузы и клик для мгновенного возврата к шагу приготовления.

### 4.6. Эргономика и размер карточки описания шага в Cook Mode
* **Файл**: [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue#L198-L230)
* **Проблема**: Карточка текущего шага приготовления имеет слишком малую высоту (`min-height`), а текст шага при чтении со стола или кухонной подставки (на расстоянии 0.8–1.5 м) воспринимается мелким.
* **Решение**: Увеличить базовую высоту карточки шага (минимум 140–160px), поднять размер шрифта текста инструкции (`text-base sm:text-lg leading-relaxed`), сделать навигационные кнопки «Назад» и «Следующий шаг» крупными тач-таргетами.

---

## 5. Системная навигация Android (Back Gesture) и жесты

### 5.1. Отсутствие свайп-жеста закрытия мобильных шторок (Swipe-to-Dismiss)
* **Файл**: [`frontend/src/components/common/BaseBottomSheet.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/common/BaseBottomSheet.vue#L120)
* **Проблема**: В верхней части шторки есть визуальная полоска Drag Handle (`w-10 h-1.5 rounded-full bg-stone-300`), создающая прямое ожидание смахивания вниз. Однако свайп пальцем вниз не поддерживается — закрытие срабатывает только по тапу на полоску или фон.
* **Решение**: Добавить сенсорный слушатель `touchstart`, `touchmove`, `touchend` для закрытия шторки свайпом вниз.

### 5.2. Отсутствие свайпа между шагами приготовления в Cook Mode
* **Файл**: [`frontend/src/views/CookModeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/CookModeView.vue#L198)
* **Проблема**: Переключение шагов осуществляется только нажатием кнопок внизу экрана. На Android-смартфоне при управлении одной рукой естественный паттерн — свайп карточки влево/вправо.
* **Решение**: Добавить свайп-детектор (touch swipe left/right) на контейнер карточки шага.

### 5.3. Жестовое управление карточками продуктов (Swipe-to-Delete)
* **Файл**: [`frontend/src/components/inventory/ProductCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/ProductCard.vue#L56)
* **Проблема**: Вместо быстрого свайпа влево для удаления продукта пользователю приходится тапать на карточку, ждать раскрытия аккордеона и затем нажимать кнопку «Удалить».
* **Решение**: Реализовать свайп карточки влево с открытием кнопки удаления.

### 5.4. Зависание `BaseConfirmDialog` при системном жесте «Назад» на Android
* **Файл**: [`frontend/src/components/common/BaseConfirmDialog.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/common/BaseConfirmDialog.vue)
* **Проблема**: Модальный диалог подтверждения не перехватывает системную навигацию Android (Back gesture). Если у пользователя открыт диалог «Удалить продукт?», системный свайп «Назад» от края экрана уводит со страницы назад по истории браузера, вместо того чтобы просто закрыть диалог.
* **Решение**: Интегрировать диалог с историей браузера через добавление виртуального состояния (`history.pushState`) или перехват события `popstate`: системный жест «Назад» должен закрывать открытый диалог.

---

## 6. Дизайн-система, верстка и адаптация под экраны Android

### 6.1. Неконсистентные нижние отступы контента (Bottom Padding)
* **Файлы**:
  * `FridgeView.vue` — `pb-36` (144px)
  * `RecipesView.vue` — `pb-20` (80px) — **слишком мало**, может перекрываться панелью навигации на ряде Android-смартфонов!
  * `ShoppingView.vue` — `pb-36` (144px)
  * `ProfileView.vue` — `pb-28` (112px)
* **Проблема**: В `RecipesView` отступ `pb-20` (80px) меньше фактической высоты панели навигации с системной панелью Android (до 84–90px), из-за чего последний рецепт или лоадер пагинации перекрываются.
* **Решение**: Стандартизировать глобальный нижний отступ через `pb-28` или единую переменную `--tabbar-safe-height`.

### 6.2. 220 строк рукописного CSS и хардкод цветов в `RecipeCard.vue`
* **Файл**: [`frontend/src/components/recipes/RecipeCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/recipes/RecipeCard.vue#L196-L420)
* **Проблема**: Компонент содержит огромный блок `<style scoped>` с жестко зашитыми hex-цветами (`#064E3B`, `#78350F`, `#E2E8F0`, `#d6d3d1`), которые дублируют классы Tailwind и нарушают централизованную тему. В строках 200–202 свойство `box-shadow` написано дважды подряд и перезаписывает само себя.
* **Решение**: Провести рефакторинг `RecipeCard.vue` на утилитарные классы Tailwind CSS с использованием токенов палитры.

### 6.3. Громоздкие вложенные тернарные операторы в шаблоне `RecipeCard.vue`
* **Файл**: [`frontend/src/components/recipes/RecipeCard.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/recipes/RecipeCard.vue#L128)
* **Проблема**: Строка `{{ matchItem && matchItem.missing_ingredients && matchItem.missing_ingredients.length === 1 ? ... : ... }}` загромождает шаблон сложной бизнес-логикой.
* **Решение**: Вынести вычисление текста бейджа в computed-свойство.

### 6.4. Отсутствие визуального индикатора переполнения горизонтальных фильтров
* **Файлы**:
  * [`frontend/src/views/FridgeView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/FridgeView.vue#L82)
  * [`frontend/src/views/RecipesView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RecipesView.vue#L236)
* **Проблема**: Полоса категорий скрывает скроллбар (`no-scrollbar`). Если категорий много, пользователь не видит, что список можно прокрутить вправо.
* **Решение**: Добавить мягкий градиентный фейд (fade mask) по правому краю контейнера чипов.

### 6.5. Отсутствие плавных экранных переходов (Route Transitions) в мобильном PWA
* **Файлы**:
  * [`frontend/src/App.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/App.vue)
  * [`frontend/src/assets/main.css`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/assets/main.css)
* **Проблема**: Навигация между вкладками таб-бара и переход на детальный просмотр рецепта происходят мгновенно (0ms скачком). Для мобильного PWA под Android это воспринимается грубо, в отличие от нативных приложений, где используется мягкий Cross-fade.
* **Решение**: Обернуть `<router-view>` в `<transition name="fade" mode="out-in">` со стилями мягкого затухания/проявления (150–200ms) с поддержкой `@media (prefers-reduced-motion: reduce)`.

### 6.6. Внедрение дизайн-токенов темы Warm Editorial
* **Файлы**:
  * [`frontend/tailwind.config.js`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/tailwind.config.js)
  * [`frontend/src/assets/main.css`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/assets/main.css)
* **Проблема**: Цвета интерфейса разрознены между жестко закодированными Tailwind-классами (`slate-*`, `emerald-*`, произвольные hex). Отсутствует единый согласованный источник правды для палитры Warm Editorial.
* **Решение**: Зафиксировать централизованные токены в конфигурации Tailwind:
  * Фон приложения (`canvas`): `#FAF7F2` (теплый овсяно-льняной оттенок).
  * Карточки и поверхности (`surface`): `#FFFFFF` с тонкой теплой каймой `#E8E2D8`.
  * Бренд-цвет (`brand`): `#165337` (глубокий ботанический изумруд) и мягкая подложка `#EBF3EF`.
  * Акцент отсутствующих продуктов (`accent-missing`): `#C2410C` (теплый терракотовый).
  * Текст (`ink`): глубокий графитовый `#18181B`, второстепенный `#71717A`.
  * Кухонный режим (`cook-mode`): высококонтрастная кухонная темная палитра (`#061811` фон, `#0A261B` карточки, `#22C55E` акцент).

### 6.7. Типографика без засечек (Modern Sans-Serif)
* **Файлы**:
  * [`frontend/index.html`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/index.html)
  * [`frontend/tailwind.config.js`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/tailwind.config.js)
* **Проблема**: Использование тяжелых или псевдокнижных шрифтов с засечками (serif) в мобильном интерфейсе выглядит неестественно и ухудшает читаемость коротких надписей на мобильном экране.
* **Решение**: Использовать современный, хорошо читаемый гротеск `Plus Jakarta Sans` / `Inter` для всех элементов UI, заголовков и карточек. Для таймера готовки и точных граммовок использовать моноширинный `JetBrains Mono`.

### 6.8. Устранение визуального шума и AI-налёта
* **Файлы**:
  * [`frontend/src/views/RecipesView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RecipesView.vue)
  * [`frontend/src/components/layout/AppHeader.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/layout/AppHeader.vue)
* **Проблема**: Неуместные эмодзи в сегментированных переключателях («🔥 Подбор», «📖 Каталог», «❤️ Избранное»), псевдо-бейджи («PRO») и лишние декоративные элементы создают ощущение любительского шаблонного макета.
* **Решение**: Строго очистить интерфейс:
  * В табах рецептов использовать чистый лаконичный текст: `Подбор`, `Каталог`, `Избранное`.
  * Исключить любые выдуманные бейджи («PRO»), искусственные аватары и псевдокнопки, которых нет в архитектуре приложения.

### 6.9. Минималистичная шапка (AppHeader)
* **Файл**: [`frontend/src/components/layout/AppHeader.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/layout/AppHeader.vue)
* **Проблема**: Шапка перегружалась псевдо-аватарками или сторонними надписями.
* **Решение**: Сохранить чистый минималистичный вид: белый фон, центрированное название текущего раздела (или кнопка «Назад» для вложенных экранов), отсутствие посторонних визуальных шумов.

### 6.10. Стандартизация шторки добавления продукта (AddProductSheet)
* **Файл**: [`frontend/src/components/inventory/AddProductSheet.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/inventory/AddProductSheet.vue)
* **Проблема**: В прототипах появлялись динамически меняющиеся или нестандартные кнопки, путающие пользователя.
* **Решение**: Зафиксировать предсказуемый и надежный нижний блок из двух кнопок:
  1. `✓ Добавить и закрыть` (основное действие / Primary кнопка цвета бренда `#165337`).
  2. `+ Добавить еще продукт` (второстепенное действие / Secondary кнопка).

### 6.11. Консистентность экранов аутентификации (LoginView и RegisterView)
* **Файлы**:
  * [`frontend/src/views/LoginView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/LoginView.vue)
  * [`frontend/src/views/RegisterView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/RegisterView.vue)
* **Проблема**: Рассинхронизация стилей ввода, отсутствие показа пароля и дублирование шапки приводили к неряшливому виду экранов входа и регистрации.
* **Решение**: Привести экраны к единой архитектуре: брендовый верхний hero-блок с логотипом и заголовком, наезжающая белая форма (`rounded-t-3xl`), поля ввода с кнопкой переключения видимости пароля (`Eye`/`EyeOff`), понятная инлайн-валидация и полноразмерная кнопка действия.

---

## 7. Чистота кода и устранение мертвого кода

### 7.1. Полностью мертвый компонент `CookingTimer.vue` (312 строк)
* **Файл**: [`frontend/src/components/recipes/CookingTimer.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/components/recipes/CookingTimer.vue)
* **Проблема**: Компонент нигде не импортируется и не используется в приложении. Логика таймера реализована в полноэкранном `CookModeView.vue` и сторе `cookingTimer.ts`.
* **Решение**: Удалить неиспользуемый файл `CookingTimer.vue`, а полезную логику аудио-колокольчика (`playTimerChime`) перенести в глобальный стор `cookingTimer.ts`.

---

## 8. Бэкенд-стыки и поддержка Android-форматов (WebP)

### 8.1. Отклонение нативного Android-формата аватаров `image/webp`
* **Файлы**:
  * Клиент: [`frontend/src/views/ProfileView.vue`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/frontend/src/views/ProfileView.vue#L79) (`validTypes = ['image/jpeg', 'image/png', 'image/webp']`)
  * Сервер: [`backend/internal/handler/user.go`](file:///C:/Users/kerrek8/orca/workspaces/whatcook/ui-ux/backend/internal/handler/user.go#L92-L96) (`image/jpeg`, `image/jpg`, `image/png`, `image/gif`)
* **Проблема**: На Android подавляющее большинство сохраненных картинок и фото из галереи имеют формат WebP. Фронтенд успешно пропускает файл `.webp`, но Go-бэкенд возвращает ошибку `400 Bad Request: unsupported image format`, так как в `switch mediaType` забыт `image/webp`.
* **Решение**: Добавить поддержку `image/webp` в валидатор медиа-типа в `backend/internal/handler/user.go` и в модуль обработки аватаров.

---

## 9. Сводная матрица задач (Android PWA Focus)

| Приоритет | ID | Описание задачи | Трудоемкость |
| :---: | :--- | :--- | :---: |
| **P1** | **BUG-1** | Исправление бага фильтрации «Просрочено» в `FridgeSummaryCard` и `inventory.ts` | 15 мин |
| **P1** | **BUG-2** | Устранение двойной шапки на экранах `/login` и `/register` (`hideHeader: true`) | 5 мин |
| **P1** | **BUG-3** | Сброс `ingredientId` при ручном редактировании текста в автокомплитах | 15 мин |
| **P1** | **BUG-4** | Сброс локальной базы IndexedDB Dexie при logout (устранение утечки данных) | 15 мин |
| **P1** | **CORE-1**| Умное списание продуктов после завершения готовки в `CookModeView` (Smart Consumption) | 40 мин |
| **P1** | **AND-1** | Добавление Screen Wake Lock API в `CookModeView.vue` (экран Android не гаснет) | 15 мин |
| **P1** | **AND-2** | Добавление звукового сигнала (Chime) по окончании готовки в `cookingTimer.ts` | 20 мин |
| **P1** | **AND-3** | Добавление `interactive-widget=resizes-content` в `viewport` для клавиатур Android | 5 мин |
| **P1** | **AND-4** | Добавление поддержки аватаров `image/webp` в бэкенд (нативный формат Android) | 15 мин |
| **P1** | **AND-6** | Интеграция `BaseConfirmDialog` с системным жестом «Назад» Android | 20 мин |
| **P1** | **UI-1**  | Увеличение тач-кнопок порций до Material-стандарта (36–48px) в `RecipeDetailView` | 10 мин |
| **P1** | **UI-2**  | Исправление коллизии FAB с таб-баром на Android (`safe-area-bottom`) | 10 мин |
| **P2** | **DS-1**  | Внедрение токенов темы Warm Editorial (`#FAF7F2`, `#165337`, `#C2410C`) в Tailwind | 25 мин |
| **P2** | **DS-2**  | Подключение sans-serif типографики (`Plus Jakarta Sans` / `JetBrains Mono`) | 15 мин |
| **P2** | **A11Y-1**| Повышение контраста второстепенного текста в таб-баре и карточках до нормы 4.5:1 | 15 мин |
| **P2** | **A11Y-2**| Добавление `aria-label` для полей поиска и ролей кнопок на карточках для TalkBack | 15 мин |
| **P2** | **A11Y-3**| Семантические иконки свежести (✓, ⏳, ⚠️) для доступности при дальтонизме | 20 мин |
| **P2** | **AND-5** | Добавление `inputmode="decimal"` и `enterkeyhint` для клавиатур Android Gboard | 10 мин |
| **P2** | **UI-3**  | Скрытие пустой карточки «Прогресс покупок» при отсутствии покупок | 5 мин |
| **P2** | **UI-5**  | Плавающий мини-таймер (Floating Mini Timer) при уходе с экрана готовки | 45 мин |
| **P2** | **UI-6**  | Кнопка показа/скрытия пароля (`Eye`/`EyeOff`) в формах `LoginView` и `RegisterView` | 15 мин |
| **P2** | **UI-7**  | Инлайн-валидация и подсветка ошибок под полями ввода форм | 25 мин |
| **P2** | **UI-8**  | Сортировка продуктов в холодильнике (срок годности, алфавит, дата добавления) | 30 мин |
| **P2** | **UI-9**  | Разделение пустых состояний в холодильнике (нет продуктов вообще vs нет в категории) | 15 мин |
| **P2** | **UI-11** | Кнопка «Отмена» (Undo toast) при удалении позиции из списка покупок | 20 мин |
| **P2** | **COOK-1**| Добавление симметричной кнопки `-5 мин` и увеличение карточки шага в Cook Mode | 15 мин |
| **P2** | **CLEAN-1**| Удаление мертвого файла `CookingTimer.vue` (312 строк) | 5 мин |
| **P2** | **CLEAN-2**| Рефакторинг 220 строк CSS и удаление дублирующего `box-shadow` в `RecipeCard.vue` | 30 мин |
| **P3** | **GEST-1**| Жест свайпа вниз для закрытия `BaseBottomSheet.vue` | 40 мин |
| **P3** | **GEST-2**| Жест свайпа между шагами рецепта в `CookModeView.vue` | 25 мин |
| **P3** | **UI-4**  | Выравнивание отступов `pb-*` на всех экранах под системную панель Android | 15 мин |
| **P3** | **UI-10** | Плавные экранные переходы между маршрутами (Route Fade Transition, 150ms) | 15 мин |
