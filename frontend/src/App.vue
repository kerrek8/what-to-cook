<script setup lang="ts">
import AppHeader from '@/components/layout/AppHeader.vue'
import AppTabBar from '@/components/layout/AppTabBar.vue'
import ReloadPrompt from '@/components/common/ReloadPrompt.vue'
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
