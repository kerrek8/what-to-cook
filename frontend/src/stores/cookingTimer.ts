import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { triggerHaptic } from '@/utils/haptics'

export const useCookingTimerStore = defineStore('cookingTimer', () => {
  const initialSeconds = ref(600)
  const durationSeconds = ref(600) // Default 10 mins
  const remainingSeconds = ref(600)
  const isRunning = ref(false)
  let timerInterval: ReturnType<typeof setInterval> | null = null

  const formattedTime = computed(() => {
    const mins = Math.floor(remainingSeconds.value / 60)
    const secs = remainingSeconds.value % 60
    return `${String(mins).padStart(2, '0')}:${String(secs).padStart(2, '0')}`
  })

  const progress = computed(() => {
    if (durationSeconds.value === 0) return 0
    return Math.max(0, Math.min(100, ((durationSeconds.value - remainingSeconds.value) / durationSeconds.value) * 100))
  })

  function setPreset(minutes: number) {
    pause()
    const secs = Math.max(1, minutes) * 60
    initialSeconds.value = secs
    durationSeconds.value = secs
    remainingSeconds.value = secs
  }

  function adjustMinutes(diffMinutes: number) {
    const newSeconds = Math.max(10, remainingSeconds.value + diffMinutes * 60)
    remainingSeconds.value = newSeconds
    if (newSeconds > durationSeconds.value) {
      durationSeconds.value = newSeconds
    }
  }

  function start() {
    if (isRunning.value) return
    isRunning.value = true
    timerInterval = setInterval(() => {
      if (remainingSeconds.value > 1) {
        remainingSeconds.value--
      } else {
        remainingSeconds.value = 0
        pause()
        triggerHaptic('warning')
      }
    }, 1000)
  }

  function pause() {
    isRunning.value = false
    if (timerInterval) {
      clearInterval(timerInterval)
      timerInterval = null
    }
  }

  function reset() {
    pause()
    durationSeconds.value = initialSeconds.value
    remainingSeconds.value = initialSeconds.value
  }

  return {
    durationSeconds,
    remainingSeconds,
    isRunning,
    formattedTime,
    progress,
    setPreset,
    adjustMinutes,
    start,
    pause,
    reset
  }
})
