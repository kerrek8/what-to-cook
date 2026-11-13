<script setup lang="ts">
import { ref, onMounted } from 'vue'
import { showToast } from 'vant'
import { useInventoryStore, type AddItemData } from '@/stores/inventory'
import ProductCard from '@/components/inventory/ProductCard.vue'
import AddProductSheet from '@/components/inventory/AddProductSheet.vue'


const inventoryStore = useInventoryStore()

const showAddSheet = ref(false)
const editingItem = ref<import('@/db/types').LocalInventoryItem | null>(null)

async function onAddItem(data: AddItemData) {
  try {
    await inventoryStore.addItem(data)
    showToast({ type: 'success', message: `${data.name} добавлен` })
  } catch {
    showToast({ type: 'fail', message: 'Ошибка при добавлении' })
  }
}
async function onUpdateItem(payload: { id: number; changes: Partial<import('@/db/types').LocalInventoryItem> }) {
  await inventoryStore.updateItem(payload.id, payload.changes)
  editingItem.value = null
  showAddSheet.value = false
  showToast('Продукт обновлен')
}

async function onDeleteItem(id: number) {
  try {
    await inventoryStore.deleteItem(id)
    showToast('Продукт удален')
  } catch {
    showToast({ type: 'fail', message: 'Ошибка при удалении' })
  }
}

onMounted(() => {
  inventoryStore.loadInventory()
})
</script>

<template>
  <div class="fridge-view">
      <div class="fridge-content">
        <!-- Search Bar -->
        <div class="search-section">
          <van-search
            v-model="inventoryStore.searchQuery"
            placeholder="Поиск продуктов в холодильнике..."
            shape="round"
            clearable
          />
        </div>

        <!-- Filter Chips / Tabs -->
        <div class="filter-scroll">
          <button
            type="button"
            class="filter-chip"
            :class="{ active: inventoryStore.activeCategory === 'all' }"
            @click="inventoryStore.activeCategory = 'all'"
          >
            Все ({{ inventoryStore.items.length }})
          </button>

          <button
            type="button"
            class="filter-chip expiring-chip"
            :class="{ active: inventoryStore.activeCategory === 'expiring' }"
            @click="inventoryStore.activeCategory = 'expiring'"
          >
            <span>Истекают</span>
            <span v-if="inventoryStore.expiringCount > 0" class="expiring-badge">
              {{ inventoryStore.expiringCount }}
            </span>
          </button>

          <button
            v-for="cat in inventoryStore.categories"
            :key="cat"
            type="button"
            class="filter-chip"
            :class="{ active: inventoryStore.activeCategory === cat }"
            @click="inventoryStore.activeCategory = cat"
          >
            {{ cat }}
          </button>
        </div>

        <!-- Product List -->
        <div v-if="inventoryStore.filteredItems.length > 0" class="items-list">
          <ProductCard
            v-for="item in inventoryStore.filteredItems"
            :key="item.id || item.serverId || item.name"
            :item="item"
            @delete="onDeleteItem"
            @edit="(item) => { editingItem = item; showAddSheet = true }"
          />
        </div>

        <!-- Empty State -->
        <div v-else class="empty-section">
          <van-empty
            image="search"
            description="В холодильнике пока пусто. Добавьте первые продукты!"
          >
            <van-button
              round
              type="primary"
              color="#064E3B"
              class="add-first-btn"
              @click="showAddSheet = true"
            >
              Добавить продукт
            </van-button>
          </van-empty>
        </div>
      </div>

    <!-- Floating Action Button -->
    <div class="fab-wrapper safe-area-bottom">
      <van-button
        round
        type="primary"
        icon="plus"
        color="#064E3B"
        class="fab-btn"
        @click="showAddSheet = true"
      >
        Добавить продукт
      </van-button>
    </div>

    <!-- Add Product Sheet -->
    <AddProductSheet v-model:show="showAddSheet" :edit-item="editingItem" @add="onAddItem" @update="onUpdateItem" />
  </div>
</template>

<style scoped>
.fridge-view {
  min-height: 100%;
  position: relative;
  display: flex;
  flex-direction: column;
}

.fridge-content {
  padding-bottom: 80px;
}

.search-section {
  padding: 4px 8px;
}

.filter-scroll {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 4px 12px 10px;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
}

.filter-scroll::-webkit-scrollbar {
  display: none;
}

.filter-chip {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  gap: 6px;
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
  background-color: #064E3B;
  border-color: #064E3B;
  color: #ffffff;
  font-weight: 600;
}

.expiring-chip.active {
  background-color: #f44336;
  border-color: #f44336;
}

.expiring-badge {
  background-color: #f44336;
  color: #ffffff;
  font-size: 11px;
  font-weight: 700;
  padding: 1px 6px;
  border-radius: 10px;
}

.filter-chip.active .expiring-badge {
  background-color: #ffffff;
  color: #f44336;
}

.items-list {
  padding: 4px 12px;
}

.empty-section {
  padding: 32px 16px;
}

.add-first-btn {
  min-width: 180px;
  min-height: 44px;
  font-weight: 600;
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
  box-shadow: 0 4px 14px rgba(15, 23, 42, 0.25);
  padding: 0 24px;
  min-height: 44px;
  font-weight: 600;
  font-size: 15px;
}
</style>
