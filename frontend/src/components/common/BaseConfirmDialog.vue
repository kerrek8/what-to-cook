<script setup lang="ts">
import { watch, onUnmounted } from 'vue'
import { AlertTriangle, Info, LogOut } from 'lucide-vue-next'
import { registerModalOpen, registerModalClose } from '@/utils/modalStack'

const props = withDefaults(
  defineProps<{
    show: boolean
    title: string
    message: string
    confirmText?: string
    cancelText?: string
    type?: 'danger' | 'warning' | 'info'
  }>(),
  {
    confirmText: 'Подтвердить',
    cancelText: 'Отмена',
    type: 'danger'
  }
)

const emit = defineEmits<{
  (e: 'update:show', value: boolean): void
  (e: 'confirm'): void
  (e: 'cancel'): void
}>()

let isRegistered = false
let hasPushedHistory = false

function handleClose() {
  emit('update:show', false)
  emit('cancel')
}

function onPopState() {
  if (props.show) {
    hasPushedHistory = false
    handleClose()
  }
}

function handleConfirm() {
  emit('confirm')
}

function onPopState() {
  if (props.show) {
    hasPushedHistory = false
    handleClose()
  }
}

watch(
  () => props.show,
  (newVal) => {
    if (typeof window === 'undefined') return

    if (newVal) {
      if (!isRegistered) {
        registerModalOpen()
        isRegistered = true
      }
      try {
        window.history.pushState({ confirmDialogOpen: true }, '')
        hasPushedHistory = true
        window.addEventListener('popstate', onPopState)
      } catch {
        // Fallback if pushState fails in restricted sandbox
      }
    } else {
      if (isRegistered) {
        registerModalClose()
        isRegistered = false
      }
      window.removeEventListener('popstate', onPopState)
      if (hasPushedHistory) {
        hasPushedHistory = false
        try {
          window.history.back()
        } catch {
          // Ignored
        }
      }
    }
  },
  { immediate: true }
)

onUnmounted(() => {
  if (typeof window !== 'undefined') {
    window.removeEventListener('popstate', onPopState)
    if (hasPushedHistory) {
      hasPushedHistory = false
      try {
        window.history.back()
      } catch {
        // Ignored
      }
    }
  }
  if (isRegistered) {
    registerModalClose()
    isRegistered = false
  }
  if (typeof window !== 'undefined') {
    window.removeEventListener('popstate', onPopState)
    if (hasPushedHistory) {
      hasPushedHistory = false
      try {
        window.history.back()
      } catch {
        // Ignored
      }
    }
  }
})
</script>

<template>
  <Teleport to="body">
    <Transition
      enter-active-class="transition duration-200 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-150 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="show"
        class="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-950/60 backdrop-blur-xs"
        @click.self="handleClose"
      >
        <div
          class="bg-white rounded-3xl p-6 shadow-2xl max-w-xs w-full text-center flex flex-col items-center animate-in fade-in zoom-in-95 duration-200"
        >
          <!-- Icon -->
          <div
            v-if="type === 'danger'"
            class="w-12 h-12 rounded-2xl bg-rose-50 text-rose-600 flex items-center justify-center mb-4"
          >
            <LogOut class="w-6 h-6" />
          </div>
          <div
            v-else-if="type === 'warning'"
            class="w-12 h-12 rounded-2xl bg-amber-50 text-amber-600 flex items-center justify-center mb-4"
          >
            <AlertTriangle class="w-6 h-6" />
          </div>
          <div
            v-else
            class="w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-800 flex items-center justify-center mb-4"
          >
            <Info class="w-6 h-6" />
          </div>

          <!-- Title & Message -->
          <h3 class="text-base font-bold text-slate-900 mb-1">
            {{ title }}
          </h3>
          <p class="text-xs text-slate-500 leading-relaxed mb-6">
            {{ message }}
          </p>

          <!-- Action Buttons -->
          <div class="flex items-center gap-3 w-full">
            <button
              type="button"
              class="flex-1 py-3 px-4 rounded-xl text-xs font-semibold bg-slate-100 text-slate-700 hover:bg-slate-200 active:scale-98 transition-all"
              @click="handleClose"
            >
              {{ cancelText }}
            </button>
            <button
              type="button"
              :class="[
                'flex-1 py-3 px-4 rounded-xl text-xs font-semibold text-white active:scale-98 transition-all shadow-sm',
                type === 'danger'
                  ? 'bg-rose-600 hover:bg-rose-700 shadow-rose-600/20'
                  : 'bg-emerald-950 hover:bg-emerald-900 shadow-emerald-950/20'
              ]"
              @click="handleConfirm"
            >
              {{ confirmText }}
            </button>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
