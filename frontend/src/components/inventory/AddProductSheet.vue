<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { showToast } from 'vant'
import { getIngredientsApi } from '@/api/ingredients'
import type { Ingredient } from '@/types/api'
import type { AddItemData } from '@/stores/inventory'
import type { LocalInventoryItem } from '@/db/types'

const props = withDefaults(
  defineProps<{
    show: boolean
    editItem?: LocalInventoryItem | null
    initialItem?: {
      id?: number
      name: string
      category?: string
      amount?: number | null
      unit?: string | null
      approximateQuantity?: 'few' | 'medium' | 'much' | null
      expirationDate?: string | null
      ingredientId?: number | null
    } | null
    title?: string
    submitText?: string
    hideAddMore?: boolean
  }>(),
  {
    editItem: null,
    initialItem: null,
    title: '',
    submitText: '',
    hideAddMore: false
  }
)

const emit = defineEmits<{
  (e: 'update:show', value: boolean): void
  (e: 'add', item: AddItemData): void
  (e: 'update', item: { id: number; changes: Partial<LocalInventoryItem> }): void
}>()

const visible = computed({
  get: () => props.show,
  set: (val) => emit('update:show', val)
})

const productName = ref('')
const selectedCategory = ref('Другое')
const selectedIngredientId = ref<number | null>(null)

const quantityMode = ref<'exact' | 'approx'>('exact')
const amount = ref<number | undefined>(undefined)
const unit = ref<string>('г')
const approximateQuantity = ref<'few' | 'medium' | 'much'>('medium')

const expirationDate = ref<string>('')
const showCalendar = ref(false)

const catalog = ref<Ingredient[]>([])
const isSearching = ref(false)

const suggestions = computed(() => {
  const q = productName.value.trim().toLowerCase()
  if (!q) return []
  return catalog.value
    .filter((item) => item.name.toLowerCase().includes(q))
    .slice(0, 5)
})

const units = ['г', 'кг', 'мл', 'л', 'шт', 'уп']

async function loadCatalog() {
  if (catalog.value.length > 0) return
  isSearching.value = true
  try {
    catalog.value = await getIngredientsApi()
  } catch {
    // Local fallback
    catalog.value = [
      { id: 1, name: 'Молоко', category: 'Молочные продукты', defaultUnit: 'л', isPantryEssential: false },
      { id: 2, name: 'Яйца', category: 'Яйца', defaultUnit: 'шт', isPantryEssential: false },
      { id: 3, name: 'Куриное филе', category: 'Мясо и птица', defaultUnit: 'г', isPantryEssential: false },
      { id: 4, name: 'Картофель', category: 'Овощи', defaultUnit: 'кг', isPantryEssential: false },
      { id: 5, name: 'Сыр твердый', category: 'Молочные продукты', defaultUnit: 'г', isPantryEssential: false },
      { id: 6, name: 'Помидоры', category: 'Овощи', defaultUnit: 'шт', isPantryEssential: false }
    ]
  } finally {
    isSearching.value = false
  }
}

function selectSuggestion(item: Ingredient) {
  productName.value = item.name
  selectedCategory.value = item.category
  selectedIngredientId.value = item.id
  if (item.defaultUnit) {
    unit.value = item.defaultUnit
  }
}

function setDateOffset(days: number) {
  const d = new Date()
  d.setDate(d.getDate() + days)
  expirationDate.value = d.toISOString().split('T')[0]
}

function clearDate() {
  expirationDate.value = ''
}

function onDateConfirm({ selectedValues }: { selectedValues: string[] }) {
  expirationDate.value = selectedValues.join('-')
  showCalendar.value = false
}

function resetForm() {
  productName.value = ''
  selectedCategory.value = 'Другое'
  selectedIngredientId.value = null
  quantityMode.value = 'exact'
  amount.value = undefined
  unit.value = 'г'
  approximateQuantity.value = 'medium'
  expirationDate.value = ''
}

function handleSubmit(closeAfter = false) {
  const name = productName.value.trim()
  if (!name) {
    showToast('Укажите название продукта')
    return
  }

  const payload: AddItemData = {
    ingredientId: selectedIngredientId.value,
    name,
    category: selectedCategory.value,
    amount: quantityMode.value === 'exact' ? (amount.value ?? null) : null,
    unit: quantityMode.value === 'exact' ? unit.value : null,
    approximateQuantity: quantityMode.value === 'approx' ? approximateQuantity.value : null,
    expirationDate: expirationDate.value || null
  }

  if (props.editItem?.id != null) emit('update', { id: props.editItem.id, changes: { ...payload, name, updatedAt: new Date().toISOString() } })
  else emit('add', payload)
  showToast({ type: 'success', message: props.editItem ? `${name} обновлен` : `${name} добавлен` })
  resetForm()
  if (closeAfter) visible.value = false
}

watch(
  () => props.show,
  (val) => {
    if (val) loadCatalog()
  }
)

watch(
  () => props.initialItem,
  (item) => {
    if (!item) return
    productName.value = item.name || ''
    selectedCategory.value = item.category || 'Другое'
    selectedIngredientId.value = item.ingredientId ?? null
    amount.value = item.amount != null ? Number(item.amount) : undefined
    unit.value = item.unit || 'г'
    quantityMode.value = item.approximateQuantity ? 'approx' : 'exact'
    approximateQuantity.value = item.approximateQuantity ?? 'medium'
    expirationDate.value = item.expirationDate ?? ''
  },
  { immediate: true }
)

watch(() => props.editItem, (item) => {
  if (!item) return
  productName.value = item.name
  selectedCategory.value = item.category
  selectedIngredientId.value = item.ingredientId ?? null
  amount.value = item.amount ?? undefined
  unit.value = item.unit ?? 'г'
  quantityMode.value = item.approximateQuantity ? 'approx' : 'exact'
  approximateQuantity.value = item.approximateQuantity ?? 'medium'
  expirationDate.value = item.expirationDate ?? ''
}, { immediate: true })
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
      <h3 class="sheet-title">{{ title || (editItem ? 'Изменить продукт' : 'Добавить в холодильник') }}</h3>

      <!-- 1. Название продукта с автокомплитом -->
      <div class="field-block">
        <label class="field-label">Название продукта</label>
        <van-field
          v-model="productName"
          placeholder="Начните вводить (например, Курица, Молоко...)"
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
            <span class="suggestion-cat">{{ s.category }}</span>
          </div>
        </div>
      </div>

      <!-- 2. Количество: точный вес или «на глаз» -->
      <div class="field-block">
        <label class="field-label">Количество</label>
        <div class="mode-switch">
          <button
            type="button"
            class="mode-btn"
            :class="{ active: quantityMode === 'exact' }"
            @click="quantityMode = 'exact'"
          >
            Точный вес
          </button>
          <button
            type="button"
            class="mode-btn"
            :class="{ active: quantityMode === 'approx' }"
            @click="quantityMode = 'approx'"
          >
            На глаз
          </button>
        </div>

        <div v-if="quantityMode === 'exact'" class="exact-row">
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

        <div v-else class="approx-row">
          <button
            type="button"
            class="approx-chip"
            :class="{ active: approximateQuantity === 'few' }"
            @click="approximateQuantity = 'few'"
          >
            Мало
          </button>
          <button
            type="button"
            class="approx-chip"
            :class="{ active: approximateQuantity === 'medium' }"
            @click="approximateQuantity = 'medium'"
          >
            Средне
          </button>
          <button
            type="button"
            class="approx-chip"
            :class="{ active: approximateQuantity === 'much' }"
            @click="approximateQuantity = 'much'"
          >
            Много
          </button>
        </div>
      </div>

      <!-- 3. Срок годности с быстрыми пресетами -->
      <div class="field-block">
        <div class="label-row">
          <label class="field-label">Срок годности</label>
          <span v-if="expirationDate" class="selected-date">
            {{ expirationDate }}
          </span>
          <span v-else class="selected-date text-muted">Не указан</span>
        </div>

        <div class="date-presets">
          <button type="button" class="preset-btn" @click="setDateOffset(3)">+3 дня</button>
          <button type="button" class="preset-btn" @click="setDateOffset(7)">+7 дней</button>
          <button type="button" class="preset-btn" @click="setDateOffset(14)">+2 недели</button>
          <button type="button" class="preset-btn calendar-btn" @click="showCalendar = true">
            📅 Календарь
          </button>
          <button
            v-if="expirationDate"
            type="button"
            class="preset-btn clear-btn"
            @click="clearDate"
          >
            ✕ Сброс
          </button>
        </div>
      </div>

      <div class="action-footer">
        <van-button
          v-if="!editItem && !hideAddMore"
          round
          block
          plain
          type="primary"
          color="#1E3A2F"
          class="submit-button continue-button"
          @click="handleSubmit(false)"
        >
          Добавить ещё
        </van-button>
        <van-button
          round
          block
          type="primary"
          color="#1E3A2F"
          class="submit-button"
          @click="handleSubmit(true)"
        >
          {{ submitText || (editItem ? 'Сохранить изменения' : (hideAddMore ? 'Перенести в холодильник' : 'Добавить и закрыть')) }}
        </van-button>
      </div>

      <!-- Calendar Picker Popup -->
      <van-popup v-model:show="showCalendar" round position="bottom">
        <van-date-picker
          title="Срок годности"
          confirm-button-text="Готово"
          cancel-button-text="Отмена"
          :columns-type="['year', 'month', 'day']"
          :min-date="new Date()"
          @confirm="onDateConfirm"
          @cancel="showCalendar = false"
        />
      </van-popup>
    </div>
  </van-popup>
</template>

<style scoped>
.add-sheet {
  max-width: var(--app-max-width);
  margin: 0 auto;
}

.sheet-content {
  padding: 20px 16px 24px;
}

.sheet-title {
  text-align: center;
  font-size: 17px;
  font-weight: 700;
  margin-bottom: 20px;
  color: #1a1a1a;
}

.field-block {
  margin-bottom: 18px;
}

.field-label {
  display: block;
  font-size: 13px;
  font-weight: 600;
  color: #4a4a4a;
  margin-bottom: 8px;
}

.custom-field {
  background-color: #f5f6f8;
  border-radius: 8px;
  padding: 10px 12px;
}

.suggestions-list {
  margin-top: 6px;
  background-color: #ffffff;
  border: 1px solid #ebedf0;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
  overflow: hidden;
}

.suggestion-item {
  display: flex;
  justify-content: space-between;
  align-items: center;
  padding: 10px 14px;
  min-height: 44px;
  cursor: pointer;
  border-bottom: 1px solid #f2f3f5;
}

.suggestion-item:last-child {
  border-bottom: none;
}

.suggestion-item:active {
  background-color: #f7f8fa;
}

.suggestion-name {
  font-size: 14px;
  font-weight: 500;
  color: #1E3A2F;
}

.suggestion-cat {
  font-size: 12px;
  color: #969799;
}

.mode-switch {
  display: flex;
  background-color: #f0f2f5;
  border-radius: 8px;
  padding: 3px;
  margin-bottom: 10px;
}

.mode-btn {
  flex: 1;
  padding: 8px 0;
  min-height: 38px;
  border: none;
  background: transparent;
  font-size: 13px;
  font-weight: 600;
  color: #595959;
  border-radius: 6px;
  cursor: pointer;
}

.mode-btn.active {
  background-color: #ffffff;
  color: #1E3A2F;
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.1);
}

.exact-row {
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.amount-field {
  background-color: #f5f6f8;
  border-radius: 8px;
  padding: 10px 12px;
}

.unit-chips {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.unit-chip {
  padding: 6px 14px;
  min-height: 34px;
  background-color: #f5f6f8;
  border-radius: 6px;
  font-size: 13px;
  font-weight: 500;
  color: #595959;
  display: inline-flex;
  align-items: center;
  cursor: pointer;
}

.unit-chip.active {
  background-color: #1E3A2F;
  color: #ffffff;
}

.approx-row {
  display: flex;
  gap: 8px;
}

.approx-chip {
  flex: 1;
  min-height: 44px;
  border: 1px solid #ebedf0;
  background-color: #ffffff;
  border-radius: 8px;
  font-size: 14px;
  font-weight: 500;
  color: #595959;
  cursor: pointer;
}

.approx-chip.active {
  border-color: #1E3A2F;
  background-color: rgba(30, 58, 47, 0.08);
  color: #1E3A2F;
  font-weight: 600;
}

.label-row {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 8px;
}

.selected-date {
  font-size: 13px;
  font-weight: 600;
  color: #1E3A2F;
}

.text-muted {
  color: #969799;
  font-weight: 400;
}

.date-presets {
  display: flex;
  gap: 6px;
  flex-wrap: wrap;
}

.preset-btn {
  padding: 6px 12px;
  min-height: 36px;
  border: 1px solid #e0e0e0;
  background-color: #ffffff;
  border-radius: 6px;
  font-size: 12px;
  font-weight: 500;
  color: #424242;
  cursor: pointer;
}

.preset-btn:active {
  background-color: #f5f5f5;
}

.calendar-btn {
  border-color: #1E3A2F;
  color: #1E3A2F;
}

.clear-btn {
  border-color: #f44336;
  color: #f44336;
}

.action-footer {
  margin-top: 24px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.submit-button {
  min-height: 44px;
  font-size: 16px;
  font-weight: 600;
}
</style>
