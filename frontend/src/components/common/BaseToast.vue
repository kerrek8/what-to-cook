<script setup lang="ts">
import { useToastStore } from '@/stores/toast'
import { CheckCircle2, AlertCircle, Info, X } from 'lucide-vue-next'

const toastStore = useToastStore()
</script>

<template>
  <div class="fixed top-4 left-1/2 -translate-x-1/2 z-[9999] flex flex-col items-center gap-2 w-full max-w-sm px-4 pointer-events-none">
    <TransitionGroup
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0 -translate-y-2 scale-95"
      enter-to-class="opacity-100 translate-y-0 scale-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100 scale-100"
      leave-to-class="opacity-0 scale-95"
    >
      <div
        v-for="toast in toastStore.toasts"
        :key="toast.id"
        class="pointer-events-auto flex items-center gap-3 px-4 py-3 rounded-2xl shadow-elevated text-sm font-medium border backdrop-blur-md transition-all"
        :class="{
          'bg-emerald-950 text-white border-emerald-800': toast.type === 'success',
          'bg-rose-900 text-white border-rose-700': toast.type === 'fail',
          'bg-slate-900 text-white border-slate-700': toast.type === 'info'
        }"
      >
        <CheckCircle2 v-if="toast.type === 'success'" class="w-5 h-5 text-emerald-400 shrink-0" />
        <AlertCircle v-else-if="toast.type === 'fail'" class="w-5 h-5 text-rose-400 shrink-0" />
        <Info v-else class="w-5 h-5 text-sky-400 shrink-0" />

        <span class="flex-1 leading-snug">{{ toast.message }}</span>

        <button
          type="button"
          class="p-1 -mr-1 rounded-full opacity-70 hover:opacity-100 transition-opacity"
          aria-label="Закрыть"
          @click="toastStore.dismiss(toast.id)"
        >
          <X class="w-4 h-4" />
        </button>
      </div>
    </TransitionGroup>
  </div>
</template>
