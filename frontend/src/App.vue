<script setup lang="ts">
import { computed, onMounted, onUnmounted } from 'vue'
import { useRoute } from 'vue-router'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppTabBar from '@/components/layout/AppTabBar.vue'
import ReloadPrompt from '@/components/common/ReloadPrompt.vue'
import BaseToast from '@/components/common/BaseToast.vue'
import { useInventoryStore } from '@/stores/inventory'
import { useShoppingStore } from '@/stores/shopping'
import { useBackPressExit } from '@/composables/useBackPressExit'

const route = useRoute()
const isCookMode = computed(() => route.path.endsWith('/cook'))

// Initialize double-back exit protection
useBackPressExit()

const inventoryStore = useInventoryStore()
const shoppingStore = useShoppingStore()

const onOnline = () => {
  inventoryStore.syncWithServer()
  shoppingStore.syncWithServer()
}

onMounted(() => {
  window.addEventListener('online', onOnline)
  inventoryStore.loadInventory()
  shoppingStore.loadItems()
})

onUnmounted(() => {
  window.removeEventListener('online', onOnline)
})
</script>

<template>
  <div class="mobile-container" :class="{ '!bg-[#061811]': isCookMode }">
    <AppHeader v-if="!isCookMode" />
    <main class="content-wrapper">
      <router-view v-slot="{ Component }">
        <transition name="fade" mode="out-in">
          <component :is="Component" />
        </transition>
      </router-view>
    </main>
    <AppTabBar v-if="!isCookMode" />
    <ReloadPrompt />
    <BaseToast />
  </div>
</template>

<style scoped>
.fade-enter-active,
.fade-leave-active {
  transition: opacity 0.15s ease;
}
.fade-enter-from,
.fade-leave-to {
  opacity: 0;
}
@media (prefers-reduced-motion: reduce) {
  .fade-enter-active,
  .fade-leave-active {
    transition: none;
  }
}
</style>
