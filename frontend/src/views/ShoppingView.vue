<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { showToast, showConfirmDialog } from 'vant'
import { useShoppingStore, type AddShoppingItemPayload } from '@/stores/shopping'
import { useInventoryStore, type AddItemData } from '@/stores/inventory'
import type { LocalShoppingItem } from '@/db/types'
import ShoppingItemCard from '@/components/shopping/ShoppingItemCard.vue'
import AddShoppingItemSheet from '@/components/shopping/AddShoppingItemSheet.vue'
import AddProductSheet from '@/components/inventory/AddProductSheet.vue'

const shoppingStore = useShoppingStore()
const inventoryStore = useInventoryStore()

const showAddSheet = ref(false)
const showTransferSheet = ref(false)
const isBoughtExpanded = ref(false)
const transferQueue = ref<LocalShoppingItem[]>([])
const currentTransferIndex = ref(0)

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

onMounted(() => {
  shoppingStore.loadShoppingList()
})

async function onAddItem(payload: AddShoppingItemPayload) {
  try {
    await shoppingStore.addItem(payload)
    showToast({ type: 'success', message: `${payload.name} добавлен` })
  } catch {
    showToast({ type: 'fail', message: 'Ошибка при добавлении' })
  }
}

async function onToggle(id: number) {
  await shoppingStore.toggleBought(id)
}

async function onDelete(id: number) {
  try {
    await shoppingStore.deleteItem(id)
    showToast('Продукт удален')
  } catch {
    showToast({ type: 'fail', message: 'Ошибка при удалении' })
  }
}

function onSingleTransfer(item: LocalShoppingItem) {
  transferQueue.value = [item]
  currentTransferIndex.value = 0
  showTransferSheet.value = true
}

async function onQuickTransfer() {
  if (shoppingStore.boughtCount === 0) return
  try {
    await showConfirmDialog({
      title: "Перенос в холодильник",
      message: `Перенести все купленные товары (${shoppingStore.boughtCount} шт.) в холодильник?`
    })
    const count = await shoppingStore.transferBoughtToInventory()
    showToast({
      type: "success",
      message: `Перенесено в холодильник: ${count}`
    })
  } catch {
    // cancelled
  }
}

function onTransferToInventory() {
  const bought = shoppingStore.items.filter((i) => i.isBought)
  if (bought.length === 0) return

  transferQueue.value = [...bought]
  currentTransferIndex.value = 0
  showTransferSheet.value = true
}

async function onConfirmTransferItem(payload: AddItemData) {
  const currentItem = currentTransferItem.value
  if (!currentItem) return

  try {
    await inventoryStore.addItem(payload)

    if (currentItem.id != null) {
      await shoppingStore.deleteItem(currentItem.id)
    }

    if (currentTransferIndex.value + 1 < transferQueue.value.length) {
      currentTransferIndex.value++
      showToast({
        type: 'success',
        message: `${payload.name} перенесен (${currentTransferIndex.value}/${transferQueue.value.length})`
      })
    } else {
      showTransferSheet.value = false
      transferQueue.value = []
      currentTransferIndex.value = 0
      showToast({ type: 'success', message: 'Продукты успешно перенесены в холодильник!' })
    }
  } catch {
    showToast({ type: 'fail', message: 'Ошибка при переносе' })
  }
}
</script>

<template>
  <div class="shopping-view">
    <!-- Search Bar -->
    <div class="search-header">
      <van-search
        v-model="shoppingStore.searchQuery"
        placeholder="Поиск по списку покупок..."
        shape="round"
        clearable
      />
    </div>

    <!-- Summary & Transfer Bar -->
    <div v-if="shoppingStore.totalCount > 0" class="summary-bar">
      <div class="summary-stat">
        <span class="stat-badge">
          Куплено {{ shoppingStore.boughtCount }} из {{ shoppingStore.totalCount }}
        </span>
      </div>

      <van-button
        v-if="shoppingStore.boughtCount > 0"
        round
        size="small"
        type="primary"
        color="#2e7d32"
        icon="passed"
        :loading="shoppingStore.isTransferring"
        class="transfer-btn"
        @click="onQuickTransfer"
      >
        В холодильник ({{ shoppingStore.boughtCount }})
      </van-button>
    </div>

    <!-- Category Filter Chips -->
    <div v-if="shoppingStore.categories.length > 1" class="categories-scroll">
      <button
        type="button"
        class="filter-chip"
        :class="{ active: shoppingStore.activeCategory === 'all' }"
        @click="shoppingStore.activeCategory = 'all'"
      >
        Все ({{ shoppingStore.totalCount }})
      </button>

      <button
        v-for="cat in shoppingStore.categories"
        :key="cat"
        type="button"
        class="filter-chip"
        :class="{ active: shoppingStore.activeCategory === cat }"
        @click="shoppingStore.activeCategory = cat"
      >
        {{ cat }}
      </button>
    </div>

    <!-- Pull to Refresh List -->
    <div class="shopping-content">
      <!-- Grouped Departments -->
      <div v-if="shoppingStore.groupedCategories.length > 0" class="groups-container">
        <template v-for="group in shoppingStore.groupedCategories" :key="group.category">
          <div
            v-if="group.items.filter((i) => !i.isBought).length > 0"
            class="department-card"
          >
            <div class="department-header">
              <span class="department-title">{{ group.category }}</span>
              <span class="department-progress">
                {{ group.boughtCount }}/{{ group.items.length }}
              </span>
            </div>

            <div class="department-items">
              <ShoppingItemCard
                v-for="item in group.items.filter((i) => !i.isBought)"
                :key="item.id || item.serverId || item.name"
                :item="item"
                @toggle="onToggle"
                @delete="onDelete"
                @transfer="onSingleTransfer"
              />
            </div>
          </div>
        </template>

        <div v-if="shoppingStore.boughtCount > 0" class="bought-section mt-4 mb-20 px-4">
          <button
            type="button"
            class="w-full flex items-center justify-between p-3 rounded-squircle-sm bg-white/70 border border-culinary-border text-culinary-textMuted font-medium text-sm transition-all"
            @click="isBoughtExpanded = !isBoughtExpanded"
          >
            <span class="flex items-center gap-2">
              <van-icon :name="isBoughtExpanded ? 'arrow-down' : 'arrow'" />
              Куплено ({{ shoppingStore.boughtCount }})
            </span>
            <span class="text-xs text-emerald-700 font-semibold">{{ isBoughtExpanded ? 'Скрыть' : 'Показать' }}</span>
          </button>
          <div v-if="isBoughtExpanded" class="bought-items-list mt-2 space-y-1">
            <ShoppingItemCard
              v-for="item in shoppingStore.items.filter((i) => i.isBought)"
              :key="item.id || item.name"
              :item="item"
              @toggle="onToggle"
              @delete="onDelete"
              @transfer="onSingleTransfer"
            />
          </div>
        </div>
      </div>

      <!-- Empty State -->
      <div v-else class="empty-state">
        <van-empty
          image="default"
          description="Список покупок пуст. Добавляйте недостающие продукты из рецептов или вручную!"
        >
          <van-button
            round
            type="primary"
            color="#2e7d32"
            class="add-first-btn"
            @click="showAddSheet = true"
          >
            Добавить продукт
          </van-button>
        </van-empty>
      </div>
    </div>

    <!-- Floating Action Button (FAB) -->
    <div class="fab-wrapper safe-area-bottom">
      <van-button
        round
        type="primary"
        icon="plus"
        color="#2e7d32"
        class="fab-btn"
        @click="showAddSheet = true"
      >
        Добавить в список
      </van-button>
    </div>

    <!-- Add Item Bottom Sheet -->
    <AddShoppingItemSheet v-model:show="showAddSheet" @add="onAddItem" />

    <!-- Sheet for transferring bought item to inventory with expiration date & amount -->
    <AddProductSheet
      v-model:show="showTransferSheet"
      :initial-item="transferInitialData"
      :title="transferSheetTitle"
      submit-text="Перенести в холодильник"
      :hide-add-more="true"
      @add="onConfirmTransferItem"
    />
  </div>
</template>

<style scoped>
.shopping-view {
  min-height: 100%;
  position: relative;
  display: flex;
  flex-direction: column;
}

.search-header {
  padding: 4px 8px 0;
}

.summary-bar {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 8px 14px;
  background-color: #ffffff;
  border-bottom: 1px solid #f0f0f0;
}

.stat-badge {
  font-size: 13px;
  font-weight: 600;
  color: #424242;
}

.transfer-btn {
  font-weight: 700;
  box-shadow: 0 2px 6px rgba(46, 125, 50, 0.3);
  min-height: 36px;
}

.categories-scroll {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 8px 12px;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
}

.categories-scroll::-webkit-scrollbar {
  display: none;
}

.filter-chip {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  padding: 6px 14px;
  min-height: 36px;
  border-radius: 18px;
  border: 1px solid #e0e0e0;
  background-color: #ffffff;
  font-size: 13px;
  font-weight: 500;
  color: #4a4a4a;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-chip.active {
  background-color: #2e7d32;
  border-color: #2e7d32;
  color: #ffffff;
  font-weight: 600;
}

.shopping-content {
  flex: 1;
  padding-bottom: 84px;
}

.groups-container {
  padding: 8px 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.department-card {
  background-color: #ffffff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.department-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  background-color: #f9fbe7;
  border-bottom: 1px solid #e8f5e9;
}

.department-title {
  font-size: 14px;
  font-weight: 700;
  color: #2e7d32;
}

.department-progress {
  font-size: 12px;
  font-weight: 600;
  color: #689f38;
}

.department-items {
  display: flex;
  flex-direction: column;
}

.empty-state {
  padding: 32px 16px;
}

.add-first-btn {
  min-width: 180px;
  min-height: 44px;
  font-weight: 600;
  margin-top: 8px;
}

.fab-wrapper {
  position: fixed;
  bottom: calc(64px + env(safe-area-inset-bottom, 0));
  left: 50%;
  transform: translateX(-50%);
  width: 100%;
  max-width: var(--app-max-width);
  display: flex;
  justify-content: center;
  pointer-events: none;
  z-index: 90;
}

.fab-btn {
  pointer-events: auto;
  box-shadow: 0 4px 14px rgba(46, 125, 50, 0.4);
  padding: 0 24px;
  min-height: 44px;
  font-weight: 600;
  font-size: 15px;
}
</style>
