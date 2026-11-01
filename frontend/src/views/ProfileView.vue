<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRouter } from 'vue-router'
import { showToast, showConfirmDialog } from 'vant'
import { useAuthStore } from '@/stores/auth'
import { useNotificationStore } from '@/stores/notification'
import { usePwaStore } from '@/stores/pwa'
import { getIngredientsApi } from '@/api/ingredients'
import type { Ingredient } from '@/types/api'
import {
  checkTranslationService,
  displayIngredientName,
  displayText,
  translateSearchQuery,
  translateTexts,
  translationServiceStatus
} from '@/i18n/translation'

const router = useRouter()
const authStore = useAuthStore()
const notificationStore = useNotificationStore()
const pwaStore = usePwaStore()

const showAllergenSheet = ref(false)
const showPantrySheet = ref(false)
const searchQuery = ref('')
const ingredients = ref<Ingredient[]>([])
const isLoadingIngredients = ref(false)
const translatedSearch = ref('')

const currentAllergenName = computed(() => {
  const allergenId = authStore.primaryAllergenId
  if (!allergenId) return 'Не выбрано'
  const found = ingredients.value.find((item) => item.id === allergenId)
  return found ? displayIngredientName(found.name, found.nameEn) : `ID: ${allergenId}`
})
const pantryNames = computed(() => ingredients.value.filter(i => authStore.user?.pantryIngredientIds.includes(i.id)).map(i => displayIngredientName(i.name, i.nameEn)))

const filteredIngredients = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return ingredients.value
  const terms = [q, translatedSearch.value.toLowerCase()]
  return ingredients.value.filter((item) => [item.name, item.nameEn ?? '', displayIngredientName(item.name, item.nameEn), item.category, displayText(item.category)].some(value => terms.some(term => term && value.toLowerCase().includes(term))))
})

let searchTimer: ReturnType<typeof setTimeout> | undefined
watch(searchQuery, (query) => {
  if (searchTimer) clearTimeout(searchTimer)
  searchTimer = setTimeout(async () => {
    translatedSearch.value = await translateSearchQuery(query)
  }, 250)
})

onUnmounted(() => {
  if (searchTimer) clearTimeout(searchTimer)
})

async function loadIngredients() {
  if (ingredients.value.length > 0) return
  isLoadingIngredients.value = true
  try {
    ingredients.value = await getIngredientsApi()
    void translateTexts(ingredients.value.flatMap(item => [item.nameEn || item.name, item.category]))
  } catch {
    // Fallback if offline
    ingredients.value = [
      { id: 1, name: 'Молоко', category: 'Молочные продукты', defaultUnit: 'л', isPantryEssential: false },
      { id: 2, name: 'Яйца', category: 'Яйца', defaultUnit: 'шт', isPantryEssential: false },
      { id: 3, name: 'Арахис', category: 'Орехи', defaultUnit: 'г', isPantryEssential: false },
      { id: 4, name: 'Глютен (пшеница)', category: 'Бакалея', defaultUnit: 'г', isPantryEssential: false },
      { id: 5, name: 'Рыба', category: 'Рыба и морепродукты', defaultUnit: 'г', isPantryEssential: false }
    ]
  } finally {
    isLoadingIngredients.value = false
  }
}

function openAllergenPicker() {
  if (!authStore.isAuthenticated) {
    showToast('Войдите, чтобы сохранить продукт-исключение')
    router.push('/login')
    return
  }
  loadIngredients()
  showAllergenSheet.value = true
}

async function selectAllergen(id: number | null) {
  try {
    await authStore.setAllergen(id)
    showToast({ type: 'success', message: id ? 'Аллерген сохранен' : 'Исключение снято' })
    showAllergenSheet.value = false
  } catch (err: any) {
    const msg = err.response?.data?.error || 'Не удалось обновить исключение'
    showToast({ type: 'fail', message: msg })
  }
}

async function togglePantry(id: number) {
  const current = authStore.user?.pantryIngredientIds ?? []
  const next = current.includes(id) ? current.filter(value => value !== id) : [...current, id]
  try {
    await authStore.setPantry(next)
    showToast({ type: 'success', message: 'Базовая корзина сохранена' })
  } catch {
    showToast({ type: 'fail', message: 'Не удалось сохранить базовую корзину' })
  }
}

function openPantryPicker() {
  if (!authStore.isAuthenticated) {
    showToast('Войдите, чтобы настроить базовую корзину')
    router.push('/login')
    return
  }
  loadIngredients()
  showPantrySheet.value = true
}

async function onNotificationSwitch(val: boolean) {
  if (!authStore.isAuthenticated) {
    showToast('Войдите в аккаунт, чтобы получать уведомления')
    router.push('/login')
    return
  }

  if (val) {
    const ok = await notificationStore.enableNotifications()
    if (ok) {
      showToast({ type: 'success', message: 'Уведомления включены' })
    } else {
      if (notificationStore.permission === 'denied') {
        showToast({ type: 'fail', message: 'Разрешите уведомления в настройках браузера' })
      } else {
        showToast('Уведомления не подключены')
      }
    }
  } else {
    await notificationStore.disableNotifications()
    showToast('Уведомления отключены')
  }
}

async function handleLogout() {
  try {
    await showConfirmDialog({
      title: 'Выход из профиля',
      message: 'Вы уверены, что хотите выйти из аккаунта?',
      confirmButtonText: 'Выйти',
      confirmButtonColor: '#f44336',
      cancelButtonText: 'Отмена'
    })
    await authStore.logout()
    showToast({ type: 'success', message: 'Вы вышли из системы' })
  } catch {
    // Cancelled dialog
  }
}

onMounted(() => {
  loadIngredients()
  void checkTranslationService()
  notificationStore.checkSubscription()
})

const translationStatusText = computed(() => ({
  checking: 'Проверка…',
  connected: 'Подключён',
  'not-configured': 'Адрес не задан',
  unavailable: 'Нет соединения',
  unsupported: 'Нет пары en ↔ ru'
})[translationServiceStatus.value])

const translationStatusHint = computed(() => ({
  checking: 'Проверяется доступность сервиса перевода',
  connected: 'LibreTranslate доступен, русский и английский включены',
  'not-configured': 'Задайте VITE_LIBRETRANSLATE_URL и пересоберите фронтенд',
  unavailable: 'Проверьте URL сервиса и доступность адреса /languages',
  unsupported: 'Включите языковые модели английского и русского'
})[translationServiceStatus.value])

async function refreshTranslationStatus() {
  await checkTranslationService()
}
</script>

<template>
  <div class="view-container">
    <!-- Authenticated Header -->
    <div v-if="authStore.isAuthenticated && authStore.user" class="user-card">
      <van-image
        round
        width="64px"
        height="64px"
        src="https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg"
      />
      <div class="user-meta">
        <h3 class="user-name">{{ authStore.user.name }}</h3>
        <p class="user-subtitle">{{ authStore.user.email }}</p>
      </div>
    </div>

    <!-- Guest Header -->
    <div v-else class="guest-card">
      <div class="guest-meta">
        <h3 class="user-name">Гостевой режим</h3>
        <p class="user-subtitle">Войдите, чтобы синхронизировать холодильник и рецепты</p>
      </div>
      <div class="guest-actions">
        <router-link to="/login">
          <van-button round size="small" type="primary" color="#2e7d32">Войти</van-button>
        </router-link>
        <router-link to="/register">
          <van-button round size="small" plain type="primary" color="#2e7d32">Регистрация</van-button>
        </router-link>
      </div>
    </div>

    <!-- Settings Group -->
    <van-cell-group inset title="Диетические ограничения">
      <van-cell
        title="Продукт-исключение (Аллергия)"
        :value="currentAllergenName"
        is-link
        label="1 бесплатный продукт в MVP"
        @click="openAllergenPicker"
      />
      <van-cell title="Базовая корзина" :value="pantryNames.length ? pantryNames.join(', ') : 'Не настроена'" is-link @click="openPantryPicker" />
    </van-cell-group>

    <van-cell-group inset title="Уведомления и система" class="settings-group">
      <van-cell
        center
        title="Уведомления о сроках годности"
        label="Web Push напоминания за 1-2 дня"
      >
        <template #right-icon>
          <van-switch
            :model-value="notificationStore.isSubscribed"
            :loading="notificationStore.isLoading"
            size="22px"
            active-color="#2e7d32"
            @update:model-value="onNotificationSwitch"
          />
        </template>
      </van-cell>
      <van-cell
        v-if="pwaStore.canInstall"
        title="Установить WhatCook"
        value="На экран телефона"
        is-link
        @click="pwaStore.installApp"
      />
      <van-cell
        title="Режим работы"
        :value="pwaStore.isInstalled ? 'Установлено (Standalone)' : 'PWA (Браузер)'"
      />
      <van-cell title="Локальная база" value="IndexedDB / Dexie.js" />
      <van-cell
        title="Перевод рецептов"
        :value="translationStatusText"
        :label="translationStatusHint"
        is-link
        @click="refreshTranslationStatus"
      />
      <van-cell title="О приложении" value="WhatCook v0.1.7" />
    </van-cell-group>

    <!-- Logout Action for Authenticated User -->
    <div v-if="authStore.isAuthenticated" class="logout-wrapper">
      <van-button round block plain type="danger" @click="handleLogout">
        Выйти из аккаунта
      </van-button>
    </div>

    <!-- Allergen Picker Popup -->
    <van-popup
      v-model:show="showAllergenSheet"
      round
      position="bottom"
      :style="{ height: '70%' }"
      closeable
    >
      <div class="popup-content">
        <h4 class="popup-title">Выберите продукт-исключение</h4>
        <van-search
          v-model="searchQuery"
          placeholder="Поиск ингредиента..."
          shape="round"
          class="popup-search"
        />

        <div class="ingredient-list">
          <van-cell
            v-if="authStore.primaryAllergenId"
            title="Сбросить исключение"
            class="reset-cell"
            @click="selectAllergen(null)"
          >
            <template #right-icon>
              <van-icon name="cross" color="#f44336" />
            </template>
          </van-cell>

          <van-cell
            v-for="item in filteredIngredients"
            :key="item.id"
            :title="displayIngredientName(item.name, item.nameEn)"
            :label="displayText(item.category)"
            clickable
            @click="selectAllergen(item.id)"
          >
            <template #right-icon>
              <van-icon
                v-if="authStore.primaryAllergenId === item.id"
                name="success"
                color="#2e7d32"
              />
            </template>
          </van-cell>

          <van-empty
            v-if="filteredIngredients.length === 0 && !isLoadingIngredients"
            description="Ничего не найдено"
          />
        </div>
      </div>
    </van-popup>

    <van-popup v-model:show="showPantrySheet" round position="bottom" :style="{ height: '70%' }" closeable>
      <div class="popup-content">
        <h4 class="popup-title">Продукты, которые обычно есть дома</h4>
        <van-search v-model="searchQuery" placeholder="Поиск ингредиента..." shape="round" class="popup-search" />
        <div class="ingredient-list">
          <van-cell v-for="item in filteredIngredients" :key="item.id" :title="displayIngredientName(item.name, item.nameEn)" :label="displayText(item.category)" clickable @click="togglePantry(item.id)">
            <template #right-icon><van-checkbox :model-value="authStore.user?.pantryIngredientIds.includes(item.id) ?? false" /></template>
          </van-cell>
        </div>
      </div>
    </van-popup>
  </div>
</template>

<style scoped>
.view-container {
  padding: 16px 0 80px;
}

.user-card,
.guest-card {
  display: flex;
  flex-direction: column;
  padding: 16px;
  margin: 0 16px 16px;
  background-color: var(--van-background-2);
  border-radius: 12px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.user-card {
  flex-direction: row;
  align-items: center;
}

.user-meta {
  margin-left: 16px;
}

.guest-card {
  gap: 12px;
}

.guest-actions {
  display: flex;
  gap: 10px;
}

.user-name {
  font-size: 18px;
  font-weight: 600;
  margin-bottom: 4px;
}

.user-subtitle {
  font-size: 13px;
  color: #969799;
}

.settings-group {
  margin-top: 16px;
}

.logout-wrapper {
  margin: 24px 16px;
}

.popup-content {
  padding-top: 16px;
  display: flex;
  flex-direction: column;
  height: 100%;
}

.popup-title {
  text-align: center;
  font-size: 16px;
  font-weight: 600;
  margin-bottom: 8px;
}

.popup-search {
  padding: 4px 16px;
}

.ingredient-list {
  flex: 1;
  overflow-y: auto;
  margin-top: 8px;
}

.reset-cell {
  color: #f44336;
  font-weight: 500;
}
</style>
