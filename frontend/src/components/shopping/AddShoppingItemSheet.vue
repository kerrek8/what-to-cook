<script setup lang="ts">
import { ref, computed, watch } from 'vue'
import { getIngredientsApi } from '@/api/ingredients'
import type { Ingredient } from '@/types/api'
import type { AddShoppingItemPayload } from '@/stores/shopping'
import { useToastStore } from '@/stores/toast'
import BaseBottomSheet from '@/components/common/BaseBottomSheet.vue'
import { Plus, Check } from 'lucide-vue-next'

const props = defineProps<{
  show: boolean
}>()

const emit = defineEmits<{
  (e: 'update:show', val: boolean): void
  (e: 'add', item: AddShoppingItemPayload): void
}>()

const toast = useToastStore()

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
  'Овощи и зелень',
  'Фрукты и ягоды',
  'Мясо и птица',
  'Молочные продукты',
  'Рыба и морепродукты',
  'Бакалея и соусы',
  'Специи',
  'Другое'
]

const units = ['шт', 'кг', 'г', 'л', 'мл', 'уп']

const suggestions = computed(() => {
  const q = itemName.value.trim().toLowerCase()
  if (!q) return []
  return catalog.value
    .filter((item) => item.name.toLowerCase().includes(q))
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
  selectedCategory.value = item.category
  selectedIngredientId.value = item.id
  if (item.defaultUnit) {
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

function handleSubmit(closeAfter = true) {
  const name = itemName.value.trim()
  if (!name) {
    toast.show('Введите название товара', 'fail')
    return
  }

  emit('add', {
    name,
    category: selectedCategory.value,
    ingredientId: selectedIngredientId.value ?? undefined,
    amount: amount.value,
    unit: unit.value
  })

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
      resetForm()
    }
  }
)
</script>

<template>
  <BaseBottomSheet
    :show="visible"
    title="Добавить в список покупок"
    @update:show="visible = $event"
  >
    <div class="flex flex-col gap-4">
      <!-- Item Name Input -->
      <div>
        <label class="block text-xs font-semibold text-slate-700 mb-1.5">
          Название товара *
        </label>
        <input
          v-model="itemName"
          type="text"
          placeholder="Например, Оливковое масло..."
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

      <!-- Amount & Unit -->
      <div>
        <label class="block text-xs font-semibold text-slate-700 mb-1.5">Количество (необязательно)</label>
        <div class="flex gap-2">
          <input
            v-model.number="amount"
            type="number"
            min="0"
            step="any"
            placeholder="1"
            class="flex-1 px-3.5 py-2 rounded-xl bg-slate-50 border border-slate-200 text-sm focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700"
          />
          <div class="flex gap-1 overflow-x-auto no-scrollbar">
            <button
              v-for="u in units"
              :key="u"
              type="button"
              class="px-3 py-2 rounded-xl text-xs font-semibold transition-all border"
              :class="unit === u ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-slate-50 text-slate-600 border-slate-200 hover:bg-slate-100'"
              @click="unit = u"
            >
              {{ u }}
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- Actions Footer -->
    <template #footer>
      <div class="flex flex-col gap-2">
        <button
          type="button"
          class="w-full py-3 px-4 rounded-xl bg-emerald-950 text-white font-semibold text-sm flex items-center justify-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/20"
          @click="handleSubmit(true)"
        >
          <Check class="w-4 h-4 stroke-[2.5px]" />
          <span>Добавить и закрыть</span>
        </button>

        <button
          type="button"
          class="w-full py-2.5 px-4 rounded-xl bg-emerald-50 text-emerald-900 border border-emerald-200 font-semibold text-sm flex items-center justify-center gap-1.5 hover:bg-emerald-100 active:scale-98 transition-all"
          @click="handleSubmit(false)"
        >
          <Plus class="w-4 h-4 stroke-[2.5px]" />
          <span>Добавить еще позицию</span>
        </button>
      </div>
    </template>
  </BaseBottomSheet>
</template>
