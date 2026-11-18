<script setup lang="ts">
import { computed } from 'vue'
import { useRoute, RouterLink } from 'vue-router'
import { useInventoryStore } from '@/stores/inventory'
import { useShoppingStore } from '@/stores/shopping'
import { scrollToTop } from '@/utils/scroll'
import { LayoutGrid, Flame, ShoppingCart, User } from 'lucide-vue-next'

const route = useRoute()
const inventoryStore = useInventoryStore()
const shoppingStore = useShoppingStore()

const pendingShoppingCount = computed(() => {
  const n = shoppingStore.items.filter((i) => !i.isBought).length
  return n > 0 ? (n > 99 ? '99+' : n) : undefined
})

const hasExpiringProducts = computed(() => inventoryStore.expiringCount > 0)

const tabs = [
  { name: 'Холодильник', path: '/fridge', icon: LayoutGrid, hasDot: true },
  { name: 'Рецепты', path: '/recipes', icon: Flame },
  { name: 'Покупки', path: '/shopping', icon: ShoppingCart, hasBadge: true },
  { name: 'Профиль', path: '/profile', icon: User }
]

function handleTabClick(targetPath: string) {
  if (route.path === targetPath) {
    scrollToTop()
  }
}
</script>

<template>
  <nav
    v-if="!route.meta.hideTabBar"
    class="fixed bottom-0 inset-x-0 z-40 max-w-lg mx-auto bg-white/95 backdrop-blur-md border-t border-slate-200/80 safe-area-bottom shadow-lg"
  >
    <div class="flex items-center justify-around h-14 px-2">
      <RouterLink
        v-for="tab in tabs"
        :key="tab.path"
        :to="tab.path"
        replace
        class="relative flex flex-col items-center justify-center flex-1 py-1 transition-all group"
        :class="route.path.startsWith(tab.path) ? 'text-emerald-950 font-semibold' : 'text-slate-400 hover:text-slate-600'"
        @click="handleTabClick(tab.path)"
      >
        <div class="relative flex items-center justify-center">
          <component
            :is="tab.icon"
            class="w-5 h-5 transition-transform group-active:scale-90"
            :class="route.path.startsWith(tab.path) ? 'stroke-[2.5px]' : 'stroke-[1.8px]'"
          />
          <!-- Expiration Warning Dot -->
          <span
            v-if="tab.hasDot && hasExpiringProducts"
            class="absolute -top-1 -right-1 w-2.5 h-2.5 bg-amber-500 rounded-full border-2 border-white ring-1 ring-amber-400/50"
          />
          <!-- Shopping Badge -->
          <span
            v-if="tab.hasBadge && pendingShoppingCount"
            class="absolute -top-1.5 -right-2.5 min-w-[16px] h-4 px-1 flex items-center justify-center text-[10px] font-bold text-white bg-emerald-700 rounded-full border border-white"
          >
            {{ pendingShoppingCount }}
          </span>
        </div>
        <span class="text-[11px] mt-1 tracking-tight leading-none">{{ tab.name }}</span>
      </RouterLink>
    </div>
  </nav>
</template>
