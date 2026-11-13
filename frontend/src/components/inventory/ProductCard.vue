<script setup lang="ts">
import { ref, computed } from 'vue'
import type { SwipeCellInstance } from 'vant'
import { triggerHaptic } from '@/utils/haptics'
import type { LocalInventoryItem } from '@/db/types'
import { getFreshnessInfo, formatQuantity } from '@/utils/freshness'

const props = defineProps<{
  item: LocalInventoryItem
}>()

const emit = defineEmits<{
  (e: 'delete', id: number): void
  (e: 'edit', item: LocalInventoryItem): void
}>()

const swipeCellRef = ref<SwipeCellInstance | null>(null)
const isOpen = ref(false)

const freshness = computed(() => getFreshnessInfo(props.item.expirationDate))
const formattedQuantity = computed(() =>
  formatQuantity(props.item.amount, props.item.unit, props.item.approximateQuantity)
)

function onCardClick() {
  if (!isOpen.value) {
    swipeCellRef.value?.open('right')
    isOpen.value = true
    triggerHaptic('light')
  } else {
    swipeCellRef.value?.close('cell')
    isOpen.value = false
  }
}

function handleDelete() {
  if (props.item.id) {
    emit('delete', props.item.id)
  }
}
</script>

<template>
  <van-swipe-cell
    ref="swipeCellRef"
    class="product-cell"
    :right-width="154"
    @open="isOpen = true"
    @close="isOpen = false"
  >
    <div class="product-card" @click.stop="onCardClick">
      <div class="card-main">
        <div class="product-info">
          <span class="product-name">{{ item.name }}</span>
          <span class="product-cat">{{ item.category }}</span>
        </div>
        <div class="product-qty-wrapper">
          <span class="product-qty">{{ formattedQuantity }}</span>
          <span class="swipe-hint" :class="{ 'is-open': isOpen }" aria-hidden="true" title="Смахните влево">
            <van-icon name="arrow-left" />
          </span>
        </div>
      </div>

      <div class="card-footer">
        <div class="freshness-badge" :style="{ backgroundColor: freshness.color + '18', color: freshness.color }">
          <span class="dot" :style="{ backgroundColor: freshness.color }"></span>
          <span>{{ freshness.label }}</span>
        </div>

        <div v-if="item.synced === 0" class="sync-badge" title="Сохранено локально">
          <van-icon name="clock-o" />
        </div>
      </div>
    </div>

    <template #right>
      <van-button square type="primary" text="Изменить" icon="edit" class="edit-button" @click="emit('edit', item)" />
      <van-button
        square
        type="danger"
        text="Удалить"
        icon="delete-o"
        class="delete-button"
        @click="handleDelete"
      />
    </template>
  </van-swipe-cell>
</template>

<style scoped>
.product-cell {
  margin-bottom: 8px;
  border-radius: 18px;
  box-shadow: 0 4px 16px -2px rgba(15, 23, 42, 0.05);
  overflow: hidden;
}

.product-card {
  background-color: var(--van-background-2);
  padding: 12px 14px;
  display: flex;
  flex-direction: column;
  gap: 8px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.03);
  cursor: pointer;
  user-select: none;
}

.card-main {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.product-info {
  display: flex;
  flex-direction: column;
  gap: 2px;
}

.product-name {
  font-size: 15px;
  font-weight: 600;
  color: #1a1a1a;
}

.product-cat {
  font-size: 12px;
  color: #8c8c8c;
}

.product-qty-wrapper {
  display: flex;
  align-items: center;
  gap: 6px;
}

.product-qty {
  font-size: 14px;
  font-weight: 600;
  color: #064E3B;
  background-color: rgba(15, 23, 42, 0.08);
  padding: 4px 10px;
  border-radius: 12px;
}

.swipe-hint {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  color: #94A3B8;
  font-size: 13px;
  transition: transform 0.25s ease, opacity 0.2s ease, color 0.2s ease;
}

.swipe-hint.is-open {
  transform: rotate(180deg);
  color: #064E3B;
}

.card-footer {
  display: flex;
  justify-content: space-between;
  align-items: center;
}

.freshness-badge {
  display: inline-flex;
  align-items: center;
  gap: 5px;
  padding: 2px 8px;
  border-radius: 6px;
  font-size: 11px;
  font-weight: 600;
}

.dot {
  width: 6px;
  height: 6px;
  border-radius: 50%;
}

.sync-badge {
  color: #faad14;
  font-size: 13px;
  display: flex;
  align-items: center;
}

.delete-button {
  height: 100%;
  min-width: 72px;
}
.edit-button { height: 100%; min-width: 82px; }
</style>
