<script setup lang="ts">
import { ref, computed, watch, onMounted, onUnmounted } from 'vue'
import { triggerHaptic } from '@/utils/haptics'
import { useToastStore } from '@/stores/toast'
import { Clock, X, Play, Pause, RotateCcw } from 'lucide-vue-next'

const props = defineProps<{
  initialMinutes?: number
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'status-change', status: { isRunning: boolean; formattedTime: string }): void
}>()

const toast = useToastStore()

const totalSeconds = ref((props.initialMinutes || 5) * 60)
const remainingSeconds = ref(totalSeconds.value)
const isRunning = ref(false)
let targetEndTime: number | null = null
let intervalId: ReturnType<typeof setInterval> | null = null

const formattedTime = computed(() => {
  const m = Math.floor(remainingSeconds.value / 60)
  const s = remainingSeconds.value % 60
  return `${String(m).padStart(2, '0')}:${String(s).padStart(2, '0')}`
})

const progressPercent = computed(() => {
  if (totalSeconds.value === 0) return 0
  return Math.round(((totalSeconds.value - remainingSeconds.value) / totalSeconds.value) * 100)
})

function emitStatus() {
  emit('status-change', {
    isRunning: isRunning.value,
    formattedTime: formattedTime.value
  })
}

watch(
  () => props.initialMinutes,
  (val) => {
    if (val && !isRunning.value) {
      totalSeconds.value = val * 60
      remainingSeconds.value = totalSeconds.value
      emitStatus()
    }
  }
)

function startTimer() {
  if (remainingSeconds.value <= 0) {
    if (totalSeconds.value <= 0) {
      totalSeconds.value = (props.initialMinutes || 5) * 60
    }
    remainingSeconds.value = totalSeconds.value
  }
  targetEndTime = Date.now() + remainingSeconds.value * 1000
  isRunning.value = true
  emitStatus()
  if (intervalId) clearInterval(intervalId)

  intervalId = setInterval(() => {
    if (!targetEndTime) return
    const diff = Math.ceil((targetEndTime - Date.now()) / 1000)
    if (diff > 0) {
      remainingSeconds.value = diff
      emitStatus()
    } else {
      remainingSeconds.value = 0
      stopTimer()
      onTimerFinished()
    }
  }, 250)
}

function pauseTimer() {
  isRunning.value = false
  if (targetEndTime) {
    remainingSeconds.value = Math.max(0, Math.ceil((targetEndTime - Date.now()) / 1000))
    targetEndTime = null
  }
  if (intervalId) {
    clearInterval(intervalId)
    intervalId = null
  }
  emitStatus()
}

function stopTimer() {
  pauseTimer()
}

function resetTimer() {
  stopTimer()
  if (totalSeconds.value <= 0) {
    totalSeconds.value = (props.initialMinutes || 5) * 60
  }
  remainingSeconds.value = totalSeconds.value
  emitStatus()
}

function adjustTime(minutes: number) {
  const deltaSeconds = minutes * 60

  if (deltaSeconds > 0) {
    if (remainingSeconds.value <= 0) {
      remainingSeconds.value = deltaSeconds
      totalSeconds.value = deltaSeconds
    } else {
      remainingSeconds.value += deltaSeconds
      totalSeconds.value += deltaSeconds
    }
    if (isRunning.value && targetEndTime) {
      targetEndTime += deltaSeconds * 1000
    }
    emitStatus()
    return
  }

  if (remainingSeconds.value <= 0) return

  if (remainingSeconds.value + deltaSeconds <= 0) {
    remainingSeconds.value = 0
    if (isRunning.value) {
      stopTimer()
      onTimerFinished()
    } else {
      emitStatus()
    }
  } else {
    remainingSeconds.value += deltaSeconds
    totalSeconds.value = Math.max(remainingSeconds.value, totalSeconds.value + deltaSeconds)
    if (isRunning.value && targetEndTime) {
      targetEndTime += deltaSeconds * 1000
    }
    emitStatus()
  }
}

function addMinute() {
  adjustTime(1)
}

function setPreset(mins: number) {
  stopTimer()
  totalSeconds.value = mins * 60
  remainingSeconds.value = totalSeconds.value
  startTimer()
}

function playTimerChime() {
  try {
    const AudioContextClass = window.AudioContext || (window as any).webkitAudioContext
    if (!AudioContextClass) return
    const ctx = new AudioContextClass()

    const playTone = (freq: number, start: number, duration: number) => {
      const osc = ctx.createOscillator()
      const gain = ctx.createGain()
      osc.type = 'sine'
      osc.frequency.setValueAtTime(freq, ctx.currentTime + start)

      gain.gain.setValueAtTime(0, ctx.currentTime + start)
      gain.gain.linearRampToValueAtTime(0.2, ctx.currentTime + start + 0.05)
      gain.gain.exponentialRampToValueAtTime(0.001, ctx.currentTime + start + duration)

      osc.connect(gain)
      gain.connect(ctx.destination)

      osc.start(ctx.currentTime + start)
      osc.stop(ctx.currentTime + start + duration)
    }

    playTone(880, 0, 0.25)
    playTone(1046.5, 0.22, 0.45)
  } catch {
    // Audio fallback
  }
}

function onTimerFinished() {
  playTimerChime()
  triggerHaptic('success')
  toast.show('⏰ Время вышло! Блюдо готово к следующему шагу.', 'success', 5000)
}

onMounted(() => {
  emitStatus()
})

onUnmounted(() => {
  if (intervalId) clearInterval(intervalId)
  emit('status-change', {
    isRunning: false,
    formattedTime: formattedTime.value
  })
})

defineExpose({
  isRunning,
  formattedTime,
  setPreset,
  startTimer,
  pauseTimer,
  resetTimer,
  adjustTime,
  addMinute
})
</script>

<template>
  <div class="p-4 rounded-3xl bg-white border border-slate-200/80 shadow-xs flex flex-col gap-3.5">
    <!-- Header -->
    <div class="flex items-center justify-between border-b border-slate-100 pb-2">
      <div class="flex items-center gap-2 text-emerald-950 font-bold text-sm">
        <Clock class="w-4 h-4 text-emerald-800" />
        <span>Таймер готовки</span>
      </div>
      <button
        type="button"
        class="p-1 rounded-full text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-colors"
        aria-label="Закрыть таймер"
        @click="emit('close')"
      >
        <X class="w-4 h-4" />
      </button>
    </div>

    <!-- Digits & Progress -->
    <div class="flex flex-col items-center justify-center py-2">
      <span
        class="text-4xl font-black font-mono tracking-tight"
        :class="remainingSeconds === 0 ? 'text-rose-600' : 'text-slate-900'"
      >
        {{ formattedTime }}
      </span>
      <div class="w-full max-w-xs h-1.5 rounded-full bg-slate-100 mt-2 overflow-hidden">
        <div
          class="h-full bg-gradient-to-r from-emerald-700 to-emerald-500 rounded-full transition-all duration-300"
          :style="{ width: `${progressPercent}%` }"
        />
      </div>
    </div>

    <!-- Presets -->
    <div class="flex items-center justify-center gap-1.5 overflow-x-auto no-scrollbar">
      <button
        v-for="m in [1, 3, 5, 10, 15, 20]"
        :key="m"
        type="button"
        class="px-2.5 py-1 rounded-xl text-xs font-semibold border transition-all"
        :class="
          remainingSeconds === m * 60 && totalSeconds === m * 60
            ? 'bg-emerald-950 text-white border-emerald-950'
            : 'bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100'
        "
        @click="setPreset(m)"
      >
        {{ m }}м
      </button>
    </div>

    <!-- Adjustments -->
    <div class="grid grid-cols-4 gap-1.5">
      <button
        v-for="delta in [-5, -1, 1, 5]"
        :key="delta"
        type="button"
        class="py-1.5 rounded-xl border text-xs font-bold transition-all"
        :class="
          delta < 0
            ? 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100 disabled:opacity-30'
            : 'bg-emerald-50 text-emerald-900 border-emerald-200/80 hover:bg-emerald-100'
        "
        :disabled="delta < 0 && remainingSeconds <= 0"
        @click="adjustTime(delta)"
      >
        {{ delta > 0 ? `+${delta}м` : `${delta}м` }}
      </button>
    </div>

    <!-- Actions -->
    <div class="flex items-center gap-2 pt-1">
      <button
        type="button"
        class="flex-1 py-3 px-4 rounded-xl font-bold text-sm flex items-center justify-center gap-2 active:scale-98 transition-all"
        :class="
          isRunning
            ? 'bg-amber-500 hover:bg-amber-600 text-slate-950'
            : 'bg-emerald-950 hover:bg-emerald-900 text-white'
        "
        @click="isRunning ? pauseTimer() : startTimer()"
      >
        <component :is="isRunning ? Pause : Play" class="w-4 h-4 fill-current" />
        <span>{{ isRunning ? 'Пауза' : 'Старт' }}</span>
      </button>

      <button
        type="button"
        class="py-3 px-4 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-700 font-bold text-sm flex items-center justify-center gap-1.5 active:scale-98 transition-all"
        aria-label="Сброс"
        @click="resetTimer"
      >
        <RotateCcw class="w-4 h-4" />
        <span>Сброс</span>
      </button>
    </div>
  </div>
</template>
