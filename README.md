# WhatCook («Что приготовить?»)

Mobile-First PWA-приложение для рационального использования продуктов, учета содержимого холодильника и подбора рецептов с автоматическим формированием списка покупок.

Текущая версия приложения: **v0.9.0**

---

## 🛠 Стек технологий

* **Backend**: Go 1.22+, Gin REST API, PostgreSQL 16+, SQLC, pgx, golang-migrate, JWT (Access + HttpOnly Refresh).
* **AI & Медиа**: Sber GigaChat API (нормализация ингредиентов, расчет времени/сложности, гастрономические промпты), FLUX.1 (ресторанные фуд-фото), локальное медиа-хранилище `backend/uploads/recipes/` с автоматическим сжатием JPEG и билинейным ресайзом.
* **Frontend**: Vue 3 (Composition API, `<script setup>`, TypeScript), Vite, **Bun** (пакетный менеджер и рантайм), **Tailwind CSS v3**, **Lucide Icons** (`lucide-vue-next`), Pinia, Dexie.js (IndexedDB), `vite-plugin-pwa` (Workbox). Полный отказ от тяжелых внешних UI-библиотек (Vant UI удален).
* **Инфраструктура**: Docker & Docker Compose (`oven/bun:1-alpine`), Nginx.

---

## 🚀 Быстрый запуск (Docker Compose)

Запуск всего стека (PostgreSQL, миграции, Backend, Frontend) одной командой:

```bash
# 1. Создать файл окружения
cp .env.example .env

# 2. Собрать и запустить все сервисы в фоне
docker compose up --build -d
```

### Доступные сервисы:
* **Frontend (PWA)**: [http://localhost:3000](http://localhost:3000)
* **Backend API**: [http://localhost:8080](http://localhost:8080)
  * Healthcheck: `GET http://localhost:8080/health`
  * Swagger UI: [http://localhost:8080/swagger/index.html](http://localhost:8080/swagger/index.html)
  * Раздача медиа: `http://localhost:8080/uploads/recipes/`
* **PostgreSQL**: `localhost:5432`

Остановить контейнеры:
```bash
docker compose down
```

---

## 💻 Локальная разработка

### 1. База данных и миграции
```bash
docker compose up -d postgres migrate
```

### 2. Backend (Golang 1.22+)
```bash
cd backend
go run ./cmd/server
go test ./...
go vet ./...
```

### 3. Frontend (Vue 3 / Bun 1.1+)
```bash
cd frontend
bun install
bun run dev         # Dev-сервер (http://localhost:5173)
bun run type-check  # Проверка типов TypeScript
bun run test        # Юнит-тесты Vitest
bun run build       # Продакшен-сборка PWA
```

---

## 📌 Ключевые возможности (v0.9.0)

* **Современный Mobile-First UI (Figma)**:
  * Чистая эстетика (белоснежный surface, глубокий текст Slate 900 `#0F172A`, акцентный Темный изумруд `#064E3B`).
  * 100% нативные легковесные компоненты (`BaseBottomSheet`, `BaseToast`, свайп/тап карточек продуктов).
* **Холодильник (Инвентарь)**:
  * Темно-изумрудный Hero-дашборд с быстрой сводкой (всего / свежие / скоро испортятся).
  * Карточки с механикой Tap-to-Open и быстрыми действиями (редактировать, удалить).
  * Шторка добавления продуктов с быстрыми пресетами срока годности (`+3 дня`, `1 неделя`, `2 недели`, `В заморозку`).
* **Каталог рецептов и «Что приготовить»**:
  * Алгоритм сопоставления с ранжированием по проценту наличия ингредиентов.
  * Учет персональной базовой корзины и продуктов-аллергенов.
  * Фильтр «🔥 Спасает продукты» для спасения скоропортящихся позиций.
* **Режим готовки (Cook Mode)**:
  * Полноэкранный контрастный режим для кухни (`#0B1511`) с защитой от случайных нажатий.
  * Крупные цифры таймера, кнопки точной регулировки (`-5м`, `-1м`, `+1м`, `+5м`) и карусель пошагового приготовления блюда.
* **Список покупок**:
  * Добавление недостающих ингредиентов из рецепта в 1 клик.
  * Прогресс-бар покупок («Куплено X из Y»), сворачиваемая секция и мгновенный перенос в холодильник.
* **PWA & Офлайн**:
  * Установка на экран смартфона (`standalone`).
  * Кэширование Workbox и локальная база Dexie.js (IndexedDB) для автономной работы на кухне и в магазинах со слабой связью.
  * Web Push напоминания об истекающих сроках годности.

---

## 📁 Структура проекта

```text
├── backend/          # REST API на Go (Gin, SQLC, pgx, миграции, хранилище uploads)
├── frontend/         # Mobile-First PWA на Vue 3, Vite, Bun, Tailwind CSS
├── docs/             # Архитектура (tech-stack.md) и Roadmap (roadmap.md)
├── docker-compose.yml# Локальное развертывание в Docker
└── .env.example      # Переменные окружения
```
