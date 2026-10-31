<script setup lang="ts">
import { ref } from 'vue'

const activeFilter = ref(0)
</script>

<template>
  <div class="view-container">
    <div class="view-header">
      <van-search placeholder="Поиск рецептов..." shape="round" />
    </div>

    <van-tabs v-model:active="activeFilter" shrink color="#2e7d32">
      <van-tab title="Подходит сейчас" />
      <van-tab title="Спасает продукты 🔥" />
      <van-tab title="До 20 мин" />
      <van-tab title="Избранное" />
    </van-tabs>

    <div class="view-body">
      <van-empty
        image="error"
        description="Рецепты подбираются автоматически на основе содержимого вашего холодильника."
      >
        <router-link to="/fridge">
          <van-button round type="primary" color="#2e7d32" class="action-btn">
            Заполнить холодильник
          </van-button>
        </router-link>
      </van-empty>
    </div>
  </div>
</template>

<style scoped>
.view-container {
  padding: 8px 12px;
}

.view-header {
  margin-bottom: 8px;
}

.view-body {
  padding: 24px 8px;
}

.action-btn {
  min-width: 180px;
  min-height: 44px;
}
</style>
