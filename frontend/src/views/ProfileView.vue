<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useNotificationStore } from '@/stores/notification'
import { usePwaStore } from '@/stores/pwa'
import { useToastStore } from '@/stores/toast'
import { getIngredientsApi } from '@/api/ingredients'
import { getImageUrl } from '@/utils/imageUrl'
import { getInitials, getAvatarColor } from '@/utils/avatar'
import { showLocalTestNotification } from '@/utils/push'
import type { Ingredient } from '@/types/api'
import BaseBottomSheet from '@/components/common/BaseBottomSheet.vue'
import BaseConfirmDialog from '@/components/common/BaseConfirmDialog.vue'
import {
  Camera,
  User,
  ShieldAlert,
  ShoppingBag,
  Bell,
  Download,
  Info,
  LogOut,
  ChevronRight,
  Search,
  Check,
  X
} from 'lucide-vue-next'

const router = useRouter()
const authStore = useAuthStore()
const notificationStore = useNotificationStore()
const pwaStore = usePwaStore()
const toast = useToastStore()

const fileInputRef = ref<HTMLInputElement | null>(null)
const isUploadingAvatar = ref(false)

const showAllergenSheet = ref(false)
const showPantrySheet = ref(false)
const showDeleteAvatarConfirm = ref(false)
const showLogoutConfirm = ref(false)
const searchQuery = ref('')
const ingredients = ref<Ingredient[]>([])
const isLoadingIngredients = ref(false)

const currentAllergenName = computed(() => {
  const allergenId = authStore.primaryAllergenId
  if (!allergenId) return 'Не выбрано'
  const found = ingredients.value.find((item) => item.id === allergenId)
  return found ? (found.name || `ID: ${allergenId}`) : `ID: ${allergenId}`
})

const pantryNames = computed(() =>
  ingredients.value
    .filter((i) => authStore.user?.pantryIngredientIds.includes(i.id))
    .map((i) => i.name)
)

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

async function onFileSelected(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  const validTypes = ['image/jpeg', 'image/png', 'image/webp']
  if (!validTypes.includes(file.type)) {
    toast.show('Формат должен быть JPG, PNG или WebP', 'fail')
    if (fileInputRef.value) fileInputRef.value.value = ''
    return
  }

  if (file.size > 5 * 1024 * 1024) {
    toast.show('Размер файла не должен превышать 5 МБ', 'fail')
    if (fileInputRef.value) fileInputRef.value.value = ''
    return
  }

  isUploadingAvatar.value = true
  try {
    await authStore.uploadAvatar(file)
    toast.show('Аватар успешно обновлен', 'success')
  } catch (err: any) {
    const msg = err.response?.data?.error || 'Не удалось загрузить аватар'
    toast.show(msg, 'fail')
  } finally {
    isUploadingAvatar.value = false
    if (fileInputRef.value) fileInputRef.value.value = ''
  }
}

function confirmDeleteAvatar() {
  showDeleteAvatarConfirm.value = true
}

async function onConfirmDeleteAvatar() {
  showDeleteAvatarConfirm.value = false
  await authStore.deleteAvatar()
  toast.show('Аватар удален', 'success')
}

async function loadIngredients() {
  if (ingredients.value.length > 0) return
  isLoadingIngredients.value = true
  try {
    ingredients.value = await getIngredientsApi()
  } catch {
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
    toast.show('Войдите, чтобы сохранить продукт-исключение', 'info')
    router.push('/login')
    return
  }
  loadIngredients()
  showAllergenSheet.value = true
}

async function selectAllergen(id: number | null) {
  try {
    await authStore.setAllergen(id)
    toast.show(id ? 'Аллерген сохранен' : 'Исключение снято', 'success')
    showAllergenSheet.value = false
  } catch (err: any) {
    const msg = err.response?.data?.error || 'Не удалось обновить исключение'
    toast.show(msg, 'fail')
  }
}

async function togglePantry(id: number) {
  const current = authStore.user?.pantryIngredientIds ?? []
  const next = current.includes(id) ? current.filter((val) => val !== id) : [...current, id]
  try {
    await authStore.setPantry(next)
    toast.show('Базовая корзина сохранена', 'success')
  } catch {
    toast.show('Не удалось сохранить базовую корзину', 'fail')
  }
}

function openPantryPicker() {
  if (!authStore.isAuthenticated) {
    toast.show('Войдите, чтобы настроить базовую корзину', 'info')
    router.push('/login')
    return
  }
  loadIngredients()
  showPantrySheet.value = true
}

async function onNotificationToggle() {
  if (!authStore.isAuthenticated) {
    toast.show('Войдите в аккаунт, чтобы получать уведомления', 'info')
    router.push('/login')
    return
  }

  if (!notificationStore.isSubscribed) {
    const ok = await notificationStore.enableNotifications()
    if (ok) {
      toast.show('Уведомления включены', 'success')
    } else {
      if (notificationStore.permission === 'denied') {
        toast.show('Разрешите уведомления в настройках браузера', 'fail')
      } else {
        toast.show('Уведомления не подключены', 'info')
      }
    }
  } else {
    await notificationStore.disableNotifications()
    toast.show('Уведомления отключены', 'info')
  }
}

async function handleTestNotification() {
  const sent = await showLocalTestNotification()
  if (sent) {
    toast.show('Тестовое уведомление отправлено', 'success')
  } else {
    toast.show('Не удалось показать уведомление. Проверьте настройки браузера.', 'fail')
  }
}

function handleLogout() {
  showLogoutConfirm.value = true
}

async function onConfirmLogout() {
  showLogoutConfirm.value = false
  await authStore.logout()
  toast.show('Вы вышли из системы', 'success')
}

onMounted(() => {
  loadIngredients()
  notificationStore.checkSubscription()
})
</script>

<template>
  <div class="min-h-full pb-28 px-4 pt-3 flex flex-col gap-4">
    <!-- User Profile Card -->
    <div
      v-if="authStore.isAuthenticated && authStore.user"
      class="p-4 rounded-3xl bg-white border border-slate-200/80 shadow-xs flex items-center gap-4"
    >
      <!-- Avatar -->
      <div class="relative cursor-pointer select-none" @click="triggerFileInput">
        <img
          v-if="authStore.user.avatarUrl"
          :src="getImageUrl(authStore.user.avatarUrl)"
          :alt="authStore.user.name"
          class="w-16 h-16 rounded-full object-cover border-2 border-emerald-800 shadow-sm"
        />
        <div
          v-else
          class="w-16 h-16 rounded-full flex items-center justify-center text-white text-xl font-bold border-2 border-emerald-800 shadow-sm"
          :style="{ backgroundColor: getAvatarColor(authStore.user.name) }"
        >
          {{ getInitials(authStore.user.name) }}
        </div>

        <button
          type="button"
          class="absolute -bottom-1 -right-1 w-6 h-6 rounded-full bg-emerald-950 text-white flex items-center justify-center border-2 border-white shadow-xs"
          aria-label="Сменить фото"
        >
          <Camera class="w-3 h-3" />
        </button>

        <input
          ref="fileInputRef"
          type="file"
          accept="image/jpeg,image/png,image/webp"
          class="hidden"
          @change="onFileSelected"
        />
      </div>

      <div class="flex flex-col min-w-0 flex-1">
        <h3 class="text-base font-bold text-slate-900 truncate">
          {{ authStore.user.name }}
        </h3>
        <p class="text-xs text-slate-400 truncate">
          {{ authStore.user.email }}
        </p>
        <button
          v-if="authStore.user.avatarUrl"
          type="button"
          class="text-xs text-rose-600 font-medium text-left mt-1 hover:underline"
          @click="confirmDeleteAvatar"
        >
          Удалить фото
        </button>
      </div>
    </div>

    <!-- Guest Banner -->
    <div
      v-else
      class="p-4 rounded-3xl bg-white border border-slate-200/80 shadow-xs flex flex-col gap-3"
    >
      <div class="flex items-center gap-3">
        <div class="w-12 h-12 rounded-2xl bg-slate-100 text-slate-500 flex items-center justify-center">
          <User class="w-6 h-6 stroke-[1.8px]" />
        </div>
        <div class="flex flex-col">
          <h3 class="text-sm font-bold text-slate-900">Гостевой режим</h3>
          <p class="text-xs text-slate-500">Войдите для синхронизации с облаком</p>
        </div>
      </div>
      <div class="grid grid-cols-2 gap-2 pt-1">
        <RouterLink
          to="/login"
          class="py-2.5 px-3 rounded-xl bg-emerald-950 text-white text-xs font-bold text-center hover:bg-emerald-900 transition-all"
        >
          Войти
        </RouterLink>
        <RouterLink
          to="/register"
          class="py-2.5 px-3 rounded-xl bg-emerald-50 text-emerald-900 border border-emerald-200 text-xs font-bold text-center hover:bg-emerald-100 transition-all"
        >
          Регистрация
        </RouterLink>
      </div>
    </div>

    <!-- Dietary Constraints Group -->
    <div class="rounded-3xl bg-white border border-slate-200/80 shadow-xs overflow-hidden divide-y divide-slate-100">
      <div class="px-4 py-3 bg-slate-50/50">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">
          Диетические ограничения
        </span>
      </div>

      <!-- Exclusion Allergen -->
      <div
        class="px-4 py-3.5 flex items-center justify-between cursor-pointer hover:bg-slate-50 transition-colors"
        @click="openAllergenPicker"
      >
        <div class="flex items-center gap-3 min-w-0 flex-1">
          <ShieldAlert class="w-5 h-5 text-emerald-800 shrink-0 stroke-[2px]" />
          <div class="flex flex-col min-w-0">
            <span class="text-sm font-semibold text-slate-800 leading-tight">Продукт-исключение</span>
            <span class="text-xs text-slate-400">1 бесплатный продукт в MVP</span>
          </div>
        </div>
        <div class="flex items-center gap-1.5 shrink-0">
          <span class="text-xs font-bold text-emerald-800">{{ currentAllergenName }}</span>
          <ChevronRight class="w-4 h-4 text-slate-300" />
        </div>
      </div>

      <!-- Pantry Essentials -->
      <div
        class="px-4 py-3.5 flex items-center justify-between cursor-pointer hover:bg-slate-50 transition-colors"
        @click="openPantryPicker"
      >
        <div class="flex items-center gap-3 min-w-0 flex-1">
          <ShoppingBag class="w-5 h-5 text-emerald-800 shrink-0 stroke-[2px]" />
          <div class="flex flex-col min-w-0">
            <span class="text-sm font-semibold text-slate-800 leading-tight">Базовая корзина</span>
            <span class="text-xs text-slate-400 truncate max-w-[200px]">
              {{ pantryNames.length ? pantryNames.join(', ') : 'Не настроена' }}
            </span>
          </div>
        </div>
        <div class="flex items-center gap-1.5 shrink-0">
          <ChevronRight class="w-4 h-4 text-slate-300" />
        </div>
      </div>
    </div>

    <!-- Notifications & App Info Group -->
    <div class="rounded-3xl bg-white border border-slate-200/80 shadow-xs overflow-hidden divide-y divide-slate-100">
      <div class="px-4 py-3 bg-slate-50/50">
        <span class="text-xs font-bold text-slate-500 uppercase tracking-wider">
          Уведомления и система
        </span>
      </div>

      <!-- Web Push Switch -->
      <div class="px-4 py-3.5 flex items-center justify-between">
        <div class="flex items-center gap-3 min-w-0 flex-1">
          <Bell class="w-5 h-5 text-emerald-800 shrink-0 stroke-[2px]" />
          <div class="flex flex-col">
            <span class="text-sm font-semibold text-slate-800 leading-tight">Сроки годности</span>
            <span class="text-xs text-slate-400">Web Push напоминания</span>
          </div>
        </div>
        <button
          type="button"
          class="w-11 h-6 rounded-full transition-colors p-0.5 relative"
          :class="notificationStore.isSubscribed ? 'bg-emerald-800' : 'bg-slate-300'"
          @click="onNotificationToggle"
        >
          <div
            class="w-5 h-5 rounded-full bg-white transition-transform"
            :class="notificationStore.isSubscribed ? 'translate-x-5' : 'translate-x-0'"
          />
        </button>
      </div>

      <!-- Test Push Notification -->
      <div
        v-if="notificationStore.isSubscribed"
        class="px-4 py-3 flex items-center justify-between cursor-pointer hover:bg-slate-50 transition-colors"
        @click="handleTestNotification"
      >
        <span class="text-xs font-semibold text-slate-700">Тестовое уведомление</span>
        <span class="text-xs font-bold text-emerald-800">Отправить</span>
      </div>

      <!-- PWA Install -->
      <div
        v-if="pwaStore.canInstall"
        class="px-4 py-3.5 flex items-center justify-between cursor-pointer hover:bg-slate-50 transition-colors"
        @click="pwaStore.installApp"
      >
        <div class="flex items-center gap-3">
          <Download class="w-5 h-5 text-emerald-800 stroke-[2px]" />
          <span class="text-sm font-semibold text-slate-800">Установить WhatCook</span>
        </div>
        <span class="text-xs font-bold text-emerald-800">На экран</span>
      </div>

      <!-- System Badges -->
      <div class="px-4 py-3 flex items-center justify-between text-xs text-slate-600">
        <span class="flex items-center gap-2">
          <Info class="w-4 h-4 text-slate-400" />
          Режим работы
        </span>
        <span class="font-semibold">{{ pwaStore.isInstalled ? 'Standalone PWA' : 'Браузер' }}</span>
      </div>

      <div class="px-4 py-3 flex items-center justify-between text-xs text-slate-600">
        <span class="text-slate-500">Версия приложения</span>
        <span class="font-bold text-emerald-950">WhatCook v0.9.2</span>
      </div>
    </div>

    <!-- Logout Button for Authenticated User -->
    <button
      v-if="authStore.isAuthenticated"
      type="button"
      class="w-full py-3.5 px-4 rounded-2xl bg-rose-50 border border-rose-200/80 text-rose-700 text-sm font-bold flex items-center justify-center gap-2 hover:bg-rose-100 active:scale-98 transition-all"
      @click="handleLogout"
    >
      <LogOut class="w-4 h-4" />
      <span>Выйти из аккаунта</span>
    </button>

    <!-- Allergen Picker Bottom Sheet -->
    <BaseBottomSheet
      v-model:show="showAllergenSheet"
      title="Выберите продукт-исключение"
    >
      <div class="flex flex-col gap-3">
        <div class="relative flex items-center">
          <Search class="absolute left-3 w-4 h-4 text-slate-400" />
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Поиск ингредиента..."
            class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-emerald-700/20"
          />
        </div>

        <button
          v-if="authStore.primaryAllergenId"
          type="button"
          class="py-2 px-3 rounded-xl bg-rose-50 text-rose-700 text-xs font-semibold flex items-center justify-between hover:bg-rose-100 transition-colors"
          @click="selectAllergen(null)"
        >
          <span>Сбросить исключение</span>
          <X class="w-4 h-4" />
        </button>

        <div class="max-h-72 overflow-y-auto divide-y divide-slate-100 flex flex-col">
          <button
            v-for="item in filteredIngredients"
            :key="item.id"
            type="button"
            class="py-2.5 px-2 text-left flex items-center justify-between hover:bg-emerald-50/50 transition-colors"
            @click="selectAllergen(item.id)"
          >
            <div class="flex flex-col">
              <span class="text-xs font-semibold text-slate-800">{{ item.name }}</span>
              <span class="text-[10px] text-slate-400">{{ item.category }}</span>
            </div>
            <Check
              v-if="authStore.primaryAllergenId === item.id"
              class="w-4 h-4 text-emerald-800 stroke-[3px]"
            />
          </button>
        </div>
      </div>
    </BaseBottomSheet>

    <!-- Pantry Picker Bottom Sheet -->
    <BaseBottomSheet
      v-model:show="showPantrySheet"
      title="Базовая корзина (всегда дома)"
    >
      <div class="flex flex-col gap-3">
        <div class="relative flex items-center">
          <Search class="absolute left-3 w-4 h-4 text-slate-400" />
          <input
            v-model="searchQuery"
            type="text"
            placeholder="Поиск ингредиента..."
            class="w-full pl-9 pr-3 py-2 bg-slate-50 border border-slate-200 rounded-xl text-xs focus:outline-none focus:ring-2 focus:ring-emerald-700/20"
          />
        </div>

        <div class="max-h-72 overflow-y-auto divide-y divide-slate-100 flex flex-col">
          <button
            v-for="item in filteredIngredients"
            :key="item.id"
            type="button"
            class="py-2.5 px-2 text-left flex items-center justify-between hover:bg-emerald-50/50 transition-colors"
            @click="togglePantry(item.id)"
          >
            <div class="flex flex-col">
              <span class="text-xs font-semibold text-slate-800">{{ item.name }}</span>
              <span class="text-[10px] text-slate-400">{{ item.category }}</span>
            </div>
            <div
              class="w-5 h-5 rounded-md border flex items-center justify-center transition-all"
              :class="
                authStore.user?.pantryIngredientIds.includes(item.id)
                  ? 'bg-emerald-950 text-white border-emerald-950'
                  : 'bg-white border-slate-300'
              "
            >
              <Check
                v-if="authStore.user?.pantryIngredientIds.includes(item.id)"
                class="w-3.5 h-3.5 stroke-[3px]"
              />
            </div>
          </button>
        </div>
      </div>
    </BaseBottomSheet>

    <!-- Logout Confirmation Modal (Figma Row 7) -->
    <BaseConfirmDialog
      v-model:show="showLogoutConfirm"
      title="Выйти из аккаунта?"
      message="Ваши данные останутся сохранены в облаке и будут доступны при следующем входе."
      confirm-text="Выйти"
      cancel-text="Отмена"
      type="danger"
      @confirm="onConfirmLogout"
    />

    <!-- Avatar Delete Confirmation Modal -->
    <BaseConfirmDialog
      v-model:show="showDeleteAvatarConfirm"
      title="Удалить фото профиля?"
      message="Фотография профиля будет удалена, вместо нее будут отображаться ваши инициалы."
      confirm-text="Удалить"
      cancel-text="Отмена"
      type="danger"
      @confirm="onConfirmDeleteAvatar"
    />
  </div>
</template>
