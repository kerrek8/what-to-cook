<script setup lang="ts">
import { computed } from 'vue'
import type { LocalShoppingItem } from '@/db/types'
import { displayText, displayUnit } from '@/i18n/translation'

const props = defineProps<{
  item: LocalShoppingItem
}>()

const emit = defineEmits<{
  (e: 'toggle', id: number): void
  (e: 'delete', id: number): void
}>()

const formattedQuantity = computed(() => {
  if (props.item.amount != null && props.item.amount > 0) {
    return `${props.item.amount} ${displayUnit(props.item.unit)}`.trim()
  }
  return null
})

function onToggle() {
  if (props.item.id != null) {
    emit('toggle', props.item.id)
  }
}

function onDelete() {
  if (props.item.id != null) {
    emit('delete', props.item.id)
  }
}
</script>

<template>
  <van-swipe-cell class="shopping-item-cell">
    <div
      class="item-row"
      :class="{ bought: item.isBought }"
      @click="onToggle"
    >
      <div class="checkbox-wrapper" @click.stop="onToggle">
        <div class="custom-checkbox" :class="{ checked: item.isBought }">
          <van-icon v-if="item.isBought" name="success" size="14" color="#ffffff" />
        </div>
      </div>

      <div class="item-info">
        <span class="item-name">{{ displayText(item.name) }}</span>
      </div>

      <div v-if="formattedQuantity" class="item-quantity">
        <span class="quantity-pill">{{ formattedQuantity }}</span>
      </div>
    </div>

    <template #right>
      <van-button
        square
        type="danger"
        text="Удалить"
        icon="delete-o"
        class="delete-btn"
        @click="onDelete"
      />
    </template>
  </van-swipe-cell>
</template>

<style scoped>
.shopping-item-cell {
  background-color: #ffffff;
  border-bottom: 1px solid #f0f0f0;
}

.item-row {
  display: flex;
  align-items: center;
  padding: 12px 14px;
  min-height: 52px;
  cursor: pointer;
  user-select: none;
  transition: background-color 0.15s ease;
}

.item-row:active {
  background-color: #f9f9f9;
}

.checkbox-wrapper {
  padding: 4px 10px 4px 0;
  display: flex;
  align-items: center;
  justify-content: center;
  min-width: 44px;
  min-height: 44px;
}

.custom-checkbox {
  width: 22px;
  height: 22px;
  border-radius: 6px;
  border: 2px solid #b0bec5;
  background-color: #ffffff;
  display: flex;
  align-items: center;
  justify-content: center;
  transition: all 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.custom-checkbox.checked {
  background-color: #2e7d32;
  border-color: #2e7d32;
  transform: scale(1.05);
}

.item-info {
  flex: 1;
  display: flex;
  flex-direction: column;
  padding-right: 8px;
}

.item-name {
  font-size: 15px;
  font-weight: 500;
  color: #212121;
  line-height: 1.3;
  transition: color 0.2s ease, text-decoration 0.2s ease;
}

.item-row.bought .item-name {
  text-decoration: line-through;
  color: #9e9e9e;
}

.item-quantity {
  margin-left: auto;
}

.quantity-pill {
  font-size: 12px;
  font-weight: 600;
  background-color: #f1f8e9;
  color: #2e7d32;
  padding: 3px 8px;
  border-radius: 12px;
  white-space: nowrap;
}

.item-row.bought .quantity-pill {
  background-color: #eeeeee;
  color: #9e9e9e;
}

.delete-btn {
  height: 100%;
  min-width: 72px;
  font-weight: 600;
}
</style>
