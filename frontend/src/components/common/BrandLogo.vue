<script setup lang="ts">
import { computed } from 'vue'
import { ChefHat } from 'lucide-vue-next'

const props = withDefaults(
  defineProps<{
    size?: 'sm' | 'md' | 'lg' | 'xl'
    showText?: boolean
  }>(),
  {
    size: 'md',
    showText: false
  }
)

const containerSizeClass = computed(() => {
  switch (props.size) {
    case 'sm':
      return 'w-8 h-8 rounded-xl'
    case 'lg':
      return 'w-16 h-16 rounded-3xl'
    case 'xl':
      return 'w-20 h-20 rounded-3xl'
    case 'md':
    default:
      return 'w-12 h-12 rounded-2xl'
  }
})

const iconSizeClass = computed(() => {
  switch (props.size) {
    case 'sm':
      return 'w-4 h-4'
    case 'lg':
      return 'w-8 h-8'
    case 'xl':
      return 'w-10 h-10'
    case 'md':
    default:
      return 'w-6 h-6'
  }
})

const textSizeClass = computed(() => {
  switch (props.size) {
    case 'sm':
      return 'text-sm'
    case 'lg':
      return 'text-2xl'
    case 'xl':
      return 'text-3xl'
    case 'md':
    default:
      return 'text-lg'
  }
})
</script>

<template>
  <div class="inline-flex items-center gap-2.5">
    <div
      :class="[
        containerSizeClass,
        'bg-gradient-to-br from-emerald-700 to-emerald-950 flex items-center justify-center text-white shadow-md shadow-emerald-950/20 ring-1 ring-emerald-500/30'
      ]"
    >
      <ChefHat :class="iconSizeClass" class="text-white" />
    </div>
    <span
      v-if="showText"
      :class="[textSizeClass, 'font-bold tracking-tight text-slate-900']"
    >
      WhatCook
    </span>
  </div>
</template>
