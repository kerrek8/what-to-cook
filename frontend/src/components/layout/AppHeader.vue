<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const title = computed(() => (route.meta.title as string) || 'WhatCook')
const showBack = computed(() => route.path === '/login' || route.path === '/register')

function onClickLeft() {
  if (showBack.value) {
    if (window.history.length > 1) {
      router.back()
    } else {
      router.push('/profile')
    }
  }
}
</script>

<template>
  <header class="app-header safe-area-top">
    <van-nav-bar
      :title="title"
      :left-arrow="showBack"
      :border="false"
      @click-left="onClickLeft"
    />
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
  --van-nav-bar-arrow-size: 20px;
  --van-nav-bar-icon-color: #2e7d32;
  font-weight: 600;
}
</style>
