<script setup lang="ts">
import { AlertTriangle, Clock, Sparkles } from 'lucide-vue-next'

defineProps<{
  total: number
  expiring: number
  expired: number
}>()
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
        <span class="text-xs px-2.5 py-1 rounded-full bg-emerald-800/60 text-emerald-200 border border-emerald-700/40 font-medium">
          Всего: {{ total }}
        </span>
      </div>

      <div class="grid grid-cols-2 gap-2.5 pt-1">
        <!-- Expiring Soon Pill -->
        <div
          class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-2xl border transition-all"
          :class="expiring > 0 ? 'bg-amber-500/15 border-amber-500/30 text-amber-200' : 'bg-emerald-900/40 border-emerald-800/30 text-emerald-300/70'"
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
        </div>

        <!-- Expired Pill -->
        <div
          class="flex items-center gap-2.5 px-3.5 py-2.5 rounded-2xl border transition-all"
          :class="expired > 0 ? 'bg-rose-500/15 border-rose-500/30 text-rose-200' : 'bg-emerald-900/40 border-emerald-800/30 text-emerald-300/70'"
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
        </div>
      </div>
    </div>
  </div>
</template>
