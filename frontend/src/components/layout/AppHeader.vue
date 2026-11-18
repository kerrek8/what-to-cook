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
    class="sticky top-0 z-40 bg-white/95 backdrop-blur-md border-b border-slate-200/80 safe-area-top select-none transition-all shadow-xs"
    @click="onHeaderClick"
  >
    <div class="h-12 max-w-lg mx-auto px-4 flex items-center justify-between">
      <!-- Left Back Button or Placeholder -->
      <div class="w-8 flex items-center">
        <button
          v-if="showBack"
          type="button"
          class="p-1 -ml-1 text-slate-700 hover:text-emerald-950 active:scale-95 transition-all rounded-full"
          aria-label="Назад"
          @click.stop="onClickLeft"
        >
          <ArrowLeft class="w-5 h-5 stroke-[2.2px]" />
        </button>
      </div>

      <!-- Center Title -->
      <h1 class="text-base font-bold text-slate-900 tracking-tight">
        {{ title }}
      </h1>

      <!-- Right Spacer for Balance -->
      <div class="w-8" />
    </div>
  </header>
</template>
