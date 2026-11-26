<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { scrollToTop } from '@/utils/scroll'
import { ArrowLeft } from 'lucide-vue-next'

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
  <header
    v-if="!route.meta.hideHeader"
    class="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-[#E8E2D8] safe-area-top select-none transition-all shadow-xs"
    @click="onHeaderClick"
  >
    <div class="h-12 max-w-lg mx-auto px-4 flex items-center justify-between">
      <!-- Left Back Button or Placeholder -->
      <div class="w-10 flex items-center">
        <button
          v-if="showBack"
          type="button"
          class="w-10 h-10 -ml-2 text-slate-700 hover:text-[#165337] active:scale-95 transition-all rounded-xl flex items-center justify-center"
          aria-label="Назад"
          @click.stop="onClickLeft"
        >
          <ArrowLeft class="w-5 h-5 stroke-[2.2px]" />
        </button>
      </div>

      <!-- Center Title -->
      <h1 class="text-base font-bold text-[#18181B] tracking-tight">
        {{ title }}
      </h1>

      <!-- Right Spacer for Balance -->
      <div class="w-10" />
    </div>
  </header>
</template>
