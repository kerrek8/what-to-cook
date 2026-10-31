<script setup lang="ts">
</script>

<template>
  <div class="view-container">
    <div class="view-body">
      <van-empty
        image="network"
        description="Список покупок пуст. Добавляйте недостающие продукты из рецептов в один клик!"
      >
        <van-button round type="primary" color="#2e7d32" class="action-btn">
          Добавить вручную
        </van-button>
      </van-empty>
    </div>
  </div>
</template>

<style scoped>
.view-container {
  padding: 8px 12px;
}

.view-body {
  padding: 32px 8px;
}

.action-btn {
  min-width: 180px;
  min-height: 44px;
}
</style>
