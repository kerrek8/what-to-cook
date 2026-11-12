<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'
import { useInventoryStore } from '@/stores/inventory'
import { useShoppingStore } from '@/stores/shopping'
import { scrollToTop } from '@/utils/scroll'

const route = useRoute()
const inventoryStore = useInventoryStore()
const shoppingStore = useShoppingStore()

const pendingShoppingCount = computed(() => {
  const n = shoppingStore.items.filter((i) => !i.isBought).length
  return n > 0 ? (n > 99 ? '99+' : n) : undefined
})

const hasExpiringProducts = computed(() => inventoryStore.expiringCount > 0)

function handleTabClick(targetPath: string) {
  if (route.path === targetPath) {
    scrollToTop()
  }
}
</script>

<template>
  <nav v-if="!route.meta.hideTabBar" class="app-tabbar safe-area-bottom">
    <van-tabbar route :border="false" active-color="#064E3B" inactive-color="#8C827A">
      <van-tabbar-item replace to="/fridge" icon="apps-o" :dot="hasExpiringProducts" @click="handleTabClick('/fridge')">
        Холодильник
      </van-tabbar-item>
      <van-tabbar-item replace to="/recipes" icon="fire-o" @click="handleTabClick('/recipes')">
        Рецепты
      </van-tabbar-item>
      <van-tabbar-item replace to="/shopping" icon="cart-o" :badge="pendingShoppingCount" @click="handleTabClick('/shopping')">
        Покупки
      </van-tabbar-item>
      <van-tabbar-item replace to="/profile" icon="user-o" @click="handleTabClick('/profile')">
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
  background-color: rgba(255, 255, 255, 0.94);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-top: 1px solid #E2E8F0;
  box-shadow: 0 -1px 3px 0 rgb(0 0 0 / 0.04);
}

:deep(.van-tabbar) {
  position: relative;
  width: 100%;
  height: 56px;
  background-color: transparent;
}

:deep(.van-tabbar-item) {
  min-height: 48px;
  font-size: 11px;
  background-color: transparent;
  transition: all 0.2s ease;
}

:deep(.van-tabbar-item--active) {
  font-weight: 600;
  position: relative;
}

:deep(.van-tabbar-item--active::after) {
  content: '';
  position: absolute;
  bottom: 4px;
  left: 50%;
  transform: translateX(-50%);
  width: 4px;
  height: 4px;
  border-radius: 50%;
  background-color: #064E3B;
}

:deep(.van-tabbar-item__icon) {
  font-size: 22px;
  margin-bottom: 3px;
  transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1);
}

:deep(.van-tabbar-item--active .van-tabbar-item__icon) {
  transform: scale(1.08);
}

:deep(.van-badge) {
  background-color: #E11D48;
  font-weight: 700;
  font-size: 10px;
}
</style>
