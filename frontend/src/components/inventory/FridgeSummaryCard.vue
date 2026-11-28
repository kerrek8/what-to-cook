<script setup lang="ts">
import { AlertTriangle, Clock, Package } from 'lucide-vue-next'
import { triggerHaptic } from '@/utils/haptics'

withDefaults(
  defineProps<{
    total: number
    expiring: number
    expired: number
    activeFilter?: string
  }>(),
  {
    activeFilter: 'all'
  }
)

const emit = defineEmits<{
  (e: 'select-filter', filter: string): void
}>()

function onSelect(filter: string) {
  triggerHaptic('light')
  emit('select-filter', filter)
}
</script>

<template>
  <div class="bg-white border border-slate-200/80 rounded-2xl p-1.5 shadow-xs grid grid-cols-3 gap-1.5">
    <button
      type="button"
      class="flex items-center justify-center gap-1.5 px-2 py-2 rounded-xl text-xs font-semibold transition-all active:scale-95 select-none"
      :class="
        activeFilter === 'all'
          ? 'bg-emerald-950 text-white shadow-xs'
          : 'text-slate-600 hover:bg-slate-50'
      "
      @click="onSelect('all')"
    >
      <Package class="w-3.5 h-3.5 shrink-0" :class="activeFilter === 'all' ? 'text-emerald-300' : 'text-slate-400'" />
      <span class="truncate">Всего</span>
      <span class="font-bold">{{ total }}</span>
    </button>

    <button
      type="button"
      class="flex items-center justify-center gap-1.5 px-2 py-2 rounded-xl text-xs font-semibold transition-all active:scale-95 select-none"
      :class="
        activeFilter === 'expiring'
          ? 'bg-amber-500 text-white shadow-xs'
          : expiring > 0
            ? 'bg-amber-50/80 text-amber-800 hover:bg-amber-100/70'
            : 'text-slate-500 hover:bg-slate-50'
      "
      @click="onSelect('expiring')"
    >
      <Clock class="w-3.5 h-3.5 shrink-0" :class="activeFilter === 'expiring' ? 'text-white' : expiring > 0 ? 'text-amber-600' : 'text-slate-400'" />
      <span class="truncate">Истекают</span>
      <span class="font-bold">{{ expiring }}</span>
    </button>

    <button
      type="button"
      class="flex items-center justify-center gap-1.5 px-2 py-2 rounded-xl text-xs font-semibold transition-all active:scale-95 select-none"
      :class="
        activeFilter === 'expired'
          ? 'bg-rose-600 text-white shadow-xs'
          : expired > 0
            ? 'bg-rose-50/80 text-rose-700 hover:bg-rose-100/70'
            : 'text-slate-500 hover:bg-slate-50'
      "
      @click="onSelect('expired')"
    >
      <AlertTriangle class="w-3.5 h-3.5 shrink-0" :class="activeFilter === 'expired' ? 'text-white' : expired > 0 ? 'text-rose-500' : 'text-slate-400'" />
      <span class="truncate">Просроч.</span>
      <span class="font-bold">{{ expired }}</span>
    </button>
  </div>
</template>
