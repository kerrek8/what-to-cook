<script setup lang="ts">
import { AlertTriangle, Clock, Sparkles } from 'lucide-vue-next'
import { triggerHaptic } from '@/utils/haptics'

const props = withDefaults(
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
  <div class="relative overflow-hidden rounded-3xl bg-gradient-to-br from-emerald-950 via-emerald-900 to-emerald-950 text-white p-5 shadow-elevated border border-emerald-800/40">
    <!-- Subtle background culinary accent circle -->
    <div class="absolute -right-8 -top-8 w-32 h-32 bg-emerald-700/20 rounded-full blur-2xl pointer-events-none" />
    <div class="absolute -left-8 -bottom-8 w-28 h-28 bg-emerald-500/10 rounded-full blur-xl pointer-events-none" />

    <div class="relative z-10 flex flex-col gap-4">
      <div class="flex items-center justify-between">
        <span class="text-xs uppercase tracking-wider font-semibold text-emerald-300/90 flex items-center gap-1.5">
          <Sparkles class="w-3.5 h-3.5 text-emerald-400" />
          Сводка продуктов
        </span>
        <button
          type="button"
          class="text-xs px-2.5 py-1 rounded-full border font-medium cursor-pointer active:scale-95 transition-all"
          :class="
            activeFilter === 'all'
              ? 'bg-emerald-700 text-white border-emerald-500 ring-2 ring-emerald-400/40'
              : 'bg-emerald-800/60 text-emerald-200 border-emerald-700/40 hover:bg-emerald-800'
          "
          @click="onSelect('all')"
        >
          Всего: {{ total }}
        </button>
      </div>

      <div class="grid grid-cols-2 gap-2.5 pt-1">
        <!-- Expiring Soon Pill (Tactile) -->
        <button
          type="button"
          class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-2xl border text-left cursor-pointer active:scale-95 transition-all select-none"
          :class="[
            activeFilter === 'expiring'
              ? 'ring-2 ring-amber-400 border-amber-400 bg-amber-500/25 text-amber-200 shadow-md'
              : expiring > 0
                ? 'bg-amber-500/15 border-amber-500/30 text-amber-200 hover:bg-amber-500/20'
                : 'bg-emerald-900/40 border-emerald-800/30 text-emerald-300/70'
          ]"
          @click="onSelect('expiring')"
        >
          <div
            class="w-8 h-8 rounded-xl flex items-center justify-center shrink-0"
            :class="expiring > 0 ? 'bg-amber-500/20 text-amber-300' : 'bg-emerald-800/40 text-emerald-300'"
          >
            <Clock class="w-4 h-4" />
          </div>
          <div class="flex flex-col min-w-0">
            <span class="text-xs text-slate-300 font-medium leading-none">Истекают</span>
            <span class="text-base font-bold leading-tight mt-0.5" :class="expiring > 0 ? 'text-amber-300' : 'text-slate-300'">
              {{ expiring }}
            </span>
          </div>
        </button>

        <!-- Expired Pill (Tactile) -->
        <button
          type="button"
          class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-2xl border text-left cursor-pointer active:scale-95 transition-all select-none"
          :class="[
            activeFilter === 'expired'
              ? 'ring-2 ring-rose-400 border-rose-400 bg-rose-500/25 text-rose-200 shadow-md'
              : expired > 0
                ? 'bg-rose-500/15 border-rose-500/30 text-rose-200 hover:bg-rose-500/20'
                : 'bg-emerald-900/40 border-emerald-800/30 text-emerald-300/70'
          ]"
          @click="onSelect('expired')"
        >
          <div
            class="w-8 h-8 rounded-xl flex items-center justify-center shrink-0"
            :class="expired > 0 ? 'bg-rose-500/20 text-rose-300' : 'bg-emerald-800/40 text-emerald-300'"
          >
            <AlertTriangle class="w-4 h-4" />
          </div>
          <div class="flex flex-col min-w-0">
            <span class="text-xs text-slate-300 font-medium leading-none">Просрочено</span>
            <span class="text-base font-bold leading-tight mt-0.5" :class="expired > 0 ? 'text-rose-300' : 'text-slate-300'">
              {{ expired }}
            </span>
          </div>
        </button>
      </div>
    </div>
  </div>
</template>
