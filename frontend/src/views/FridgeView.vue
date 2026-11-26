<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useInventoryStore, type AddItemData } from '@/stores/inventory'
import { useToastStore } from '@/stores/toast'
import ProductCard from '@/components/inventory/ProductCard.vue'
import AddProductSheet from '@/components/inventory/AddProductSheet.vue'
import FridgeSummaryCard from '@/components/inventory/FridgeSummaryCard.vue'
import { Search, X, Plus, Refrigerator, ArrowUpDown } from 'lucide-vue-next'

const inventoryStore = useInventoryStore()
const toast = useToastStore()

const showAddSheet = ref(false)
const editingItem = ref<import('@/db/types').LocalInventoryItem | null>(null)

const sortLabel = computed(() => {
  if (inventoryStore.sortBy === 'alphabet') return 'По алфавиту'
  if (inventoryStore.sortBy === 'created') return 'Сначала новые'
  return 'По сроку'
})

function cycleSort() {
  if (inventoryStore.sortBy === 'expiration') {
    inventoryStore.sortBy = 'alphabet'
  } else if (inventoryStore.sortBy === 'alphabet') {
    inventoryStore.sortBy = 'created'
  } else {
    inventoryStore.sortBy = 'expiration'
  }
}

async function onAddItem(data: AddItemData) {
  try {
    await inventoryStore.addItem(data)
    toast.show(`${data.name} добавлен в холодильник`, 'success')
  } catch {
    toast.show('Ошибка при добавлении продукта', 'fail')
  }
}

async function onUpdateItem(payload: { id: number; changes: Partial<import('@/db/types').LocalInventoryItem> }) {
  try {
    await inventoryStore.updateItem(payload.id, payload.changes)
    editingItem.value = null
    showAddSheet.value = false
    toast.show('Продукт обновлен', 'success')
  } catch {
    toast.show('Ошибка при обновлении', 'fail')
  }
}

async function onDeleteItem(id: number) {
  try {
    await inventoryStore.deleteItem(id)
    toast.show('Продукт удален', 'info')
  } catch {
    toast.show('Ошибка при удалении', 'fail')
  }
}

onMounted(() => {
  inventoryStore.loadInventory()
})
</script>

<template>
  <div class="min-h-full pb-36 px-4 pt-3 flex flex-col gap-4">
    <!-- Top Emerald Summary Hero Card -->
    <FridgeSummaryCard
      :total="inventoryStore.items.length"
      :expiring="inventoryStore.expiringCount"
      :expired="inventoryStore.items.filter((i) => i.expirationDate && new Date(i.expirationDate) < new Date()).length"
      :active-filter="inventoryStore.activeCategory"
      @select-filter="(filter) => inventoryStore.activeCategory = filter"
    />

    <!-- Search & Sort Row -->
    <div class="flex items-center gap-2">
      <div class="relative flex-1 flex items-center">
        <Search class="absolute left-3.5 w-4 h-4 text-slate-400 pointer-events-none stroke-[2.2px]" />
        <input
          v-model="inventoryStore.searchQuery"
          type="text"
          enterkeyhint="search"
          placeholder="Поиск продуктов в холодильнике..."
          class="w-full pl-10 pr-9 py-2.5 bg-white border border-slate-200/90 rounded-2xl text-sm placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 transition-all shadow-xs"
        />
        <button
          v-if="inventoryStore.searchQuery"
          type="button"
          class="absolute right-3 p-1 text-slate-400 hover:text-slate-600 rounded-full"
          aria-label="Очистить поиск"
          @click="inventoryStore.searchQuery = ''"
        >
          <X class="w-4 h-4" />
        </button>
      </div>

      <!-- Sort Toggle -->
      <button
        type="button"
        class="h-10 px-3 rounded-2xl bg-white border border-slate-200/90 text-xs font-semibold text-slate-700 flex items-center gap-1.5 active:scale-95 transition-all shadow-xs shrink-0"
        :aria-label="`Сортировка: ${sortLabel}`"
        @click="cycleSort"
      >
        <ArrowUpDown class="w-3.5 h-3.5 text-emerald-800" />
        <span>{{ sortLabel }}</span>
      </button>
    </div>

    <!-- Category Filters (Horizontal Scroll) -->
    <div class="flex items-center gap-2 overflow-x-auto no-scrollbar -mx-4 px-4 py-0.5">
      <button
        type="button"
        class="shrink-0 px-3.5 py-1.5 rounded-xl text-xs font-semibold transition-all border shadow-xs whitespace-nowrap"
        :class="
          inventoryStore.activeCategory === 'all'
            ? 'bg-emerald-950 text-white border-emerald-950 shadow-sm'
            : 'bg-white text-slate-600 border-slate-200/80 hover:bg-slate-50'
        "
        @click="inventoryStore.activeCategory = 'all'"
      >
        Все ({{ inventoryStore.items.length }})
      </button>
      <button
        v-for="cat in inventoryStore.categories"
        :key="cat"
        type="button"
        class="shrink-0 px-3.5 py-1.5 rounded-xl text-xs font-semibold transition-all border shadow-xs whitespace-nowrap"
        :class="
          inventoryStore.activeCategory === cat
            ? 'bg-emerald-950 text-white border-emerald-950 shadow-sm'
            : 'bg-white text-slate-600 border-slate-200/80 hover:bg-slate-50'
        "
        @click="inventoryStore.activeCategory = cat"
      >
        {{ cat }}
      </button>
    </div>

    <!-- Product List -->
    <div v-if="inventoryStore.filteredItems.length > 0" class="flex flex-col">
      <ProductCard
        v-for="item in inventoryStore.filteredItems"
        :key="item.id || item.serverId || item.name"
        :item="item"
        @delete="onDeleteItem"
        @edit="(it) => { editingItem = it; showAddSheet = true }"
      />
    </div>

    <!-- Empty State -->
    <div v-else class="flex flex-col items-center justify-center py-16 px-4 text-center">
      <div class="w-16 h-16 rounded-3xl bg-emerald-50 text-emerald-800 border border-emerald-100 shadow-xs flex items-center justify-center mb-4">
        <Refrigerator class="w-8 h-8 stroke-[1.8px]" />
      </div>
      <h3 class="text-base font-bold text-slate-900 mb-1">
        {{
          inventoryStore.searchQuery
            ? 'Ничего не найдено'
            : inventoryStore.activeCategory !== 'all'
              ? `В категории «${inventoryStore.activeCategory}» пока нет продуктов`
              : 'В холодильнике пока пусто'
        }}
      </h3>
      <p class="text-xs text-slate-500 max-w-xs mb-5">
        {{
          inventoryStore.searchQuery
            ? 'Попробуйте изменить поисковый запрос или фильтр'
            : inventoryStore.activeCategory !== 'all'
              ? 'Вы можете сбросить фильтр или добавить первый продукт в эту категорию'
              : 'Добавьте первые продукты, чтобы WhatCook мог подбирать рецепты'
        }}
      </p>
      <div class="flex items-center gap-2">
        <button
          v-if="inventoryStore.activeCategory !== 'all'"
          type="button"
          class="py-2.5 px-4 rounded-2xl bg-slate-100 text-slate-700 text-sm font-semibold hover:bg-slate-200 active:scale-98 transition-all"
          @click="inventoryStore.activeCategory = 'all'"
        >
          Все категории
        </button>
        <button
          type="button"
          class="py-2.5 px-5 rounded-2xl bg-emerald-950 text-white text-sm font-semibold flex items-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/15"
          @click="showAddSheet = true"
        >
          <Plus class="w-4 h-4 stroke-[2.5px]" />
          <span>Добавить продукт</span>
        </button>
      </div>
    </div>

    <!-- Floating Action Button (FAB) -->
    <div class="fixed bottom-[calc(4.5rem+env(safe-area-inset-bottom,0px))] inset-x-0 max-w-lg mx-auto flex justify-center pointer-events-none z-30 px-4">
      <button
        type="button"
        class="pointer-events-auto py-3 px-6 rounded-full bg-emerald-950 text-white text-sm font-bold flex items-center gap-2 shadow-elevated hover:bg-emerald-900 active:scale-95 transition-all"
        @click="showAddSheet = true"
      >
        <Plus class="w-4 h-4 stroke-[3px]" />
        <span>Добавить продукт</span>
      </button>
    </div>

    <!-- Add Product Sheet Modal -->
    <AddProductSheet
      v-model:show="showAddSheet"
      :edit-item="editingItem"
      @add="onAddItem"
      @update="onUpdateItem"
    />
  </div>
</template>
