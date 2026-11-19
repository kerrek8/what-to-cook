<script setup lang="ts">
import { ref } from 'vue'
import { useRouter, useRoute, RouterLink } from 'vue-router'
import { useAuthStore } from '@/stores/auth'
import { useToastStore } from '@/stores/toast'
import { Mail, Lock, ArrowRight, ArrowLeft } from 'lucide-vue-next'
import BrandLogo from '@/components/common/BrandLogo.vue'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()
const toast = useToastStore()

const email = ref('')
const password = ref('')
const isSubmitting = ref(false)

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

async function onSubmit() {
  const trimmedEmail = email.value.trim()
  if (!trimmedEmail) {
    toast.show('Укажите email', 'fail')
    return
  }
  if (!emailPattern.test(trimmedEmail)) {
    toast.show('Некорректный формат email', 'fail')
    return
  }
  if (!password.value || password.value.length < 6) {
    toast.show('Пароль должен быть не менее 6 символов', 'fail')
    return
  }

  isSubmitting.value = true
  try {
    await authStore.login({
      email: trimmedEmail,
      password: password.value
    })
    toast.show('Успешный вход!', 'success')
    const redirect = (route.query.redirect as string) || '/profile'
    router.replace(redirect)
  } catch (err: any) {
    const message = err.response?.data?.error || 'Неверный email или пароль'
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
          Вход в WhatCook
        </h1>
        <p class="text-xs text-emerald-200/90 mt-1 max-w-xs">
          Умный холодильник и рецепты на любом устройстве
        </p>
      </div>
    </div>

    <!-- Login Form Card pulling up -->
    <div
      class="-mt-6 bg-white rounded-t-3xl px-6 pt-7 pb-12 flex-1 shadow-lg max-w-md mx-auto w-full"
    >
      <form class="flex flex-col gap-4" @submit.prevent="onSubmit">
        <!-- Email Field -->
        <div>
          <label class="block text-xs font-semibold text-slate-700 mb-1.5">Email</label>
          <div class="relative flex items-center">
            <Mail class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
            <input
              v-model="email"
              type="email"
              autocomplete="email"
              placeholder="ivan@example.com"
              class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white shadow-xs transition-all"
            />
          </div>
        </div>

        <!-- Password Field -->
        <div>
          <label class="block text-xs font-semibold text-slate-700 mb-1.5">Пароль</label>
          <div class="relative flex items-center">
            <Lock class="absolute left-3.5 w-4 h-4 text-slate-400 stroke-[2px]" />
            <input
              v-model="password"
              type="password"
              autocomplete="current-password"
              placeholder="Введите пароль"
              class="w-full pl-10 pr-4 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white shadow-xs transition-all"
            />
          </div>
        </div>

        <!-- Submit Button -->
        <button
          type="submit"
          class="mt-3 w-full py-3.5 px-4 rounded-xl bg-emerald-950 text-white font-bold text-sm flex items-center justify-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/20 disabled:opacity-50"
          :disabled="isSubmitting"
        >
          <span>{{ isSubmitting ? 'Вход...' : 'Войти' }}</span>
          <ArrowRight class="w-4 h-4 stroke-[2.5px]" />
        </button>

        <!-- Registration Link -->
        <div class="text-center mt-3 text-xs text-slate-500 flex items-center justify-center gap-1.5">
          <span>Нет аккаунта?</span>
          <RouterLink to="/register" class="font-bold text-emerald-800 hover:underline">
            Зарегистрироваться
          </RouterLink>
        </div>
      </form>
    </div>
  </div>
</template>
