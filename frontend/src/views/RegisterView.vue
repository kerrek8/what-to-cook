<script setup lang="ts">
import { ref } from 'vue'
import { useRouter, RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useToastStore } from '@/stores/toast'
import { User, Mail, Lock, ArrowRight } from 'lucide-vue-next'

const router = useRouter()
const authStore = useAuthStore()
const toast = useToastStore()

const name = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const isSubmitting = ref(false)

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

async function onSubmit() {
  const trimmedName = name.value.trim()
  const trimmedEmail = email.value.trim()

  if (!trimmedName || trimmedName.length < 2) {
    toast.show('Укажите имя (минимум 2 символа)', 'fail')
    return
  }
  if (!trimmedEmail || !emailPattern.test(trimmedEmail)) {
    toast.show('Укажите корректный email', 'fail')
    return
  }
  if (!password.value || password.value.length < 6) {
    toast.show('Пароль должен быть не менее 6 символов', 'fail')
    return
  }
  if (password.value !== confirmPassword.value) {
    toast.show('Пароли не совпадают', 'fail')
    return
  }

  isSubmitting.value = true
  try {
    await authStore.register({
      name: trimmedName,
      email: trimmedEmail,
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
  <div class="min-h-full px-5 py-6 flex flex-col justify-center max-w-sm mx-auto">
    <!-- Header -->
    <div class="text-center mb-6 flex flex-col items-center">
      <div class="w-16 h-16 rounded-3xl bg-emerald-950 text-emerald-300 flex items-center justify-center text-3xl mb-3 shadow-elevated border border-emerald-800">
        🥗
      </div>
      <h2 class="text-2xl font-black text-slate-900 tracking-tight">
        Создание аккаунта
      </h2>
      <p class="text-xs text-slate-500 mt-1 max-w-xs">
        Управляйте продуктами и не выбрасывайте еду
      </p>
    </div>

    <!-- Register Form -->
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
            class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 shadow-xs transition-all"
          />
        </div>
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
            class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 shadow-xs transition-all"
          />
        </div>
      </div>

      <!-- Password -->
      <div>
        <label class="block text-xs font-semibold text-slate-700 mb-1">Пароль</label>
        <div class="relative flex items-center">
          <Lock class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
          <input
            v-model="password"
            type="password"
            autocomplete="new-password"
            placeholder="Минимум 6 символов"
            class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 shadow-xs transition-all"
          />
        </div>
      </div>

      <!-- Confirm Password -->
      <div>
        <label class="block text-xs font-semibold text-slate-700 mb-1">Повторите пароль</label>
        <div class="relative flex items-center">
          <Lock class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
          <input
            v-model="confirmPassword"
            type="password"
            autocomplete="new-password"
            placeholder="Повторите пароль"
            class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-white border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 shadow-xs transition-all"
          />
        </div>
      </div>

      <!-- Submit -->
      <button
        type="submit"
        class="mt-2 w-full py-3 px-4 rounded-xl bg-emerald-950 text-white font-bold text-sm flex items-center justify-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/20 disabled:opacity-50"
        :disabled="isSubmitting"
      >
        <span>{{ isSubmitting ? 'Регистрация...' : 'Зарегистрироваться' }}</span>
        <ArrowRight class="w-4 h-4 stroke-[2.5px]" />
      </button>

      <!-- Back to login -->
      <div class="text-center mt-2 text-xs text-slate-500 flex items-center justify-center gap-1.5">
        <span>Уже есть аккаунт?</span>
        <RouterLink to="/login" class="font-bold text-emerald-800 hover:underline">
          Войти
        </RouterLink>
      </div>
    </form>
  </div>
</template>
