# WhatCook («Что приготовить?»)

Mobile-First PWA-приложение для рационального использования продуктов, учета содержимого холодильника и подбора рецептов с автоматическим формированием списка покупок.

---

## 🛠 Стек технологий

* **Backend**: Go 1.22+, Gin, PostgreSQL 16+, SQLC, pgx, golang-migrate, JWT.
* **Frontend**: Vue 3 (Composition API, `<script setup>`, TypeScript), Vite, Vant UI, Pinia, Dexie.js (IndexedDB), `vite-plugin-pwa` (Workbox).
* **Инфраструктура**: Docker & Docker Compose, Nginx.

---

## 🚀 Быстрый запуск (Docker Compose)

Рекомендуемый способ запуска всего стека (PostgreSQL, миграции, Backend, Frontend):

```bash
# 1. Создать файл окружения
cp .env.example .env

# 2. Собрать и запустить все сервисы в фоне
docker compose up --build -d
```

### Доступные сервисы:
* **Frontend (PWA)**: [http://localhost:3000](http://localhost:3000)
* **Backend API**: [http://localhost:8080](http://localhost:8080)
  * Проверка работоспособности: `GET http://localhost:8080/health`
* **PostgreSQL**: `localhost:5432`

Остановить контейнеры:
```bash
docker compose down
```

---

## 💻 Локальная разработка

### 1. База данных и миграции
Быстрый запуск только PostgreSQL и накат миграций через Docker:
```bash
docker compose up -d postgres migrate
```

### 2. Backend (Golang)
Требуется: Go 1.22+
```bash
cd backend

# Запуск сервера
go run ./cmd/server

# Запуск тестов
go test ./...
```
*(При установленном [Task](https://taskfile.dev): `task run`, `task test`, `task lint`)*

### 3. Frontend (Vue 3 / PWA)
Требуется: Node.js 20+, pnpm 9+
```bash
cd frontend

# Установка зависимостей
pnpm install

# Запуск dev-сервера (http://localhost:5173)
pnpm dev

# Проверка типов и тесты
pnpm type-check
pnpm test
```

---

## ⚙️ Переменные окружения (`.env`)

Ключевые параметры (подробнее в [`.env.example`](.env.example)):

| Переменная | По умолчанию | Описание |
|---|---|---|
| `POSTGRES_DB` / `USER` / `PASSWORD` | `whatcook` / `whatcook_password` | Учетные данные PostgreSQL |
| `POSTGRES_PORT` | `5432` | Порт PostgreSQL на хосте |
| `BACKEND_PORT` | `8080` | Порт REST API сервера |
| `FRONTEND_PORT` | `3000` | Внешний порт фронтенда в Docker |
| `JWT_SECRET` | `super_secret_jwt_key...` | Секретный ключ подписи JWT |
| `VITE_API_URL` | `http://localhost:8080` | Адрес API для фронтенда |

---

## 📁 Структура проекта

```text
├── backend/          # REST API сервер на Go (Gin, SQLC, pgx, миграции)
├── frontend/         # Клиентское Mobile-First PWA на Vue 3
├── docs/             # Архитектура (tech-stack.md) и дорожная карта (roadmap.md)
├── docker-compose.yml# Спецификация локального развертывания
└── .env.example      # Шаблон переменных окружения
```

---

## 📌 Текущее состояние (MVP)

* **Backend**: 
  * Базовая инфраструктура, Graceful Shutdown, эндпоинт `/health`.
  * Регистрация, авторизация (JWT + Refresh Cookie), управление профилем и продуктом-аллергеном.
  * Справочник ингредиентов (каталог, автокомплит, сид 75 популярных продуктов).
  * Инвентарь холодильника (CRUD продуктов, точные веса / качественные оценки, сортировка по срокам).
* **Frontend**:
  * Мобильный каркас с адаптацией под узкие экраны и safe-area.
  * Навигация (Холодильник, Рецепты, Список покупок, Профиль).
  * PWA Service Worker (офлайн-кэш, манифест установки).
  * Локальная база данных Dexie.js (IndexedDB) для автономной работы.

Детальный план реализации доступен в [`docs/roadmap.md`](docs/roadmap.md).
