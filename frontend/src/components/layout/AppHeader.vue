<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { scrollToTop } from '@/utils/scroll'

const route = useRoute()
const router = useRouter()

const title = computed(() => (route.meta.title as string) || 'WhatCook')
const showBack = computed(
  () => route.path === '/login' || route.path === '/register' || route.name === 'recipe-detail'
)

function onClickLeft() {
  if (showBack.value) {
    if (window.history.length > 1) {
      router.back()
    } else if (route.name === 'recipe-detail') {
      router.push('/recipes')
    } else {
      router.push('/profile')
    }
  }
}

function onHeaderClick() {
  scrollToTop()
}
</script>

<template>
  <header v-if="!route.meta.hideHeader" class="app-header safe-area-top" @click="onHeaderClick">
    <van-nav-bar
      :title="title"
      :left-arrow="showBack"
      :border="false"
      @click-left.stop="onClickLeft"
    />
  </header>
</template>

<style scoped>
.app-header {
  position: sticky;
  top: 0;
  z-index: 100;
  background-color: rgba(250, 248, 245, 0.92);
  backdrop-filter: blur(16px);
  -webkit-backdrop-filter: blur(16px);
  border-bottom: 1px solid rgba(30, 58, 47, 0.06);
  box-shadow: 0 1px 8px rgba(30, 58, 47, 0.04);
  cursor: pointer;
  user-select: none;
}

:deep(.van-nav-bar) {
  --van-nav-bar-background: transparent;
  --van-nav-bar-title-text-color: #1E3A2F;
  --van-nav-bar-title-font-size: 17px;
  --van-nav-bar-arrow-size: 20px;
  --van-nav-bar-icon-color: #1E3A2F;
  font-weight: 700;
  letter-spacing: -0.01em;
}
</style>
