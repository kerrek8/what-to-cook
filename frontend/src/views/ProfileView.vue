<script setup lang="ts">
import { ref } from 'vue'

const allergen = ref('Орехи')
const notificationsEnabled = ref(true)
</script>

<template>
  <div class="view-container">
    <div class="user-card">
      <van-image
        round
        width="64px"
        height="64px"
        src="https://fastly.jsdelivr.net/npm/@vant/assets/cat.jpeg"
      />
      <div class="user-meta">
        <h3 class="user-name">Гость</h3>
        <p class="user-subtitle">Войдите, чтобы синхронизировать данные</p>
      </div>
    </div>

    <van-cell-group inset title="Настройки профиля">
      <van-cell title="Продукт-исключение (Аллергия)" :value="allergen" is-link />
      <van-cell center title="Уведомления о сроках годности">
        <template #right-icon>
          <van-switch v-model="notificationsEnabled" size="22px" active-color="#2e7d32" />
        </template>
      </van-cell>
      <van-cell title="Базовая корзина" value="Соль, масло, вода..." is-link />
    </van-cell-group>

    <van-cell-group inset title="Аккаунт" class="settings-group">
      <van-cell title="Вход / Регистрация" is-link to="/login" />
      <van-cell title="Локальная база" value="IndexedDB / Dexie.js" />
      <van-cell title="О приложении" value="WhatCook v0.1.0" />
    </van-cell-group>
  </div>
</template>

<style scoped>
.view-container {
  padding: 16px 0;
}

.user-card {
  display: flex;
  align-items: center;
  padding: 16px;
  margin: 0 16px 16px;
  background-color: var(--van-background-2);
  border-radius: 12px;
}

.user-meta {
  margin-left: 16px;
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
</style>
