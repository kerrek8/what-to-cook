<script setup lang="ts">
import { useRoute } from 'vue-router'

const route = useRoute()
</script>

<template>
  <nav v-if="!route.meta.hideTabBar" class="app-tabbar safe-area-bottom">
    <van-tabbar route :border="true" active-color="#2e7d32" inactive-color="#7d7e80">
      <van-tabbar-item replace to="/fridge" icon="apps-o">
        Холодильник
      </van-tabbar-item>
      <van-tabbar-item replace to="/recipes" icon="fire-o">
        Рецепты
      </van-tabbar-item>
      <van-tabbar-item replace to="/shopping" icon="cart-o">
        Покупки
      </van-tabbar-item>
      <van-tabbar-item replace to="/profile" icon="user-o">
        Профиль
      </van-tabbar-item>
    </van-tabbar>
  </nav>
</template>

<style scoped>
.app-tabbar {
  position: fixed;
  bottom: 0;
  left: 50%;
  transform: translateX(-50%);
  width: 100%;
  max-width: var(--app-max-width);
  z-index: 100;
  background-color: var(--van-background-2);
}

:deep(.van-tabbar) {
  position: relative;
  width: 100%;
  height: 56px;
}

:deep(.van-tabbar-item) {
  min-height: 48px;
  font-size: 11px;
}

:deep(.van-tabbar-item__icon) {
  font-size: 22px;
  margin-bottom: 3px;
}
</style>
