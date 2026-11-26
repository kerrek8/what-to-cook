<script setup lang="ts">
import { ref, watch, onUnmounted } from 'vue'
import { X } from 'lucide-vue-next'
import { registerModalOpen, registerModalClose } from '@/utils/modalStack'

const props = withDefaults(
  defineProps<{
    show: boolean
    title?: string
    showClose?: boolean
  }>(),
  {
    title: '',
    showClose: true
  }
)

const emit = defineEmits<{
  (e: 'update:show', value: boolean): void
  (e: 'close'): void
}>()

let hasPushedHistory = false
const dragOffsetY = ref(0)
const isDragging = ref(false)
let touchStartY = 0

function onTouchStart(e: TouchEvent) {
  if (e.touches.length !== 1) return
  touchStartY = e.touches[0].clientY
  isDragging.value = true
  dragOffsetY.value = 0
}

function onTouchMove(e: TouchEvent) {
  if (!isDragging.value || e.touches.length !== 1) return
  const currentY = e.touches[0].clientY
  const delta = currentY - touchStartY
  if (delta > 0) {
    dragOffsetY.value = delta
  }
}

function onTouchEnd() {
  if (!isDragging.value) return
  isDragging.value = false
  if (dragOffsetY.value > 80) {
    close()
  }
  dragOffsetY.value = 0
}

function close() {
  emit('update:show', false)
  emit('close')
}

function onPopState() {
  if (props.show) {
    hasPushedHistory = false
    close()
  }
}

watch(
  () => props.show,
  (val) => {
    if (typeof window === 'undefined') return

    if (val) {
      registerModalOpen()
      document.body.style.overflow = 'hidden'
      // Push state so Android/browser back gesture closes the bottom sheet instead of exiting/navigating
      try {
        window.history.pushState({ bottomSheetOpen: true }, '')
        hasPushedHistory = true
        window.addEventListener('popstate', onPopState)
      } catch {
        // Fallback if pushState fails in restricted sandbox
      }
    } else {
      registerModalClose()
      document.body.style.overflow = ''
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
  }
)

onUnmounted(() => {
  if (typeof window !== 'undefined') {
    if (props.show) {
      registerModalClose()
    }
    document.body.style.overflow = ''
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
      enter-active-class="transition duration-300 ease-out"
      enter-from-class="opacity-0"
      enter-to-class="opacity-100"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="opacity-100"
      leave-to-class="opacity-0"
    >
      <div
        v-if="show"
        class="fixed inset-0 z-50 bg-slate-900/60 backdrop-blur-sm"
        @click="close"
      />
    </Transition>

    <Transition
      enter-active-class="transition duration-300 cubic-bezier(0.16, 1, 0.3, 1)"
      enter-from-class="translate-y-full"
      enter-to-class="translate-y-0"
      leave-active-class="transition duration-200 ease-in"
      leave-from-class="translate-y-0"
      leave-to-class="translate-y-full"
    >
      <div
        v-if="show"
        class="fixed inset-x-0 bottom-0 z-50 max-w-lg mx-auto bg-white rounded-t-3xl shadow-elevated overflow-hidden max-h-[90vh] flex flex-col safe-area-bottom will-change-transform"
        :style="dragOffsetY > 0 ? { transform: `translateY(${dragOffsetY}px)`, transition: isDragging ? 'none' : 'transform 0.2s ease-out' } : undefined"
        role="dialog"
        aria-modal="true"
      >
        <!-- Drag Handle with swipe-to-dismiss gesture -->
        <div
          class="pt-3 pb-2 flex justify-center cursor-grab active:cursor-grabbing touch-none select-none"
          @click="close"
          @touchstart="onTouchStart"
          @touchmove="onTouchMove"
          @touchend="onTouchEnd"
        >
          <div class="w-10 h-1.5 rounded-full bg-slate-300" />
        </div>

        <!-- Header -->
        <div v-if="title || $slots.header || showClose" class="px-5 py-3 flex items-center justify-between border-b border-slate-100">
          <slot name="header">
            <h2 class="text-lg font-bold text-slate-900">{{ title }}</h2>
          </slot>
          <button
            v-if="showClose"
            type="button"
            class="p-1.5 -mr-1 rounded-full text-slate-400 hover:text-slate-600 hover:bg-slate-100 transition-colors"
            aria-label="Закрыть"
            @click="close"
          >
            <X class="w-5 h-5" />
          </button>
        </div>

        <!-- Content -->
        <div class="px-5 py-4 overflow-y-auto flex-1">
          <slot />
        </div>

        <!-- Footer -->
        <div v-if="$slots.footer" class="px-5 py-3 border-t border-slate-100 bg-slate-50/50">
          <slot name="footer" />
        </div>
      </div>
    </Transition>
  </Teleport>
</template>
