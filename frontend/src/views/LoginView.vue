<script setup lang="ts">
import { ref } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { showToast } from 'vant'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const route = useRoute()
const authStore = useAuthStore()

const email = ref('')
const password = ref('')
const isSubmitting = ref(false)

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

async function onSubmit() {
  isSubmitting.value = true
  try {
    await authStore.login({
      email: email.value.trim(),
      password: password.value
    })
    showToast({ type: 'success', message: 'Успешный вход!' })
    const redirect = (route.query.redirect as string) || '/profile'
    router.replace(redirect)
  } catch (err: any) {
    const message = err.response?.data?.error || 'Неверный email или пароль'
    showToast({ type: 'fail', message })
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="auth-view">
    <div class="auth-header">
      <div class="auth-icon">🍳</div>
      <h2 class="auth-title">Вход в WhatCook</h2>
      <p class="auth-subtitle">Синхронизируйте холодильник и умные рецепты</p>
    </div>

    <van-form class="auth-form" @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          v-model="email"
          name="email"
          label="Email"
          placeholder="ivan@example.com"
          type="email"
          autocomplete="email"
          :rules="[
            { required: true, message: 'Укажите email' },
            { pattern: emailPattern, message: 'Некорректный формат email' }
          ]"
        />
        <van-field
          v-model="password"
          type="password"
          name="password"
          label="Пароль"
          placeholder="Введите пароль"
          autocomplete="current-password"
          :rules="[
            { required: true, message: 'Введите пароль' },
            { validator: (val) => val.length >= 6, message: 'Минимум 6 символов' }
          ]"
        />
      </van-cell-group>

      <div class="form-actions">
        <van-button
          round
          block
          type="primary"
          native-type="submit"
          color="#2e7d32"
          :loading="isSubmitting"
          class="submit-btn"
        >
          Войти
        </van-button>

        <div class="auth-links">
          <span>Нет аккаунта?</span>
          <router-link to="/register" class="link-btn">Зарегистрироваться</router-link>
        </div>
      </div>
    </van-form>
  </div>
</template>

<style scoped>
.auth-view {
  padding: 24px 16px;
  display: flex;
  flex-direction: column;
}

.auth-header {
  text-align: center;
  margin-bottom: 24px;
}

.auth-icon {
  font-size: 48px;
  margin-bottom: 8px;
}

.auth-title {
  font-size: 20px;
  font-weight: 700;
  color: #1a1a1a;
  margin-bottom: 4px;
}

.auth-subtitle {
  font-size: 13px;
  color: #8c8c8c;
}

.auth-form {
  margin-top: 8px;
}

.form-actions {
  margin-top: 24px;
  padding: 0 16px;
}

.submit-btn {
  min-height: 44px;
  font-size: 16px;
  font-weight: 600;
}

.auth-links {
  margin-top: 16px;
  display: flex;
  justify-content: center;
  align-items: center;
  gap: 6px;
  font-size: 14px;
  color: #595959;
}

.link-btn {
  color: #2e7d32;
  font-weight: 600;
  text-decoration: none;
  min-height: 44px;
  display: inline-flex;
  align-items: center;
}
</style>
