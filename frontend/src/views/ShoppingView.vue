<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { showToast, showDialog } from 'vant'
import { useShoppingStore, type AddShoppingItemPayload } from '@/stores/shopping'
import ShoppingItemCard from '@/components/shopping/ShoppingItemCard.vue'
import { displayText } from '@/i18n/translation'
import AddShoppingItemSheet from '@/components/shopping/AddShoppingItemSheet.vue'

const shoppingStore = useShoppingStore()

const showAddSheet = ref(false)

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

async function onTransferToInventory() {
  if (shoppingStore.boughtCount === 0) return

  showDialog({
    title: 'Перенести в холодильник?',
    message: `Перенести ${shoppingStore.boughtCount} купленных товаров в холодильник? Они будут удалены из списка покупок.`,
    showCancelButton: true,
    confirmButtonText: 'Перенести',
    cancelButtonText: 'Отмена',
    confirmButtonColor: '#2e7d32'
  })
    .then(async () => {
      try {
        const count = await shoppingStore.transferBoughtToInventory()
        showToast({
          type: 'success',
          message: `Перенесено ${count} прод. в холодильник!`
        })
      } catch {
        showToast({ type: 'fail', message: 'Ошибка при переносе' })
      }
    })
    .catch(() => {
      // Cancelled
    })
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
        @click="onTransferToInventory"
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
        {{ displayText(cat) }}
      </button>
    </div>

    <!-- Pull to Refresh List -->
    <div class="shopping-content">
      <!-- Grouped Departments -->
      <div v-if="shoppingStore.groupedCategories.length > 0" class="groups-container">
        <div
          v-for="group in shoppingStore.groupedCategories"
          :key="group.category"
          class="department-card"
        >
          <div class="department-header">
            <span class="department-title">{{ displayText(group.category) }}</span>
            <span class="department-progress">
              {{ group.boughtCount }}/{{ group.items.length }}
            </span>
          </div>

          <div class="department-items">
            <ShoppingItemCard
              v-for="item in group.items"
              :key="item.id || item.serverId || item.name"
              :item="item"
              @toggle="onToggle"
              @delete="onDelete"
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
