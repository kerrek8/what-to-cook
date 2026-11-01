<script setup lang="ts">
import { ref, computed, onUnmounted } from 'vue'
import { showNotify } from 'vant'

const props = defineProps<{
  initialMinutes?: number
}>()

const emit = defineEmits<{
  (e: 'close'): void
}>()

const totalSeconds = ref((props.initialMinutes || 5) * 60)
const remainingSeconds = ref(totalSeconds.value)
const isRunning = ref(false)
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

function startTimer() {
  if (remainingSeconds.value <= 0) {
    remainingSeconds.value = totalSeconds.value
  }
  isRunning.value = true
  if (intervalId) clearInterval(intervalId)

  intervalId = setInterval(() => {
    if (remainingSeconds.value > 0) {
      remainingSeconds.value--
    } else {
      stopTimer()
      onTimerFinished()
    }
  }, 1000)
}

function pauseTimer() {
  isRunning.value = false
  if (intervalId) {
    clearInterval(intervalId)
    intervalId = null
  }
}

function stopTimer() {
  pauseTimer()
}

function resetTimer() {
  stopTimer()
  remainingSeconds.value = totalSeconds.value
}

function addMinute() {
  remainingSeconds.value += 60
  totalSeconds.value += 60
}

function setPreset(mins: number) {
  stopTimer()
  totalSeconds.value = mins * 60
  remainingSeconds.value = totalSeconds.value
  startTimer()
}

function onTimerFinished() {
  if ('vibrate' in navigator) {
    navigator.vibrate([300, 150, 300, 150, 500])
  }
  showNotify({
    type: 'success',
    message: '⏰ Время вышло! Блюдо готово к следующему шагу.',
    duration: 5000
  })
}

onUnmounted(() => {
  if (intervalId) clearInterval(intervalId)
})

defineExpose({
  setPreset,
  startTimer,
  pauseTimer,
  resetTimer
})
</script>

<template>
  <div class="timer-card">
    <div class="timer-header">
      <div class="timer-title">
        <van-icon name="clock-o" color="#2e7d32" size="18" />
        <span>Таймер готовки</span>
      </div>
      <button type="button" class="close-btn" @click="emit('close')">
        <van-icon name="cross" size="16" color="#757575" />
      </button>
    </div>

    <div class="timer-display">
      <span class="digits" :class="{ 'time-over': remainingSeconds === 0 }">
        {{ formattedTime }}
      </span>
      <div class="progress-bar-bg">
        <div class="progress-bar-fill" :style="{ width: `${progressPercent}%` }"></div>
      </div>
    </div>

    <div class="timer-presets">
      <button
        v-for="m in [1, 3, 5, 10, 15, 20]"
        :key="m"
        type="button"
        class="preset-btn"
        :class="{ active: totalSeconds === m * 60 }"
        @click="setPreset(m)"
      >
        {{ m }}м
      </button>
    </div>

    <div class="timer-actions">
      <van-button
        v-if="!isRunning"
        round
        type="primary"
        color="#2e7d32"
        icon="play"
        class="action-btn main-btn"
        @click="startTimer"
      >
        Старт
      </van-button>

      <van-button
        v-else
        round
        type="warning"
        icon="pause"
        class="action-btn main-btn"
        @click="pauseTimer"
      >
        Пауза
      </van-button>

      <van-button
        round
        plain
        icon="replay"
        class="action-btn sec-btn"
        @click="resetTimer"
      >
        Сброс
      </van-button>

      <van-button
        round
        plain
        icon="plus"
        class="action-btn sec-btn"
        @click="addMinute"
      >
        +1м
      </van-button>
    </div>
  </div>
</template>

<style scoped>
.timer-card {
  background-color: #ffffff;
  border-radius: 16px;
  padding: 16px;
  box-shadow: 0 4px 16px rgba(0, 0, 0, 0.1);
  border: 1px solid #e8f5e9;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.timer-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.timer-title {
  display: flex;
  align-items: center;
  gap: 6px;
  font-weight: 700;
  font-size: 15px;
  color: #1a1a1a;
}

.close-btn {
  background: none;
  border: none;
  padding: 4px;
  min-width: 32px;
  min-height: 32px;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
}

.timer-display {
  text-align: center;
  padding: 8px 0;
}

.digits {
  font-size: 40px;
  font-weight: 800;
  font-family: monospace;
  color: #2e7d32;
  letter-spacing: 2px;
}

.digits.time-over {
  color: #d32f2f;
  animation: pulse 1s infinite alternate;
}

@keyframes pulse {
  from { opacity: 1; }
  to { opacity: 0.4; }
}

.progress-bar-bg {
  width: 100%;
  height: 6px;
  background-color: #e0e0e0;
  border-radius: 3px;
  overflow: hidden;
  margin-top: 8px;
}

.progress-bar-fill {
  height: 100%;
  background-color: #2e7d32;
  transition: width 0.3s ease;
}

.timer-presets {
  display: flex;
  gap: 6px;
  overflow-x: auto;
  padding: 2px 0;
}

.preset-btn {
  flex: 1;
  min-width: 44px;
  min-height: 34px;
  border: 1px solid #c8e6c9;
  background-color: #f1f8e9;
  color: #2e7d32;
  font-weight: 600;
  font-size: 13px;
  border-radius: 8px;
  cursor: pointer;
}

.preset-btn.active {
  background-color: #2e7d32;
  color: #ffffff;
  border-color: #2e7d32;
}

.timer-actions {
  display: flex;
  gap: 8px;
  align-items: center;
}

.main-btn {
  flex: 2;
  min-height: 44px;
  font-weight: 700;
}

.sec-btn {
  flex: 1;
  min-height: 44px;
  font-weight: 600;
}
</style>
