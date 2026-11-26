<script setup lang="ts">
import { useRouter } from 'vue-router'
import { useCookingTimerStore } from '@/stores/cookingTimer'
import { Flame, Pause, Play, ChevronRight } from 'lucide-vue-next'
import { triggerHaptic } from '@/utils/haptics'

const router = useRouter()
const timer = useCookingTimerStore()

function goToCookMode() {
  triggerHaptic('light')
  if (timer.recipeId) {
    router.push(`/recipes/${timer.recipeId}/cook`)
  } else {
    router.push('/recipes')
  }
}

function toggleTimer(e: Event) {
  e.stopPropagation()
  triggerHaptic('medium')
  if (timer.isRunning) {
    timer.pause()
  } else {
    timer.start()
  }
}
</script>

<template>
  <div
    class="fixed bottom-[calc(4.75rem+env(safe-area-inset-bottom,0px))] left-1/2 -translate-x-1/2 z-40 w-[calc(100%-2rem)] max-w-md mx-auto"
  >
    <div
      role="button"
      tabindex="0"
      aria-label="Вернуться в режим готовки"
      class="bg-gradient-to-r from-[#061811] to-[#0d2a1f] border border-emerald-600/60 rounded-2xl p-2.5 px-3.5 flex items-center justify-between text-white shadow-elevated backdrop-blur-md cursor-pointer active:scale-[0.99] transition-all"
      @click="goToCookMode"
      @keydown.enter="goToCookMode"
    >
      <!-- Left: Icon and Recipe Title / Status -->
      <div class="flex items-center gap-2.5 min-w-0 pr-2">
        <div class="w-8 h-8 rounded-xl bg-emerald-500/20 text-emerald-400 flex items-center justify-center shrink-0">
          <Flame class="w-4 h-4 animate-pulse text-emerald-400" />
        </div>
        <div class="min-w-0">
          <p class="text-xs font-semibold text-emerald-300 truncate leading-none mb-0.5">
            {{ timer.recipeTitle || 'Режим готовки' }}
          </p>
          <p class="text-[11px] text-slate-300 truncate leading-tight">
            {{ timer.isRunning ? 'Таймер активен' : 'На паузе' }}
          </p>
        </div>
      </div>

      <!-- Right: Digits and Action -->
      <div class="flex items-center gap-2 shrink-0">
        <span class="font-mono font-black text-sm text-white tabular-nums tracking-wide bg-emerald-950/90 px-2 py-0.5 rounded-lg border border-emerald-800/60">
          {{ timer.formattedTime }}
        </span>

        <button
          type="button"
          class="w-8 h-8 rounded-xl bg-emerald-500 hover:bg-emerald-400 text-slate-950 flex items-center justify-center shrink-0 active:scale-90 transition-all shadow-xs"
          :aria-label="timer.isRunning ? 'Пауза' : 'Старт'"
          @click="toggleTimer"
        >
          <component :is="timer.isRunning ? Pause : Play" class="w-4 h-4 fill-current" />
        </button>

        <ChevronRight class="w-4 h-4 text-emerald-400/80 shrink-0" />
      </div>
    </div>
  </div>
</template>
