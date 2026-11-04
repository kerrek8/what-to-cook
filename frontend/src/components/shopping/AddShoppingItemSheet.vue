<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { showToast } from 'vant'
import { getIngredientsApi } from '@/api/ingredients'
import type { Ingredient } from '@/types/api'
import type { AddShoppingItemPayload } from '@/stores/shopping'


const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits<{
  (e: 'update:show', val: boolean): void
  (e: 'add', item: AddShoppingItemPayload): void
}>()

const visible = computed({
  get: () => props.show,
  set: (val) => emit('update:show', val)
})

const itemName = ref('')
const selectedCategory = ref('Другое')
const selectedIngredientId = ref<number | null>(null)
const amount = ref<number | undefined>(undefined)
const unit = ref<string>('шт')

const catalog = ref<Ingredient[]>([])
const isSearching = ref(false)

const categories = [
  'Овощи',
  'Молочные продукты',
  'Мясо',
  'Бакалея',
  'Фрукты',
  'Напитки',
  'Другое'
]

const units = ['шт', 'кг', 'г', 'л', 'уп']

const suggestions = computed(() => {
  const q = itemName.value.trim().toLowerCase()
  if (!q) return []
  return catalog.value
    .filter((item) => item.name.toLowerCase().includes(q) || (item.nameEn ?? '').toLowerCase().includes(q))
    .slice(0, 5)
})

async function loadCatalog() {
  if (catalog.value.length > 0) return
  isSearching.value = true
  try {
    const list = await getIngredientsApi()
    catalog.value = list
  } catch {
    catalog.value = []
  } finally {
    isSearching.value = false
  }
}

function selectSuggestion(item: Ingredient) {
  itemName.value = item.name
  selectedCategory.value = item.category || 'Другое'
  selectedIngredientId.value = item.id
  if (item.defaultUnit && units.includes(item.defaultUnit)) {
    unit.value = item.defaultUnit
  }
}

function resetForm() {
  itemName.value = ''
  selectedCategory.value = 'Другое'
  selectedIngredientId.value = null
  amount.value = undefined
  unit.value = 'шт'
}

function handleSubmit() {
  const name = itemName.value.trim()
  if (!name) {
    showToast('Укажите название продукта')
    return
  }

  emit('add', {
    ingredientId: selectedIngredientId.value,
    name,
    category: selectedCategory.value,
    amount: amount.value ?? null,
    unit: amount.value ? unit.value : null
  })

  resetForm()
  visible.value = false
}

watch(
  () => props.show,
  (val) => {
    if (val) loadCatalog()
  }
)
</script>

<template>
  <van-popup
    v-model:show="visible"
    round
    position="bottom"
    :style="{ maxHeight: '85%' }"
    closeable
    class="add-sheet"
  >
    <div class="sheet-content safe-area-bottom">
      <h3 class="sheet-title">Добавить в список покупок</h3>

      <!-- 1. Название продукта с автокомплитом -->
      <div class="field-block">
        <label class="field-label">Что купить?</label>
        <van-field
          v-model="itemName"
          placeholder="Например: Сыр, Молоко, Помидоры"
          clearable
          autocomplete="off"
          class="custom-field"
        />

        <div v-if="suggestions.length > 0" class="suggestions-list">
          <div
            v-for="s in suggestions"
            :key="s.id"
            class="suggestion-item"
            @click="selectSuggestion(s)"
          >
            <span class="suggestion-name">{{ s.name }}</span>
            <span class="suggestion-category">{{ s.category }}</span>
          </div>
        </div>
      </div>

      <!-- 2. Количество и единица -->
      <div class="field-block">
        <label class="field-label">Количество (необязательно)</label>
        <div class="quantity-row">
          <van-field
            v-model.number="amount"
            type="number"
            placeholder="Сколько?"
            class="amount-field"
          />
          <div class="unit-chips">
            <span
              v-for="u in units"
              :key="u"
              class="unit-chip"
              :class="{ active: unit === u }"
              @click="unit = u"
            >
              {{ u }}
            </span>
          </div>
        </div>
      </div>

      <!-- 3. Отдел / Категория -->
      <div class="field-block">
        <label class="field-label">Отдел магазина</label>
        <div class="category-chips">
          <span
            v-for="cat in categories"
            :key="cat"
            class="category-chip"
            :class="{ active: selectedCategory === cat }"
            @click="selectedCategory = cat"
          >
            {{ cat }}
          </span>
        </div>
      </div>

      <!-- Кнопка добавления -->
      <div class="submit-wrapper">
        <van-button
          round
          block
          type="primary"
          color="#2e7d32"
          class="submit-btn"
          @click="handleSubmit"
        >
          Добавить в список
        </van-button>
      </div>
    </div>
  </van-popup>
</template>

<style scoped>
.add-sheet {
  border-top-left-radius: 20px;
  border-top-right-radius: 20px;
}

.sheet-content {
  padding: 20px 16px 28px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.sheet-title {
  margin: 0 0 4px;
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
}

.field-block {
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.field-label {
  font-size: 13px;
  font-weight: 600;
  color: #4a4a4a;
}

.custom-field {
  background-color: #f7f8fa;
  border-radius: 10px;
  padding: 10px 12px;
}

.suggestions-list {
  background-color: #ffffff;
  border: 1px solid #e0e0e0;
  border-radius: 8px;
  margin-top: 4px;
  overflow: hidden;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
}

.suggestion-item {
  display: flex;
  align-items: center;
  justify-content: space-between;
  padding: 10px 14px;
  cursor: pointer;
  border-bottom: 1px solid #f5f5f5;
  min-height: 44px;
}

.suggestion-item:last-child {
  border-bottom: none;
}

.suggestion-item:active {
  background-color: #f1f8e9;
}

.suggestion-name {
  font-weight: 500;
  font-size: 14px;
  color: #212121;
}

.suggestion-category {
  font-size: 12px;
  color: #757575;
}

.quantity-row {
  display: flex;
  gap: 10px;
  align-items: center;
}

.amount-field {
  flex: 1;
  background-color: #f7f8fa;
  border-radius: 10px;
  padding: 10px 12px;
}

.unit-chips {
  display: flex;
  gap: 4px;
}

.unit-chip {
  padding: 8px 10px;
  min-width: 36px;
  min-height: 38px;
  display: inline-flex;
  align-items: center;
  justify-content: center;
  border-radius: 8px;
  background-color: #f0f0f0;
  font-size: 12px;
  font-weight: 600;
  color: #424242;
  cursor: pointer;
  transition: all 0.15s ease;
}

.unit-chip.active {
  background-color: #2e7d32;
  color: #ffffff;
}

.category-chips {
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
}

.category-chip {
  padding: 6px 12px;
  min-height: 36px;
  display: inline-flex;
  align-items: center;
  border-radius: 18px;
  background-color: #f0f0f0;
  font-size: 13px;
  color: #424242;
  cursor: pointer;
  transition: all 0.15s ease;
}

.category-chip.active {
  background-color: #2e7d32;
  color: #ffffff;
  font-weight: 600;
}

.submit-wrapper {
  margin-top: 8px;
}

.submit-btn {
  min-height: 48px;
  font-size: 16px;
  font-weight: 700;
}
</style>
