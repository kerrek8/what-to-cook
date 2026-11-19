<script setup lang="ts">
import { computed } from 'vue'
import type { LocalShoppingItem } from '@/db/types'
import { triggerHaptic } from '@/utils/haptics'
import { Check, Trash2, Refrigerator } from 'lucide-vue-next'

const props = defineProps<{
  item: LocalShoppingItem
}>()

const emit = defineEmits<{
  (e: 'toggle', id: number): void
  (e: 'delete', id: number): void
  (e: 'transfer', item: LocalShoppingItem): void
}>()

const formattedQuantity = computed(() => {
  if (props.item.amount != null && props.item.amount > 0) {
    return `${props.item.amount} ${props.item.unit ?? ''}`.trim()
  }
  return null
})

function onToggle() {
  triggerHaptic('light')
  if (props.item.id != null) {
    emit('toggle', props.item.id)
  }
}

function onDelete() {
  triggerHaptic('warning')
  if (props.item.id != null) {
    emit('delete', props.item.id)
  }
}

function onTransfer() {
  triggerHaptic('success')
  emit('transfer', props.item)
}
</script>

<template>
  <div
    class="flex items-center justify-between gap-3 p-3.5 mb-2 rounded-2xl border transition-all cursor-pointer select-none"
    :class="
      item.isBought
        ? 'bg-slate-50/70 border-slate-200/60 opacity-60'
        : 'bg-white border-slate-100 shadow-xs hover:border-slate-200'
    "
    @click="onToggle"
  >
    <!-- Left Checkbox & Name -->
    <div class="flex items-center gap-3 min-w-0 flex-1 mr-2">
      <div
        class="w-6 h-6 rounded-lg flex items-center justify-center shrink-0 border transition-all"
        :class="
          item.isBought
            ? 'bg-emerald-950 text-white border-emerald-950'
            : 'bg-white border-slate-300 hover:border-slate-400'
        "
        @click.stop="onToggle"
      >
        <Check v-if="item.isBought" class="w-3.5 h-3.5 stroke-[3px]" />
      </div>

      <div class="flex flex-col min-w-0 pr-1">
        <span
          class="text-sm font-semibold text-slate-800 truncate"
          :class="{ 'line-through text-slate-400': item.isBought }"
        >
          {{ item.name }}
        </span>
        <span class="text-xs text-slate-400">
          {{ item.category || 'Продукты' }}
        </span>
      </div>
    </div>

    <!-- Right: Quantity Pill & Action Buttons -->
    <div class="flex items-center gap-2 shrink-0 ml-auto">
      <span
        v-if="formattedQuantity"
        class="text-xs font-semibold px-2.5 py-1 rounded-lg bg-slate-100 text-slate-700 whitespace-nowrap"
      >
        {{ formattedQuantity }}
      </span>

      <!-- Transfer to Fridge Button -->
      <button
        v-if="item.isBought"
        type="button"
        class="p-2 rounded-xl bg-emerald-50 text-emerald-800 hover:bg-emerald-100 border border-emerald-200/60 active:scale-95 transition-all"
        title="Перенести в холодильник"
        aria-label="В холодильник"
        @click.stop="onTransfer"
      >
        <Refrigerator class="w-4 h-4 stroke-[2px]" />
      </button>

      <!-- Delete Button -->
      <button
        type="button"
        class="p-2 rounded-xl text-slate-400 hover:text-rose-600 hover:bg-rose-50 active:scale-95 transition-all"
        title="Удалить из списка"
        aria-label="Удалить"
        @click.stop="onDelete"
      >
        <Trash2 class="w-4 h-4 stroke-[1.8px]" />
      </button>
    </div>
  </div>
</template>
