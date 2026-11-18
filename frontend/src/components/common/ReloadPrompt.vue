<script setup lang="ts">
import { useRegisterSW } from 'virtual:pwa-register/vue'

const { offlineReady, needRefresh, updateServiceWorker } = useRegisterSW({
  immediate: true
})

async function close() {
  offlineReady.value = false
  needRefresh.value = false
}
</script>

<template>
  <div
    v-if="offlineReady || needRefresh"
    class="fixed right-4 bottom-20 left-4 max-w-sm mx-auto p-4 rounded-2xl bg-white border border-slate-200 shadow-elevated flex items-center justify-between gap-3 z-50 select-none"
  >
    <div class="text-xs font-medium text-slate-800 leading-snug">
      <span v-if="offlineReady">Приложение готово к работе офлайн</span>
      <span v-else>Доступно обновление приложения</span>
    </div>
    <div class="flex items-center gap-2 shrink-0">
      <button
        v-if="needRefresh"
        type="button"
        class="py-1.5 px-3 rounded-xl bg-emerald-950 text-white text-xs font-bold hover:bg-emerald-900 active:scale-95 transition-all"
        @click="updateServiceWorker()"
      >
        Обновить
      </button>
      <button
        type="button"
        class="py-1.5 px-3 rounded-xl bg-slate-100 text-slate-700 text-xs font-semibold hover:bg-slate-200 active:scale-95 transition-all"
        @click="close"
      >
        Закрыть
      </button>
    </div>
  </div>
</template>
