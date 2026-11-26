import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import { triggerHaptic } from '@/utils/haptics'

export const useCookingTimerStore = defineStore('cookingTimer', () => {
  const initialSeconds = ref(600)
  const durationSeconds = ref(600) // Default 10 mins
  const remainingSeconds = ref(600)
  const isRunning = ref(false)
  const recipeId = ref<number | null>(null)
  const recipeTitle = ref<string>('')
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

  function setRecipe(id: number | null, title = '') {
    recipeId.value = id
    recipeTitle.value = title
  }

  function playTimerChime() {
    try {
      if (typeof window === 'undefined') return
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

  function setPreset(minutes: number) {
    pause()
    const secs = Math.max(1, minutes) * 60
    initialSeconds.value = secs
    durationSeconds.value = secs
    remainingSeconds.value = secs
  }

  function adjustMinutes(diffMinutes: number) {
    const newSeconds = Math.max(0, remainingSeconds.value + diffMinutes * 60)
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
        playTimerChime()
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
    recipeId,
    recipeTitle,
    setRecipe,
    setPreset,
    adjustMinutes,
    start,
    pause,
    reset
  }
})
