<script setup lang="ts">
import { ref } from 'vue'

const activeTab = ref(0)
</script>

<template>
  <div class="view-container">
    <div class="view-header">
      <van-search placeholder="Поиск продуктов в холодильнике..." shape="round" />
    </div>

    <van-tabs v-model:active="activeTab" shrink color="#2e7d32">
      <van-tab title="Все" />
      <van-tab title="Скоро испортятся" badge="3" />
      <van-tab title="Овощи" />
      <van-tab title="Молочное" />
      <van-tab title="Мясо" />
    </van-tabs>

    <div class="view-body">
      <van-empty
        image="search"
        description="В холодильнике пока пусто. Добавьте первые продукты, чтобы подобрать рецепты!"
      >
        <van-button round type="primary" color="#2e7d32" class="action-btn">
          Добавить продукт
        </van-button>
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
