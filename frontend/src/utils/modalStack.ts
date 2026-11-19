import { ref } from 'vue'

export const activeModalCount = ref(0)

export function registerModalOpen() {
  activeModalCount.value++
}

export function registerModalClose() {
  if (activeModalCount.value > 0) {
    activeModalCount.value--
  }
}

export function resetModalStack() {
  activeModalCount.value = 0
}
