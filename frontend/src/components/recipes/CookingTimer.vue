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
    if (totalSeconds.value <= 0) {
      totalSeconds.value = (props.initialMinutes || 5) * 60
    }
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
  if (totalSeconds.value <= 0) {
    totalSeconds.value = (props.initialMinutes || 5) * 60
  }
  remainingSeconds.value = totalSeconds.value
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
    return
  }

  if (remainingSeconds.value <= 0) {
    return
  }

  if (remainingSeconds.value + deltaSeconds <= 0) {
    remainingSeconds.value = 0
    if (isRunning.value) {
      stopTimer()
      onTimerFinished()
    }
  } else {
    remainingSeconds.value += deltaSeconds
    totalSeconds.value = Math.max(remainingSeconds.value, totalSeconds.value + deltaSeconds)
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
  resetTimer,
  adjustTime,
  addMinute
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
        :class="{ active: remainingSeconds === m * 60 && totalSeconds === m * 60 }"
        @click="setPreset(m)"
      >
        {{ m }}м
      </button>
    </div>

    <div class="timer-adjustments">
      <button
        v-for="delta in [-5, -1, 1, 5]"
        :key="delta"
        type="button"
        class="adjust-btn"
        :class="{ 'btn-decrement': delta < 0, 'btn-increment': delta > 0 }"
        :disabled="delta < 0 && remainingSeconds <= 0"
        @click="adjustTime(delta)"
      >
        {{ delta > 0 ? `+${delta}м` : `${delta}м` }}
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
  min-height: 38px;
  border: 1px solid #c8e6c9;
  background-color: #f1f8e9;
  color: #2e7d32;
  font-weight: 600;
  font-size: 13px;
  border-radius: 8px;
  cursor: pointer;
  touch-action: manipulation;
}

.preset-btn.active {
  background-color: #2e7d32;
  color: #ffffff;
  border-color: #2e7d32;
}

.timer-adjustments {
  display: flex;
  gap: 8px;
  justify-content: space-between;
}

.adjust-btn {
  flex: 1;
  min-height: 44px;
  min-width: 44px;
  border-radius: 10px;
  font-size: 14px;
  font-weight: 600;
  cursor: pointer;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s ease;
  touch-action: manipulation;
  -webkit-tap-highlight-color: transparent;
}

.adjust-btn.btn-decrement {
  border: 1px solid #e0e0e0;
  background-color: #f7f9fa;
  color: #455a64;
}

.adjust-btn.btn-decrement:active:not(:disabled) {
  background-color: #eceff1;
  transform: scale(0.97);
}

.adjust-btn.btn-increment {
  border: 1px solid #c8e6c9;
  background-color: #f1f8e9;
  color: #2e7d32;
}

.adjust-btn.btn-increment:active:not(:disabled) {
  background-color: #e8f5e9;
  transform: scale(0.97);
}

.adjust-btn:disabled {
  opacity: 0.35;
  cursor: not-allowed;
  border-color: #eeeeee;
  background-color: #f5f5f5;
  color: #9e9e9e;
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
