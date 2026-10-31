<script setup lang="ts">
import { computed } from 'vue'
import { useRoute } from 'vue-router'

const route = useRoute()
const title = computed(() => (route.meta.title as string) || 'WhatCook')
</script>

<template>
  <header class="app-header safe-area-top">
    <van-nav-bar :title="title" :border="false" />
  </header>
</template>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background-color: var(--van-background-2);
  border-bottom: 1px solid #ebedf0;
}

:deep(.van-nav-bar) {
  --van-nav-bar-background: transparent;
  --van-nav-bar-title-text-color: #1a1a1a;
  --van-nav-bar-title-font-size: 17px;
  font-weight: 600;
}
</style>
