<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useShoppingStore, type AddShoppingItemPayload } from '@/stores/shopping'
import { useInventoryStore, type AddItemData } from '@/stores/inventory'
import { useToastStore } from '@/stores/toast'
import type { LocalShoppingItem } from '@/db/types'
import ShoppingItemCard from '@/components/shopping/ShoppingItemCard.vue'
import AddShoppingItemSheet from '@/components/shopping/AddShoppingItemSheet.vue'
import AddProductSheet from '@/components/inventory/AddProductSheet.vue'
import { Search, X, Plus, ShoppingCart, Refrigerator, ChevronDown, CheckCheck } from 'lucide-vue-next'

const shoppingStore = useShoppingStore()
const inventoryStore = useInventoryStore()
const toast = useToastStore()

const showAddSheet = ref(false)
const showTransferSheet = ref(false)
const isBoughtExpanded = ref(true)
const transferQueue = ref<LocalShoppingItem[]>([])
const currentTransferIndex = ref(0)
const searchQuery = ref('')

onMounted(() => {
  shoppingStore.loadShoppingList()
})

const currentTransferItem = computed(() => {
  if (currentTransferIndex.value >= 0 && currentTransferIndex.value < transferQueue.value.length) {
    return transferQueue.value[currentTransferIndex.value]
  }
  return null
})

const transferInitialData = computed(() => {
  const item = currentTransferItem.value
  if (!item) return null
  return {
    id: item.id,
    name: item.name,
    category: item.category || 'Другое',
    amount: item.amount != null ? Number(item.amount) : null,
    unit: item.unit || 'г',
    approximateQuantity: null,
    expirationDate: null,
    ingredientId: item.ingredientId ?? null
  }
})

const transferSheetTitle = computed(() => {
  const total = transferQueue.value.length
  if (total <= 1) {
    return currentTransferItem.value ? `Перенос: ${currentTransferItem.value.name}` : 'Перенос в холодильник'
  }
  return `В холодильник (${currentTransferIndex.value + 1} из ${total}): ${currentTransferItem.value?.name || ''}`
})

const activeItems = computed(() => {
  let list = shoppingStore.items.filter((i) => !i.isBought)
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.trim().toLowerCase()
    list = list.filter((i) => i.name.toLowerCase().includes(q))
  }
  return list
})

const boughtItems = computed(() => {
  let list = shoppingStore.items.filter((i) => i.isBought)
  if (searchQuery.value.trim()) {
    const q = searchQuery.value.trim().toLowerCase()
    list = list.filter((i) => i.name.toLowerCase().includes(q))
  }
  return list
})

const totalCount = computed(() => shoppingStore.items.length)
const boughtCount = computed(() => shoppingStore.boughtCount)
const progressPercent = computed(() => {
  if (totalCount.value === 0) return 0
  return Math.round((boughtCount.value / totalCount.value) * 100)
})

const lastDeletedItem = ref<LocalShoppingItem | null>(null)

async function onAddItem(payload: AddShoppingItemPayload) {
  try {
    await shoppingStore.addItem(payload)
    toast.show(`${payload.name} добавлен в список`, 'success')
  } catch {
    toast.show('Ошибка при добавлении', 'fail')
  }
}

async function onToggle(id: number) {
  await shoppingStore.toggleBought(id)
}

async function onDelete(id: number) {
  const item = shoppingStore.items.find((i) => i.id === id)
  if (item) {
    lastDeletedItem.value = { ...item }
  }
  try {
    await shoppingStore.deleteItem(id)
    toast.show('Удалено из списка', 'info')
  } catch {
    toast.show('Ошибка при удалении', 'fail')
  }
}

async function onUndoDelete() {
  if (!lastDeletedItem.value) return
  const item = lastDeletedItem.value
  lastDeletedItem.value = null
  try {
    await shoppingStore.addItem({
      name: item.name,
      category: item.category,
      ingredientId: item.ingredientId,
      amount: item.amount,
      unit: item.unit
    })
    toast.show('Товар восстановлен', 'success')
  } catch {
    toast.show('Не удалось восстановить', 'fail')
  }
}

function onSingleTransfer(item: LocalShoppingItem) {
  transferQueue.value = [item]
  currentTransferIndex.value = 0
  showTransferSheet.value = true
}

function onQuickTransferAll() {
  if (boughtItems.value.length === 0) return
  transferQueue.value = [...boughtItems.value]
  currentTransferIndex.value = 0
  showTransferSheet.value = true
}

async function onConfirmTransferItem(data: AddItemData) {
  const item = currentTransferItem.value
  if (!item || item.id == null) return

  try {
    await inventoryStore.addItem(data)
    await shoppingStore.deleteItem(item.id)

    if (currentTransferIndex.value < transferQueue.value.length - 1) {
      currentTransferIndex.value++
    } else {
      showTransferSheet.value = false
      toast.show('Товары перенесены в холодильник!', 'success')
    }
  } catch {
    toast.show('Ошибка при переносе', 'fail')
  }
}
</script>

<template>
  <div class="min-h-full pb-36 px-4 pt-3 flex flex-col gap-4">
    <!-- Progress Header Card (Figma Row 7) -->
    <div v-if="totalCount > 0" class="p-4 rounded-3xl bg-white border border-slate-200/80 shadow-xs flex flex-col gap-2.5">
      <div class="flex items-center justify-between">
        <span class="text-xs font-semibold text-slate-500 uppercase tracking-wider">
          Прогресс покупок
        </span>
        <span class="text-xs font-bold px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-100">
          {{ boughtCount }} из {{ totalCount }} ({{ progressPercent }}%)
        </span>
      </div>

      <!-- Progress Line -->
      <div class="w-full h-2 rounded-full bg-slate-100 overflow-hidden">
        <div
          class="h-full bg-gradient-to-r from-emerald-700 to-emerald-500 transition-all duration-300 rounded-full"
          :style="{ width: `${progressPercent}%` }"
        />
      </div>

      <!-- Quick Transfer All Button if items bought -->
      <button
        v-if="boughtCount > 0"
        type="button"
        class="mt-1 py-2 px-3 rounded-xl bg-emerald-50 border border-emerald-200/80 text-emerald-900 text-xs font-bold flex items-center justify-center gap-1.5 hover:bg-emerald-100 active:scale-98 transition-all"
        @click="onQuickTransferAll"
      >
        <Refrigerator class="w-4 h-4 text-emerald-700" />
        <span>Перенести все купленные в холодильник ({{ boughtCount }})</span>
      </button>
    </div>

    <!-- Search Input -->
    <div class="relative flex items-center">
      <Search class="absolute left-3.5 w-4 h-4 text-slate-400 pointer-events-none stroke-[2.2px]" />
      <input
        v-model="searchQuery"
        type="text"
        placeholder="Поиск по списку покупок..."
        class="w-full pl-10 pr-9 py-2.5 bg-white border border-slate-200 rounded-2xl text-sm placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 transition-all shadow-xs"
      />
      <button
        v-if="searchQuery"
        type="button"
        class="absolute right-3 p-1 text-slate-400 hover:text-slate-600 rounded-full"
        aria-label="Очистить поиск"
        @click="searchQuery = ''"
      >
        <X class="w-4 h-4" />
      </button>
    </div>

    <!-- Active To-Buy Items List -->
    <div v-if="activeItems.length > 0" class="flex flex-col">
      <span class="text-xs font-bold text-slate-500 uppercase tracking-wider mb-2 px-1">
        Нужно купить ({{ activeItems.length }})
      </span>
      <ShoppingItemCard
        v-for="item in activeItems"
        :key="item.id || item.serverId || item.name"
        :item="item"
        @toggle="onToggle"
        @delete="onDelete"
        @transfer="onSingleTransfer"
      />
    </div>

    <!-- Bought Items List (Collapsible) -->
    <div v-if="boughtItems.length > 0" class="flex flex-col pt-1">
      <button
        type="button"
        class="flex items-center justify-between py-2 px-1 text-xs font-bold text-slate-500 uppercase tracking-wider hover:text-slate-700 transition-colors"
        @click="isBoughtExpanded = !isBoughtExpanded"
      >
        <span class="flex items-center gap-1.5 text-emerald-800">
          <CheckCheck class="w-4 h-4" />
          Куплено ({{ boughtItems.length }})
        </span>
        <ChevronDown
          class="w-4 h-4 transition-transform duration-200"
          :class="{ 'rotate-180': isBoughtExpanded }"
        />
      </button>

      <div v-if="isBoughtExpanded" class="flex flex-col mt-1">
        <ShoppingItemCard
          v-for="item in boughtItems"
          :key="item.id || item.serverId || item.name"
          :item="item"
          @toggle="onToggle"
          @delete="onDelete"
          @transfer="onSingleTransfer"
        />
      </div>
    </div>

    <!-- Empty State -->
    <div
      v-if="activeItems.length === 0 && boughtItems.length === 0"
      class="flex flex-col items-center justify-center py-16 px-4 text-center"
    >
      <div class="w-16 h-16 rounded-3xl bg-emerald-50 text-emerald-800 border border-emerald-100 shadow-xs flex items-center justify-center mb-4">
        <ShoppingCart class="w-8 h-8 stroke-[1.8px]" />
      </div>
      <h3 class="text-base font-bold text-slate-900 mb-1">Список покупок пуст</h3>
      <p class="text-xs text-slate-500 max-w-xs mb-5">
        Добавляйте продукты вручную или отправляйте недостающие ингредиенты из рецептов в один тап.
      </p>
      <button
        type="button"
        class="py-2.5 px-5 rounded-2xl bg-emerald-950 text-white text-sm font-semibold flex items-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/15"
        @click="showAddSheet = true"
      >
        <Plus class="w-4 h-4 stroke-[2.5px]" />
        <span>Добавить товар</span>
      </button>
    </div>

    <!-- Floating Action Button -->
    <div class="fixed bottom-20 inset-x-0 max-w-lg mx-auto flex justify-center pointer-events-none z-30 px-4">
      <button
        type="button"
        class="pointer-events-auto py-3 px-6 rounded-full bg-emerald-950 text-white text-sm font-bold flex items-center gap-2 shadow-elevated hover:bg-emerald-900 active:scale-95 transition-all"
        @click="showAddSheet = true"
      >
        <Plus class="w-4 h-4 stroke-[3px]" />
        <span>Добавить товар</span>
      </button>
    </div>

    <!-- Add Item Bottom Sheet -->
    <AddShoppingItemSheet v-model:show="showAddSheet" @add="onAddItem" />

    <!-- Transfer to Fridge Bottom Sheet -->
    <AddProductSheet
      v-model:show="showTransferSheet"
      :title="transferSheetTitle"
      submit-text="Перенести в холодильник"
      :initial-item="transferInitialData"
      :hide-add-more="true"
      :keep-open-on-submit="currentTransferIndex < transferQueue.length - 1"
      @add="onConfirmTransferItem"
    />
  </div>
</template>
