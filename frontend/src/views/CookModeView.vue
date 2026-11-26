<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecipeStore } from '@/stores/recipe'
import { useCookingTimerStore } from '@/stores/cookingTimer'
import { triggerHaptic } from '@/utils/haptics'
import { useToast } from '@/composables/useToast'
import SmartConsumptionSheet from '@/components/cooking/SmartConsumptionSheet.vue'
import {
  X,
  Play,
  Pause,
  RotateCcw,
  ChevronLeft,
  ChevronRight,
  Flame,
  Volume2
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const toast = useToast()
const recipeStore = useRecipeStore()
const timer = useCookingTimerStore()

const recipeId = computed(() => Number(route.params.id))
const currentStepIndex = ref(0)
const showSmartConsumption = ref(false)
let originalThemeColor = '#FFFFFF'
let wakeLockSentinel: any = null

async function requestWakeLock() {
  if (typeof navigator !== 'undefined' && 'wakeLock' in navigator) {
    try {
      wakeLockSentinel = await (navigator as any).wakeLock.request('screen')
    } catch {
      // Wake lock request may be denied by device policy or power saving
    }
  }
}

function releaseWakeLock() {
  if (wakeLockSentinel) {
    wakeLockSentinel.release().catch(() => {})
    wakeLockSentinel = null
  }
}

const handleVisibilityChange = () => {
  if (typeof document !== 'undefined' && document.visibilityState === 'visible') {
    requestWakeLock()
  }
}

onMounted(async () => {
  if (typeof document !== 'undefined') {
    const metaTheme = document.querySelector('meta[name="theme-color"]')
    if (metaTheme) {
      originalThemeColor = metaTheme.getAttribute('content') || '#FFFFFF'
      metaTheme.setAttribute('content', '#061811')
    }
    document.addEventListener('visibilitychange', handleVisibilityChange)
  }

  requestWakeLock()

  if (!recipeStore.currentRecipe || recipeStore.currentRecipe.id !== recipeId.value) {
    await recipeStore.loadRecipeById(recipeId.value)
  }

  if (recipeStore.currentRecipe) {
    timer.setRecipe(recipeId.value, recipeStore.currentRecipe.title)
    if (recipeStore.currentRecipe.cooking_time_minutes && !timer.isRunning) {
      timer.setPreset(recipeStore.currentRecipe.cooking_time_minutes)
    }
  }
})

onUnmounted(() => {
  releaseWakeLock()
  if (typeof document !== 'undefined') {
    document.removeEventListener('visibilitychange', handleVisibilityChange)
    const metaTheme = document.querySelector('meta[name="theme-color"]')
    if (metaTheme) {
      metaTheme.setAttribute('content', originalThemeColor)
    }
  }
})

const recipe = computed(() => recipeStore.currentRecipe)
const totalSteps = computed(() => recipe.value?.instructions.length || 0)
const currentStepText = computed(() => {
  if (!recipe.value || totalSteps.value === 0) return 'Шаги не указаны'
  return recipe.value.instructions[currentStepIndex.value] || ''
})

function prevStep() {
  if (currentStepIndex.value > 0) {
    triggerHaptic('light')
    currentStepIndex.value--
  }
}

function nextStep() {
  if (currentStepIndex.value < totalSteps.value - 1) {
    triggerHaptic('light')
    currentStepIndex.value++
  }
}

function onFinishCooking() {
  triggerHaptic('success')
  if (recipe.value?.ingredients && recipe.value.ingredients.length > 0) {
    showSmartConsumption.value = true
  } else {
    exitCookMode()
  }
}

function onConsumptionApplied(count: number) {
  if (count > 0) {
    toast.show(`Списано ${count} прод. из холодильника`, 'success')
  }
  exitCookMode()
}

function toggleTimer() {
  triggerHaptic('medium')
  if (timer.isRunning) {
    timer.pause()
  } else {
    timer.start()
  }
}

function resetTimer() {
  triggerHaptic('warning')
  timer.reset()
}

function exitCookMode() {
  triggerHaptic('light')
  if (typeof window !== 'undefined' && window.history.length > 1) {
    router.back()
  } else {
    router.replace(`/recipes/${recipeId.value}`)
  }
}

// Touch swipe gestures for step navigation
let touchStartX = 0
let touchStartY = 0

function onTouchStart(e: TouchEvent) {
  if (e.touches.length !== 1) return
  touchStartX = e.touches[0].clientX
  touchStartY = e.touches[0].clientY
}

function onTouchEnd(e: TouchEvent) {
  if (e.changedTouches.length !== 1) return
  const deltaX = e.changedTouches[0].clientX - touchStartX
  const deltaY = e.changedTouches[0].clientY - touchStartY

  // Horizontal swipe: deltaX significant and deltaY small
  if (Math.abs(deltaX) > 60 && Math.abs(deltaY) < 40) {
    if (deltaX < 0) {
      // Swiped left -> next step
      if (currentStepIndex.value < totalSteps.value - 1) {
        nextStep()
      }
    } else {
      // Swiped right -> prev step
      if (currentStepIndex.value > 0) {
        prevStep()
      }
    }
  }
}
</script>

<template>
  <div class="fixed inset-0 z-50 bg-gradient-to-b from-[#061811] via-[#041F16] to-[#02150E] text-white flex flex-col justify-between px-5 pt-[max(1.25rem,calc(env(safe-area-inset-top,0px)+0.75rem))] pb-[max(1.25rem,calc(env(safe-area-inset-bottom,0px)+0.75rem))] select-none">
    <!-- Top Header Bar with Grid to completely prevent Layout Shift -->
    <div class="grid grid-cols-[60px_1fr_60px] items-center border-b border-emerald-900/60 pb-3">
      <div class="flex justify-start">
        <button
          type="button"
          class="w-10 h-10 rounded-full bg-emerald-950/80 border border-emerald-800/80 flex items-center justify-center text-slate-300 hover:text-white active:scale-95 transition-all shadow-xs"
          aria-label="Выйти из режима готовки"
          @click="exitCookMode"
        >
          <X class="w-5 h-5 stroke-[2.2px]" />
        </button>
      </div>

      <div class="flex flex-col items-center min-w-0 text-center px-1">
        <span class="text-xs font-semibold text-emerald-400 uppercase tracking-wider flex items-center justify-center gap-1">
          <Flame class="w-3.5 h-3.5 text-emerald-400" />
          Режим готовки
        </span>
        <span class="text-xs text-slate-300 truncate font-medium max-w-[200px]">
          {{ recipe?.title || 'Приготовление' }}
        </span>
      </div>

      <div class="flex justify-end">
        <div class="px-2.5 py-1 rounded-full bg-emerald-900/60 border border-emerald-700/50 text-xs font-bold text-emerald-300 tabular-nums">
          {{ currentStepIndex + 1 }} / {{ totalSteps }}
        </div>
      </div>
    </div>

    <!-- Center: Giant Countdown Display & Timer Controls -->
    <div class="flex flex-col items-center justify-center my-auto gap-5">
      <!-- Massive Digits -->
      <div class="relative flex flex-col items-center">
        <div class="text-7xl sm:text-8xl font-black font-mono tracking-tight text-white drop-shadow-2xl tabular-nums">
          {{ timer.formattedTime }}
        </div>
        <!-- Progress bar line -->
        <div class="w-64 h-1.5 rounded-full bg-emerald-950/80 border border-emerald-900/40 mt-3 overflow-hidden">
          <div
            class="h-full bg-gradient-to-r from-emerald-500 to-emerald-300 transition-all duration-300"
            :style="{ width: `${timer.progress}%` }"
          />
        </div>
      </div>

      <!-- Quick Minute Adjusters -->
      <div class="flex gap-2">
        <button
          type="button"
          class="px-3 py-1 rounded-xl bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-800/60 text-xs font-bold text-emerald-200 active:scale-95 transition-all"
          @click="timer.adjustMinutes(-5)"
        >
          -5 мин
        </button>
        <button
          type="button"
          class="px-3 py-1 rounded-xl bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-800/60 text-xs font-bold text-emerald-200 active:scale-95 transition-all"
          @click="timer.adjustMinutes(-1)"
        >
          -1 мин
        </button>
        <button
          type="button"
          class="px-3 py-1 rounded-xl bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-800/60 text-xs font-bold text-emerald-200 active:scale-95 transition-all"
          @click="timer.adjustMinutes(1)"
        >
          +1 мин
        </button>
        <button
          type="button"
          class="px-3 py-1 rounded-xl bg-emerald-950/80 hover:bg-emerald-900 border border-emerald-800/60 text-xs font-bold text-emerald-200 active:scale-95 transition-all"
          @click="timer.adjustMinutes(5)"
        >
          +5 мин
        </button>
      </div>

      <!-- Timer Action Buttons (Play / Pause / Reset) -->
      <div class="flex items-center gap-4 pt-2">
        <button
          type="button"
          class="w-12 h-12 rounded-2xl bg-emerald-950/80 border border-emerald-800/60 flex items-center justify-center text-slate-300 hover:text-white active:scale-90 transition-all shadow-md"
          aria-label="Сбросить таймер"
          @click="resetTimer"
        >
          <RotateCcw class="w-5 h-5" />
        </button>

        <button
          type="button"
          class="h-16 px-8 rounded-3xl font-black text-lg flex items-center gap-3 transition-all shadow-elevated active:scale-95"
          :class="timer.isRunning ? 'bg-amber-500 hover:bg-amber-400 text-slate-950' : 'bg-emerald-500 hover:bg-emerald-400 text-slate-950'"
          @click="toggleTimer"
        >
          <component :is="timer.isRunning ? Pause : Play" class="w-6 h-6 fill-current" />
          <span>{{ timer.isRunning ? 'Пауза' : 'Старт' }}</span>
        </button>
      </div>
    </div>

    <!-- Bottom: Step Description Card & Navigation -->
    <div class="flex flex-col gap-3">
      <!-- Step Text Box with horizontal touch swipe support -->
      <div
        class="p-5 sm:p-6 rounded-3xl bg-emerald-950/70 border border-emerald-800/60 backdrop-blur-md shadow-elevated min-h-[150px] flex flex-col justify-between touch-pan-y"
        @touchstart="onTouchStart"
        @touchend="onTouchEnd"
      >
        <div class="flex items-center justify-between text-xs text-emerald-300/80 mb-2 font-semibold">
          <span>Шаг {{ currentStepIndex + 1 }}</span>
          <span class="flex items-center gap-1 text-[11px] text-slate-400">
            <Volume2 class="w-3.5 h-3.5" />
            Вибрация по готовности
          </span>
        </div>
        <p class="text-base sm:text-lg font-medium text-white leading-relaxed flex-1 flex items-center">
          {{ currentStepText }}
        </p>
      </div>

      <!-- Step Navigation Buttons -->
      <div class="flex gap-3">
        <button
          type="button"
          class="flex-1 py-3.5 px-4 rounded-2xl bg-emerald-950/80 border border-emerald-800/80 text-sm font-bold flex items-center justify-center gap-2 hover:bg-emerald-900 active:scale-95 transition-all disabled:opacity-30 disabled:pointer-events-none"
          :disabled="currentStepIndex === 0"
          @click="prevStep"
        >
          <ChevronLeft class="w-5 h-5" />
          <span>Назад</span>
        </button>

        <button
          type="button"
          class="flex-1 py-3.5 px-4 rounded-2xl bg-emerald-600 hover:bg-emerald-500 text-slate-950 font-black text-sm flex items-center justify-center gap-2 active:scale-95 transition-all shadow-md"
          @click="currentStepIndex === totalSteps - 1 ? onFinishCooking() : nextStep()"
        >
          <span>{{ currentStepIndex === totalSteps - 1 ? 'Завершить готовить' : 'Следующий шаг' }}</span>
          <ChevronRight class="w-5 h-5 stroke-[2.5px]" />
        </button>
      </div>
    </div>

    <!-- Smart Consumption Bottom Sheet -->
    <SmartConsumptionSheet
      :is-open="showSmartConsumption"
      :recipe-title="recipe?.title"
      :ingredients="recipe?.ingredients || []"
      @close="exitCookMode"
      @applied="onConsumptionApplied"
    />
  </div>
</template>
