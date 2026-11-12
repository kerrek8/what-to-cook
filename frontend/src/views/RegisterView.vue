<script setup lang="ts">
import { ref } from 'vue'
import { useRouter } from 'vue-router'
import { showToast } from 'vant'
import { useAuthStore } from '@/stores/auth'

const router = useRouter()
const authStore = useAuthStore()

const name = ref('')
const email = ref('')
const password = ref('')
const confirmPassword = ref('')
const isSubmitting = ref(false)

const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/

function validateConfirmPassword(val: string) {
  if (val !== password.value) {
    return 'Пароли не совпадают'
  }
  return true
}

async function onSubmit() {
  isSubmitting.value = true
  try {
    await authStore.register({
      name: name.value.trim(),
      email: email.value.trim(),
      password: password.value
    })
    showToast({ type: 'success', message: 'Регистрация успешна!' })
    router.replace('/profile')
  } catch (err: any) {
    const message = err.response?.data?.error || 'Ошибка при регистрации'
    showToast({ type: 'fail', message })
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <div class="auth-view">
    <div class="auth-header">
      <div class="auth-icon">🥗</div>
      <h2 class="auth-title">Создание аккаунта</h2>
      <p class="auth-subtitle">Управляйте продуктами и не выбрасывайте еду</p>
    </div>

    <van-form class="auth-form" @submit="onSubmit">
      <van-cell-group inset>
        <van-field
          v-model="name"
          name="name"
          label="Имя"
          placeholder="Как вас зовут?"
          autocomplete="name"
          :rules="[
            { required: true, message: 'Укажите ваше имя' },
            { validator: (val) => val.trim().length >= 2, message: 'Минимум 2 символа' }
          ]"
        />
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
          placeholder="Минимум 6 символов"
          autocomplete="new-password"
          :rules="[
            { required: true, message: 'Придумайте пароль' },
            { validator: (val) => val.length >= 6, message: 'Минимум 6 символов' }
          ]"
        />
        <van-field
          v-model="confirmPassword"
          type="password"
          name="confirmPassword"
          label="Повтор"
          placeholder="Повторите пароль"
          autocomplete="new-password"
          :rules="[
            { required: true, message: 'Повторите пароль' },
            { validator: validateConfirmPassword }
          ]"
        />
      </van-cell-group>

      <div class="form-actions">
        <van-button
          round
          block
          type="primary"
          native-type="submit"
          color="#1E3A2F"
          :loading="isSubmitting"
          class="submit-btn"
        >
          Зарегистрироваться
        </van-button>

        <div class="auth-links">
          <span>Уже есть аккаунт?</span>
          <router-link to="/login" class="link-btn">Войти</router-link>
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
  color: #1E3A2F;
  font-weight: 600;
  text-decoration: none;
  min-height: 44px;
  display: inline-flex;
  align-items: center;
}
</style>
