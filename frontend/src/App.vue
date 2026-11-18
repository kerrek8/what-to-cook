<script setup lang="ts">
import { onMounted, onUnmounted } from 'vue'
import AppHeader from '@/components/layout/AppHeader.vue'
import AppTabBar from '@/components/layout/AppTabBar.vue'
import ReloadPrompt from '@/components/common/ReloadPrompt.vue'
import BaseToast from '@/components/common/BaseToast.vue'
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
  inventoryStore.loadInventory()
  shoppingStore.loadItems()
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
    <BaseToast />
  </div>
</template>

<style scoped>
</style>
