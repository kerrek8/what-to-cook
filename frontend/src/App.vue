<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppTabBar from '@/components/layout/AppTabBar.vue'
import ReloadPrompt from '@/components/common/ReloadPrompt.vue'
import { useInventoryStore } from '@/stores/inventory'
import { useShoppingStore } from '@/stores/shopping'

const inventoryStore = useInventoryStore()
const shoppingStore = useShoppingStore()

const onOnline = () => {
  inventoryStore.syncWithServer()
  shoppingStore.syncWithServer()
}

onMounted(() => {
  window.addEventListener('online', onOnline)
})

onUnmounted(() => {
  window.removeEventListener('online', onOnline)
})
</script>

<template>
  <div class="mobile-container">
    <AppHeader />
    <main class="content-wrapper">
      <router-view />
    </main>
    <AppTabBar />
    <ReloadPrompt />
  </div>
</template>

<style scoped>
</style>
