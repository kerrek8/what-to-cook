<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { getIngredientsApi } from '@/api/ingredients'
import type { Ingredient } from '@/types/api'
import type { AddItemData } from '@/stores/inventory'
import type { LocalInventoryItem } from '@/db/types'
import { useToastStore } from '@/stores/toast'
import BaseBottomSheet from '@/components/common/BaseBottomSheet.vue'
import { Calendar, Snowflake, Plus, Check } from 'lucide-vue-next'

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

const toast = useToastStore()

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
const activePreset = ref<string | null>(null)

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

const categories = [
  'Овощи и зелень',
  'Фрукты и ягоды',
  'Мясо и птица',
  'Молочные продукты',
  'Рыба и морепродукты',
  'Бакалея и соусы',
  'Специи',
  'Другое'
]

async function loadCatalog() {
  if (catalog.value.length > 0) return
  isSearching.value = true
  try {
    catalog.value = await getIngredientsApi()
  } catch {
    catalog.value = [
      { id: 1, name: 'Молоко', category: 'Молочные продукты', defaultUnit: 'л', isPantryEssential: false },
      { id: 2, name: 'Яйца', category: 'Молочные продукты', defaultUnit: 'шт', isPantryEssential: false },
      { id: 3, name: 'Куриное филе', category: 'Мясо и птица', defaultUnit: 'г', isPantryEssential: false },
      { id: 4, name: 'Картофель', category: 'Овощи и зелень', defaultUnit: 'кг', isPantryEssential: false },
      { id: 5, name: 'Сыр твердый', category: 'Молочные продукты', defaultUnit: 'г', isPantryEssential: false }
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

function setPresetDays(days: number, label: string) {
  const d = new Date()
  d.setDate(d.getDate() + days)
  expirationDate.value = d.toISOString().split('T')[0]
  activePreset.value = label
}

function clearDate() {
  expirationDate.value = ''
  activePreset.value = null
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
  activePreset.value = null
}

function handleSubmit(closeAfter = false) {
  const name = productName.value.trim()
  if (!name) {
    toast.show('Укажите название продукта', 'fail')
    return
  }

  if (props.editItem?.id) {
    emit('update', {
      id: props.editItem.id,
      changes: {
        name,
        category: selectedCategory.value,
        ingredientId: selectedIngredientId.value,
        amount: quantityMode.value === 'exact' ? amount.value : null,
        unit: quantityMode.value === 'exact' ? unit.value : null,
        approximateQuantity: quantityMode.value === 'approx' ? approximateQuantity.value : null,
        expirationDate: expirationDate.value || null
      }
    })
    visible.value = false
    return
  }

  const payload: AddItemData = {
    name,
    category: selectedCategory.value,
    ingredientId: selectedIngredientId.value ?? undefined,
    expirationDate: expirationDate.value || undefined
  }

  if (quantityMode.value === 'exact') {
    payload.amount = amount.value
    payload.unit = unit.value
  } else {
    payload.approximateQuantity = approximateQuantity.value
  }

  emit('add', payload)

  if (closeAfter) {
    visible.value = false
    resetForm()
  } else {
    resetForm()
    toast.show('Добавлено! Можно добавить следующий', 'success')
  }
}

watch(
  () => props.show,
  (val) => {
    if (val) {
      loadCatalog()
      if (props.editItem) {
        productName.value = props.editItem.name
        selectedCategory.value = props.editItem.category || 'Другое'
        selectedIngredientId.value = props.editItem.ingredientId || null
        if (props.editItem.amount != null) {
          quantityMode.value = 'exact'
          amount.value = props.editItem.amount
          unit.value = props.editItem.unit || 'г'
        } else if (props.editItem.approximateQuantity) {
          quantityMode.value = 'approx'
          approximateQuantity.value = props.editItem.approximateQuantity
        }
        expirationDate.value = props.editItem.expirationDate || ''
      } else if (props.initialItem) {
        productName.value = props.initialItem.name
        selectedCategory.value = props.initialItem.category || 'Другое'
        selectedIngredientId.value = props.initialItem.ingredientId || null
        if (props.initialItem.amount != null) {
          quantityMode.value = 'exact'
          amount.value = props.initialItem.amount
          unit.value = props.initialItem.unit || 'г'
        } else if (props.initialItem.approximateQuantity) {
          quantityMode.value = 'approx'
          approximateQuantity.value = props.initialItem.approximateQuantity
        }
        expirationDate.value = props.initialItem.expirationDate || ''
      } else {
        resetForm()
      }
    }
  }
)
</script>

<template>
  <BaseBottomSheet
    :show="visible"
    :title="title || (editItem ? 'Редактировать продукт' : 'Добавить в холодильник')"
    @update:show="visible = $event"
  >
    <div class="flex flex-col gap-4">
      <!-- Product Name Input -->
      <div>
        <label class="block text-xs font-semibold text-slate-700 mb-1.5">
          Название продукта *
        </label>
        <input
          v-model="productName"
          type="text"
          placeholder="Например, Сыр пармезан..."
          class="w-full px-3.5 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white transition-all"
        />

        <!-- Autocomplete Suggestions -->
        <div v-if="suggestions.length > 0" class="mt-1.5 rounded-xl border border-slate-200 bg-white shadow-md divide-y divide-slate-100 overflow-hidden">
          <button
            v-for="item in suggestions"
            :key="item.id"
            type="button"
            class="w-full px-3.5 py-2 text-left flex items-center justify-between hover:bg-emerald-50/50 transition-colors"
            @click="selectSuggestion(item)"
          >
            <span class="text-sm font-medium text-emerald-950">{{ item.name }}</span>
            <span class="text-xs text-slate-400">{{ item.category }}</span>
          </button>
        </div>
      </div>

      <!-- Category Selector -->
      <div>
        <label class="block text-xs font-semibold text-slate-700 mb-1.5">Категория</label>
        <select
          v-model="selectedCategory"
          class="w-full px-3 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700"
        >
          <option v-for="cat in categories" :key="cat" :value="cat">{{ cat }}</option>
        </select>
      </div>

      <!-- Quantity Mode Selector -->
      <div>
        <div class="flex items-center justify-between mb-1.5">
          <label class="text-xs font-semibold text-slate-700">Количество</label>
          <div class="flex p-0.5 bg-slate-100 rounded-lg text-xs font-medium">
            <button
              type="button"
              class="px-2.5 py-1 rounded-md transition-all"
              :class="quantityMode === 'exact' ? 'bg-white text-emerald-950 shadow-xs font-semibold' : 'text-slate-500'"
              @click="quantityMode = 'exact'"
            >
              Точно
            </button>
            <button
              type="button"
              class="px-2.5 py-1 rounded-md transition-all"
              :class="quantityMode === 'approx' ? 'bg-white text-emerald-950 shadow-xs font-semibold' : 'text-slate-500'"
              @click="quantityMode = 'approx'"
            >
              Примерно
            </button>
          </div>
        </div>

        <!-- Exact Mode -->
        <div v-if="quantityMode === 'exact'" class="flex flex-col gap-2">
          <input
            v-model.number="amount"
            type="number"
            min="0"
            step="any"
            placeholder="0"
            class="w-full px-3.5 py-2.5 rounded-xl bg-slate-50 border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white transition-all"
          />
          <div class="grid grid-cols-6 gap-1.5">
            <button
              v-for="u in units"
              :key="u"
              type="button"
              class="py-2 rounded-xl text-xs font-semibold text-center transition-all border select-none"
              :class="unit === u ? 'bg-emerald-950 text-white border-emerald-950 shadow-xs' : 'bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100'"
              @click="unit = u"
            >
              {{ u }}
            </button>
          </div>
        </div>

        <!-- Approx Mode -->
        <div v-else class="grid grid-cols-3 gap-2">
          <button
            v-for="lvl in [
              { val: 'few', label: 'Мало' },
              { val: 'medium', label: 'Средне' },
              { val: 'much', label: 'Много' }
            ]"
            :key="lvl.val"
            type="button"
            class="py-2.5 px-3 rounded-xl text-xs font-semibold border transition-all"
            :class="approximateQuantity === lvl.val ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-slate-50 text-slate-600 border-slate-200'"
            @click="approximateQuantity = lvl.val as any"
          >
            {{ lvl.label }}
          </button>
        </div>
      </div>

      <!-- Shelf-Life Presets (Figma Row 2) -->
      <div>
        <div class="flex items-center justify-between mb-2">
          <label class="text-xs font-semibold text-slate-700 flex items-center gap-1.5">
            <Calendar class="w-3.5 h-3.5 text-emerald-800" />
            Срок годности
          </label>
          <span v-if="expirationDate" class="text-xs font-bold text-emerald-800">
            до {{ expirationDate }}
          </span>
          <span v-else class="text-xs text-slate-400">
            Не указан
          </span>
        </div>

        <!-- Fast Preset Chips -->
        <div class="grid grid-cols-2 gap-2 mb-2">
          <button
            type="button"
            class="py-2 px-3 rounded-xl border text-xs font-semibold transition-all flex items-center justify-center gap-1.5"
            :class="activePreset === '+3 дня' ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'"
            @click="setPresetDays(3, '+3 дня')"
          >
            +3 дня
          </button>
          <button
            type="button"
            class="py-2 px-3 rounded-xl border text-xs font-semibold transition-all flex items-center justify-center gap-1.5"
            :class="activePreset === '1 неделя' ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'"
            @click="setPresetDays(7, '1 неделя')"
          >
            1 неделя
          </button>
          <button
            type="button"
            class="py-2 px-3 rounded-xl border text-xs font-semibold transition-all flex items-center justify-center gap-1.5"
            :class="activePreset === '2 недели' ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-slate-50 text-slate-700 border-slate-200 hover:bg-slate-100'"
            @click="setPresetDays(14, '2 недели')"
          >
            2 недели
          </button>
          <button
            type="button"
            class="py-2 px-3 rounded-xl border text-xs font-semibold transition-all flex items-center justify-center gap-1.5"
            :class="activePreset === 'В заморозку' ? 'bg-cyan-900 text-white border-cyan-900' : 'bg-cyan-50 text-cyan-800 border-cyan-200 hover:bg-cyan-100/60'"
            @click="setPresetDays(90, 'В заморозку')"
          >
            <Snowflake class="w-3.5 h-3.5" />
            В заморозку
          </button>
        </div>

        <!-- Native Date Input & Clear Button -->
        <div class="flex items-center gap-2">
          <input
            v-model="expirationDate"
            type="date"
            class="flex-1 px-3 py-2 rounded-xl bg-slate-50 border border-slate-200 text-xs font-medium text-slate-700 focus:outline-none focus:ring-2 focus:ring-emerald-700/20"
            @change="activePreset = null"
          />
          <button
            v-if="expirationDate"
            type="button"
            class="py-2 px-3 rounded-xl bg-slate-100 hover:bg-slate-200 text-slate-600 text-xs font-medium transition-colors"
            @click="clearDate"
          >
            Сбросить
          </button>
        </div>
      </div>
    </div>

    <!-- Action Buttons -->
    <template #footer>
      <div class="flex flex-col gap-2">
        <button
          type="button"
          class="w-full py-3 px-4 rounded-xl bg-emerald-950 text-white font-semibold text-sm flex items-center justify-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/20"
          @click="handleSubmit(true)"
        >
          <Check class="w-4 h-4 stroke-[2.5px]" />
          <span>{{ submitText || (editItem ? 'Сохранить изменения' : 'Добавить и закрыть') }}</span>
        </button>

        <button
          v-if="!editItem && !hideAddMore"
          type="button"
          class="w-full py-2.5 px-4 rounded-xl bg-emerald-50 text-emerald-900 border border-emerald-200 font-semibold text-sm flex items-center justify-center gap-1.5 hover:bg-emerald-100 active:scale-98 transition-all"
          @click="handleSubmit(false)"
        >
          <Plus class="w-4 h-4 stroke-[2.5px]" />
          <span>Добавить еще продукт</span>
        </button>
      </div>
    </template>
  </BaseBottomSheet>
</template>
