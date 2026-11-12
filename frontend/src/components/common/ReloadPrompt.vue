<script setup lang="ts">
import { useRegisterSW } from 'virtual:pwa-register/vue'

const { offlineReady, needRefresh, updateServiceWorker } = useRegisterSW({
  immediate: true
})

async function close() {
  offlineReady.value = false
  needRefresh.value = false
}
</script>

<template>
  <div v-if="offlineReady || needRefresh" class="pwa-toast">
    <div class="message">
      <span v-if="offlineReady">Приложение готово к работе офлайн</span>
      <span v-else>Доступно обновление приложения</span>
    </div>
    <div class="actions">
      <van-button
        v-if="needRefresh"
        size="small"
        type="primary"
        color="#1E3A2F"
        @click="updateServiceWorker()"
      >
        Обновить
      </van-button>
      <van-button size="small" plain @click="close">
        Закрыть
      </van-button>
    </div>
  </div>
</template>

<style scoped>
.pwa-toast {
  position: fixed;
  right: 16px;
  bottom: calc(64px + env(safe-area-inset-bottom, 0));
  left: 16px;
  max-width: 448px;
  margin: 0 auto;
  padding: 12px 16px;
  border-radius: 8px;
  background-color: #ffffff;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 12px;
  z-index: 200;
}

.message {
  font-size: 13px;
  color: #323233;
}

.actions {
  display: flex;
  gap: 8px;
}
</style>
