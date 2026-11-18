<script setup lang="ts">
import { ref, computed } from 'vue'
import { triggerHaptic } from '@/utils/haptics'
import type { LocalInventoryItem } from '@/db/types'
import { getFreshnessInfo, formatQuantity } from '@/utils/freshness'
import { Edit3, Trash2, CloudOff, ChevronRight, Apple, Beef, Milk, Fish, Wheat, Sparkles } from 'lucide-vue-next'

const props = defineProps<{
  item: LocalInventoryItem
}>()

const emit = defineEmits<{
  (e: 'delete', id: number): void
  (e: 'edit', item: LocalInventoryItem): void
}>()

const showActions = ref(false)

const freshness = computed(() => getFreshnessInfo(props.item.expirationDate))
const formattedQuantity = computed(() =>
  formatQuantity(props.item.amount, props.item.unit, props.item.approximateQuantity)
)

function getCategoryIcon(cat?: string) {
  if (!cat) return Sparkles
  const c = cat.toLowerCase()
  if (c.includes('овощ') || c.includes('фрукт')) return Apple
  if (c.includes('мясо') || c.includes('птиц')) return Beef
  if (c.includes('молоч') || c.includes('сыр')) return Milk
  if (c.includes('рыб') || c.includes('море')) return Fish
  if (c.includes('бакал') || c.includes('хлеб') || c.includes('круп')) return Wheat
  return Sparkles
}

function onCardClick() {
  triggerHaptic('light')
  showActions.value = !showActions.value
}

function handleEdit() {
  triggerHaptic('light')
  showActions.value = false
  emit('edit', props.item)
}

function handleDelete() {
  triggerHaptic('warning')
  showActions.value = false
  if (props.item.id) {
    emit('delete', props.item.id)
  }
}
</script>

<template>
  <div class="rounded-2xl bg-white border border-slate-100 shadow-sm hover:shadow-md transition-all overflow-hidden mb-2.5">
    <!-- Main Card Body -->
    <div
      class="p-3.5 flex items-center justify-between gap-3 cursor-pointer select-none active:bg-slate-50/80 transition-colors"
      @click="onCardClick"
    >
      <!-- Category Avatar & Details -->
      <div class="flex items-center gap-3 min-w-0 flex-1">
        <div class="w-11 h-11 rounded-xl bg-emerald-50 text-emerald-800 flex items-center justify-center shrink-0 border border-emerald-100/60 shadow-xs">
          <component :is="getCategoryIcon(item.category)" class="w-5 h-5 stroke-[2px]" />
        </div>

        <div class="flex flex-col min-w-0">
          <span class="text-[15px] font-semibold text-slate-900 truncate leading-snug">
            {{ item.name }}
          </span>
          <div class="flex items-center gap-1.5 mt-0.5">
            <span class="text-xs text-slate-400 font-medium">
              {{ item.category || 'Продукт' }}
            </span>
            <span v-if="item.synced === 0" class="text-amber-500" title="Сохранено локально">
              <CloudOff class="w-3 h-3" />
            </span>
          </div>
        </div>
      </div>

      <!-- Quantity & Status Badge -->
      <div class="flex flex-col items-end gap-1.5 shrink-0">
        <span v-if="formattedQuantity" class="text-xs font-semibold px-2 py-0.5 rounded-lg bg-slate-100 text-slate-700">
          {{ formattedQuantity }}
        </span>

        <div
          class="flex items-center gap-1 px-2 py-0.5 rounded-md text-[11px] font-medium"
          :style="{ backgroundColor: freshness.color + '15', color: freshness.color }"
        >
          <span class="w-1.5 h-1.5 rounded-full" :style="{ backgroundColor: freshness.color }" />
          <span>{{ freshness.label }}</span>
        </div>
      </div>

      <!-- Action Indicator Chevron -->
      <ChevronRight
        class="w-4 h-4 text-slate-300 transition-transform duration-200 shrink-0 -ml-1"
        :class="{ 'rotate-90 text-emerald-800': showActions }"
      />
    </div>

    <!-- Collapsible Action Drawer -->
    <Transition
      enter-active-class="transition-all duration-200 ease-out"
      enter-from-class="max-h-0 opacity-0"
      enter-to-class="max-h-16 opacity-100"
      leave-active-class="transition-all duration-150 ease-in"
      leave-from-class="max-h-16 opacity-100"
      leave-to-class="max-h-0 opacity-0"
    >
      <div v-if="showActions" class="px-3.5 pb-3 pt-1 border-t border-slate-100/80 bg-slate-50/50 flex gap-2 overflow-hidden">
        <button
          type="button"
          class="flex-1 py-2 px-3 rounded-xl bg-white border border-slate-200 text-slate-700 text-xs font-semibold flex items-center justify-center gap-1.5 hover:bg-slate-50 active:scale-98 transition-all"
          @click.stop="handleEdit"
        >
          <Edit3 class="w-3.5 h-3.5 text-slate-500" />
          <span>Изменить</span>
        </button>

        <button
          type="button"
          class="flex-1 py-2 px-3 rounded-xl bg-rose-50 border border-rose-200/80 text-rose-700 text-xs font-semibold flex items-center justify-center gap-1.5 hover:bg-rose-100 active:scale-98 transition-all"
          @click.stop="handleDelete"
        >
          <Trash2 class="w-3.5 h-3.5 text-rose-600" />
          <span>Удалить</span>
        </button>
      </div>
    </Transition>
  </div>
</template>
