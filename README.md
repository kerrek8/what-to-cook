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
  * Документация Swagger UI: [http://localhost:8080/swagger/index.html](http://localhost:8080/swagger/index.html)
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

Все запланированные этапы MVP дорожной карты полностью завершены:

* **Backend (Этапы B1–B8)**: 
  * Инфраструктура, пул pgx, Graceful Shutdown, проверка здоровья `/health`.
  * Регистрация, авторизация (JWT + Refresh Cookie), управление профилем и аллергенами.
  * Справочник ингредиентов (каталог, автокомплит, сид 75 популярных продуктов).
  * Инвентарь холодильника (CRUD, точные веса / качественные оценки, контроль сроков годности).
  * Рецепты и алгоритм сопоставления под инвентарь холодильника (провайдер TheMealDB, кэш в PostgreSQL).
  * Список покупок с пакетным добавлением из рецепта и операцией переноса купленного в холодильник.
  * Web Push уведомления и фоновый воркер (`ExpirationWorker`) контроля истекающих сроков продуктов.
  * Интерактивная спецификация Swagger UI (`/swagger/index.html`) и сквозные тесты пользовательского сценария.
* **Frontend PWA (Этапы F1–F7)**:
  * Мобильный каркас на Vant UI с поддержкой safe-area и навигацией таббара.
  * PWA Service Worker (офлайн-кэш Workbox, манифест и установка на домашний экран).
  * Локальная база данных Dexie.js (IndexedDB) для автономной работы в офлайн-режиме.
  * API-клиент с прозрачным обновлением токенов, экраны входа, регистрации и профиля.
  * Экран «Холодильник»: группировка, цветовая шкала свежести, свайп-удаление, модалка добавления.
  * Экран «Рецепты»: умный подбор «Что приготовить сейчас», бейджи спасения продуктов, таймеры приготовления.
  * Экран «Список покупок»: группировка по отделам супермаркета, быстрое вычеркивание и перенос в холодильник.
  * Интеграция Web Push подписок через браузер и аудит производительности Lighthouse.

Детальный отчет по всем задачам доступен в [`docs/roadmap.md`](docs/roadmap.md).
