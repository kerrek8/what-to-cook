<script setup lang="ts">
import { ref, reactive } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useToastStore } from '@/stores/toast'
import { User, Mail, Lock, ArrowRight, ArrowLeft, Eye, EyeOff } from 'lucide-vue-next'
import BrandLogo from '@/components/common/BrandLogo.vue'

const router = useRouter()
const authStore = useAuthStore()
const toast = useToastStore()

const name = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const showPassword = ref(false)
const showConfirmPassword = ref(false)
const isSubmitting = ref(false)

const errors = reactive({
  name: '',
  email: '',
  password: '',
  confirmPassword: ''
})

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function validateName() {
  const trimmed = name.value.trim()
  if (!trimmed || trimmed.length < 2) {
    errors.name = 'Укажите имя (минимум 2 символа)'
    return false
  }
  errors.name = ''
  return true
}

function validateEmail() {
  const trimmed = email.value.trim()
  if (!trimmed) {
    errors.email = 'Укажите email'
    return false
  }
  if (!emailPattern.test(trimmed)) {
    errors.email = 'Укажите корректный email'
    return false
  }
  errors.email = ''
  return true
}

function validatePassword() {
  if (!password.value || password.value.length < 6) {
    errors.password = 'Пароль должен быть не менее 6 символов'
    return false
  }
  errors.password = ''
  return true
}

function validateConfirmPassword() {
  if (confirmPassword.value !== password.value) {
    errors.confirmPassword = 'Пароли не совпадают'
    return false
  }
  errors.confirmPassword = ''
  return true
}

async function onSubmit() {
  const nameOk = validateName()
  const emailOk = validateEmail()
  const passOk = validatePassword()
  const confirmOk = validateConfirmPassword()

  if (!nameOk || !emailOk || !passOk || !confirmOk) {
    return
  }

  isSubmitting.value = true
  try {
    await authStore.register({
      name: name.value.trim(),
      email: email.value.trim(),
      password: password.value
    })
    toast.show('Регистрация успешна!', 'success')
    router.replace('/profile')
  } catch (err: any) {
    const message = err.response?.data?.error || 'Ошибка при регистрации'
    toast.show(message, 'fail')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="min-h-full flex flex-col bg-slate-50">
    <!-- Emerald Hero Header Banner (Figma Row 8) -->
    <div
      class="relative bg-gradient-to-br from-emerald-950 via-emerald-900 to-emerald-950 text-white pt-10 pb-14 px-6 overflow-hidden safe-area-top"
    >
      <button
        type="button"
        class="absolute top-4 left-4 p-2.5 text-emerald-200 hover:text-white rounded-full bg-white/10 active:scale-95 transition-all"
        aria-label="Назад"
        @click="router.back()"
      >
        <ArrowLeft class="w-5 h-5 stroke-[2.5px]" />
      </button>

      <div class="flex flex-col items-center text-center mt-2">
        <BrandLogo size="lg" />
        <h1 class="text-2xl font-black tracking-tight text-white mt-3">
          Создание аккаунта
        </h1>
        <p class="text-xs text-emerald-200/90 mt-1 max-w-xs">
          Создайте аккаунт, чтобы сохранять продукты и рецепты
        </p>
      </div>
    </div>

    <!-- Registration Form Card pulling up -->
    <div
      class="-mt-6 bg-white rounded-t-3xl px-6 pt-7 pb-12 flex-1 shadow-lg max-w-md mx-auto w-full"
    >
      <form class="flex flex-col gap-3.5" @submit.prevent="onSubmit">
        <!-- Name -->
        <div>
          <label class="block text-xs font-semibold text-slate-700 mb-1">Имя</label>
          <div class="relative flex items-center">
            <User class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
            <input
              v-model="name"
              type="text"
              autocomplete="name"
              placeholder="Как вас зовут?"
              class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-50 border text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white shadow-xs transition-all"
              :class="errors.name ? 'border-red-500 bg-red-50/20' : 'border-slate-200'"
              @blur="validateName"
            />
          </div>
          <p v-if="errors.name" class="text-xs text-red-600 mt-1">
            {{ errors.name }}
          </p>
        </div>

        <!-- Email -->
        <div>
          <label class="block text-xs font-semibold text-slate-700 mb-1">Email</label>
          <div class="relative flex items-center">
            <Mail class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
            <input
              v-model="email"
              type="email"
              autocomplete="email"
              placeholder="ivan@example.com"
              class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-50 border text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white shadow-xs transition-all"
              :class="errors.email ? 'border-red-500 bg-red-50/20' : 'border-slate-200'"
              @blur="validateEmail"
            />
          </div>
          <p v-if="errors.email" class="text-xs text-red-600 mt-1">
            {{ errors.email }}
          </p>
        </div>

        <!-- Password -->
        <div>
          <label class="block text-xs font-semibold text-slate-700 mb-1">Пароль</label>
          <div class="relative flex items-center">
            <Lock class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
            <input
              v-model="password"
              :type="showPassword ? 'text' : 'password'"
              autocomplete="new-password"
              placeholder="Минимум 6 символов"
              class="w-full pl-10 pr-11 py-2.5 rounded-xl bg-slate-50 border text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white shadow-xs transition-all"
              :class="errors.password ? 'border-red-500 bg-red-50/20' : 'border-slate-200'"
              @blur="validatePassword"
            />
            <button
              type="button"
              class="absolute right-2.5 p-1.5 text-slate-400 hover:text-slate-600 active:scale-95 transition-all"
              :aria-label="showPassword ? 'Скрыть пароль' : 'Показать пароль'"
              @click="showPassword = !showPassword"
            >
              <EyeOff v-if="showPassword" class="w-4 h-4 stroke-[2px]" />
              <Eye v-else class="w-4 h-4 stroke-[2px]" />
            </button>
          </div>
          <p v-if="errors.password" class="text-xs text-red-600 mt-1">
            {{ errors.password }}
          </p>
        </div>

        <!-- Confirm Password -->
        <div>
          <label class="block text-xs font-semibold text-slate-700 mb-1">Повторите пароль</label>
          <div class="relative flex items-center">
            <Lock class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
            <input
              v-model="confirmPassword"
              :type="showConfirmPassword ? 'text' : 'password'"
              autocomplete="new-password"
              placeholder="Повторите пароль"
              class="w-full pl-10 pr-11 py-2.5 rounded-xl bg-slate-50 border text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white shadow-xs transition-all"
              :class="errors.confirmPassword ? 'border-red-500 bg-red-50/20' : 'border-slate-200'"
              @blur="validateConfirmPassword"
            />
            <button
              type="button"
              class="absolute right-2.5 p-1.5 text-slate-400 hover:text-slate-600 active:scale-95 transition-all"
              :aria-label="showConfirmPassword ? 'Скрыть пароль' : 'Показать пароль'"
              @click="showConfirmPassword = !showConfirmPassword"
            >
              <EyeOff v-if="showConfirmPassword" class="w-4 h-4 stroke-[2px]" />
              <Eye v-else class="w-4 h-4 stroke-[2px]" />
            </button>
          </div>
          <p v-if="errors.confirmPassword" class="text-xs text-red-600 mt-1">
            {{ errors.confirmPassword }}
          </p>
        </div>

        <!-- Submit Button -->
        <button
          type="submit"
          class="mt-2.5 w-full py-3.5 px-4 rounded-xl bg-emerald-950 text-white font-bold text-sm flex items-center justify-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/20 disabled:opacity-50"
          :disabled="isSubmitting"
        >
          <span>{{ isSubmitting ? 'Регистрация...' : 'Зарегистрироваться' }}</span>
          <ArrowRight class="w-4 h-4 stroke-[2.5px]" />
        </button>

        <!-- Back to login -->
        <div class="text-center mt-2.5 text-xs text-slate-500 flex items-center justify-center gap-1.5">
          <span>Уже есть аккаунт?</span>
          <RouterLink to="/login" class="font-bold text-emerald-800 hover:underline">
            Войти
          </RouterLink>
        </div>
      </form>
    </div>
  </div>
</template>
