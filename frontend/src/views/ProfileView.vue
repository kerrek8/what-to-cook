<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { showToast, showConfirmDialog } from 'vant'
import { useAuthStore } from '@/stores/auth'
import { useNotificationStore } from '@/stores/notification'
import { usePwaStore } from '@/stores/pwa'
import { getIngredientsApi } from '@/api/ingredients'
import { getImageUrl } from '@/utils/imageUrl'
import { getInitials, getAvatarColor } from '@/utils/avatar'
import type { Ingredient } from '@/types/api'

const router = useRouter()
const authStore = useAuthStore()
const notificationStore = useNotificationStore()
const pwaStore = usePwaStore()

const fileInputRef = ref<HTMLInputElement | null>(null)
const isUploadingAvatar = ref(false)
const showAvatarSheet = ref(false)

const showAllergenSheet = ref(false)
const showPantrySheet = ref(false)
const searchQuery = ref('')
const ingredients = ref<Ingredient[]>([])
const isLoadingIngredients = ref(false)

const avatarActions = computed(() => {
  const actions: Array<{ name: string; color?: string }> = [
    { name: 'Загрузить новое фото', color: '#1E3A2F' }
  ]
  if (authStore.user?.avatarUrl) {
    actions.push({ name: 'Удалить фото', color: '#f44336' })
  }
  return actions
})

const currentAllergenName = computed(() => {
  const allergenId = authStore.primaryAllergenId
  if (!allergenId) return 'Не выбрано'
  const found = ingredients.value.find((item) => item.id === allergenId)
  return found ? (found.name || `ID: ${allergenId}`) : `ID: ${allergenId}`
})
const pantryNames = computed(() => ingredients.value.filter(i => authStore.user?.pantryIngredientIds.includes(i.id)).map(i => i.name))

const filteredIngredients = computed(() => {
  const q = searchQuery.value.trim().toLowerCase()
  if (!q) return ingredients.value
  return ingredients.value.filter(
    (item) =>
      item.name.toLowerCase().includes(q) ||
      item.category.toLowerCase().includes(q)
  )
})

function triggerFileInput() {
  fileInputRef.value?.click()
}

function onAvatarClick() {
  if (authStore.user?.avatarUrl) {
    showAvatarSheet.value = true
  } else {
    triggerFileInput()
  }
}

function onSelectAvatarAction(action: { name: string }) {
  showAvatarSheet.value = false
  if (action.name === 'Загрузить новое фото') {
    triggerFileInput()
  } else if (action.name === 'Удалить фото') {
    handleDeleteAvatar()
  }
}

async function onFileSelected(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  const validTypes = ['image/jpeg', 'image/png', 'image/webp']
  if (!validTypes.includes(file.type)) {
    showToast({ type: 'fail', message: 'Формат должен быть JPG, PNG или WebP' })
    if (fileInputRef.value) fileInputRef.value.value = ''
    return
  }

  if (file.size > 5 * 1024 * 1024) {
    showToast({ type: 'fail', message: 'Размер файла не должен превышать 5 МБ' })
    if (fileInputRef.value) fileInputRef.value.value = ''
    return
  }

  isUploadingAvatar.value = true
  try {
    await authStore.uploadAvatar(file)
    showToast({ type: 'success', message: 'Аватар успешно обновлен' })
  } catch (err: any) {
    const msg = err.response?.data?.error || 'Не удалось загрузить аватар'
    showToast({ type: 'fail', message: msg })
  } finally {
    isUploadingAvatar.value = false
    if (fileInputRef.value) fileInputRef.value.value = ''
  }
}

async function handleDeleteAvatar() {
  try {
    await showConfirmDialog({
      title: 'Удалить аватар',
      message: 'Вы уверены, что хотите удалить фото профиля?',
      confirmButtonText: 'Удалить',
      confirmButtonColor: '#f44336',
      cancelButtonText: 'Отмена'
    })
    await authStore.deleteAvatar()
    showToast({ type: 'success', message: 'Аватар удален' })
  } catch {
    // Cancelled dialog
  }
}

async function loadIngredients() {
  if (ingredients.value.length > 0) return
  isLoadingIngredients.value = true
  try {
    ingredients.value = await getIngredientsApi()
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
  notificationStore.checkSubscription()
})
</script>

<template>
  <div class="view-container">
    <!-- Authenticated Header -->
    <div v-if="authStore.isAuthenticated && authStore.user" class="user-card">
      <div class="avatar-wrapper">
        <div class="avatar-container" @click="onAvatarClick">
          <img
            v-if="authStore.user.avatarUrl"
            :src="getImageUrl(authStore.user.avatarUrl)"
            :alt="authStore.user.name"
            class="avatar-img"
          />
          <div
            v-else
            class="avatar-placeholder"
            :style="{ backgroundColor: getAvatarColor(authStore.user.name) }"
          >
            <span class="avatar-initials">{{ getInitials(authStore.user.name) }}</span>
          </div>

          <div v-if="isUploadingAvatar" class="avatar-loading-overlay">
            <van-loading size="20px" color="#ffffff" />
          </div>

          <button
            type="button"
            class="avatar-upload-badge"
            aria-label="Сменить фото"
            @click.stop="triggerFileInput"
          >
            <van-icon name="photograph" size="13px" color="#ffffff" />
          </button>
        </div>

        <input
          ref="fileInputRef"
          type="file"
          accept="image/jpeg,image/png,image/webp"
          class="hidden-file-input"
          @change="onFileSelected"
        />
      </div>

      <div class="user-meta">
        <h3 class="user-name">{{ authStore.user.name }}</h3>
        <p class="user-subtitle">{{ authStore.user.email }}</p>
        <button
          v-if="authStore.user.avatarUrl"
          type="button"
          class="avatar-delete-link"
          @click="handleDeleteAvatar"
        >
          Удалить фото
        </button>
      </div>
    </div>

    <!-- Guest Header -->
    <div v-else class="guest-card">
      <div class="guest-top">
        <div class="avatar-container guest-avatar">
          <van-icon name="user-o" size="28px" color="#969799" />
        </div>
        <div class="guest-meta">
          <h3 class="user-name">Гостевой режим</h3>
          <p class="user-subtitle">Войдите, чтобы синхронизировать холодильник и рецепты</p>
        </div>
      </div>
      <div class="guest-actions">
        <router-link to="/login">
          <van-button round size="small" type="primary" color="#1E3A2F">Войти</van-button>
        </router-link>
        <router-link to="/register">
          <van-button round size="small" plain type="primary" color="#1E3A2F">Регистрация</van-button>
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
            active-color="#1E3A2F"
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
      <van-cell title="Каталог рецептов" value="Русская кухня + Sber GigaChat" />
      <van-cell title="О приложении" value="WhatCook v0.8.1" />
    </van-cell-group>

    <!-- Logout Action for Authenticated User -->
    <div v-if="authStore.isAuthenticated" class="logout-wrapper">
      <van-button round block plain type="danger" @click="handleLogout">
        Выйти из аккаунта
      </van-button>
    </div>

    <!-- Avatar Actions Sheet -->
    <van-action-sheet
      v-model:show="showAvatarSheet"
      :actions="avatarActions"
      cancel-text="Отмена"
      close-on-click-action
      @select="onSelectAvatarAction"
    />

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
            :title="item.name"
            :label="item.category"
            clickable
            @click="selectAllergen(item.id)"
          >
            <template #right-icon>
              <van-icon
                v-if="authStore.primaryAllergenId === item.id"
                name="success"
                color="#1E3A2F"
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
          <van-cell v-for="item in filteredIngredients" :key="item.id" :title="item.name" :label="item.category" clickable @click="togglePantry(item.id)">
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
  border-radius: 20px;
  box-shadow: 0 4px 20px -2px rgba(30, 58, 47, 0.06);
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.user-card {
  flex-direction: row;
  align-items: center;
}

.avatar-wrapper {
  position: relative;
  flex-shrink: 0;
}

.avatar-container {
  position: relative;
  width: 64px;
  height: 64px;
  border-radius: 50%;
  cursor: pointer;
  flex-shrink: 0;
}

.avatar-img {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  object-fit: cover;
  display: block;
}

.avatar-placeholder {
  width: 64px;
  height: 64px;
  border-radius: 50%;
  display: flex;
  align-items: center;
  justify-content: center;
  user-select: none;
}

.avatar-initials {
  color: #ffffff;
  font-size: 22px;
  font-weight: 600;
  letter-spacing: 0.5px;
  line-height: 1;
}

.avatar-loading-overlay {
  position: absolute;
  inset: 0;
  border-radius: 50%;
  background-color: rgba(0, 0, 0, 0.45);
  display: flex;
  align-items: center;
  justify-content: center;
}

.avatar-upload-badge {
  position: absolute;
  bottom: -2px;
  right: -2px;
  width: 24px;
  height: 24px;
  border-radius: 50%;
  background-color: #1E3A2F;
  border: 2px solid var(--van-background-2, #ffffff);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.2);
  padding: 0;
  transition: transform 0.15s ease;
}

.avatar-upload-badge:active {
  transform: scale(0.92);
}

.hidden-file-input {
  display: none;
}

.avatar-delete-link {
  background: none;
  border: none;
  padding: 0;
  margin-top: 4px;
  font-size: 12px;
  color: #f44336;
  cursor: pointer;
  display: inline-block;
  text-align: left;
}

.user-meta {
  margin-left: 16px;
  display: flex;
  flex-direction: column;
}

.guest-card {
  gap: 12px;
}

.guest-top {
  display: flex;
  align-items: center;
  gap: 14px;
}

.guest-avatar {
  background-color: var(--van-gray-2, #f2f3f5);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: default;
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
