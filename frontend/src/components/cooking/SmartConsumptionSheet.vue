<script setup lang="ts">
import { ref, computed } from 'vue'
import BaseBottomSheet from '@/components/common/BaseBottomSheet.vue'
import { useInventoryStore } from '@/stores/inventory'
import type { RecipeIngredientResponse } from '@/types/recipe'
import { Check, CheckSquare, Square, UtensilsCrossed } from 'lucide-vue-next'

const props = defineProps<{
  isOpen: boolean
  recipeTitle?: string
  ingredients: RecipeIngredientResponse[]
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'applied', count: number): void
}>()

const inventoryStore = useInventoryStore()

// Match recipe ingredients with inventory items
interface MatchedItem {
  recipeIngredient: RecipeIngredientResponse
  inventoryItemId: number
  inventoryName: string
  currentAmount: number | null
  recipeAmount: number | null
  unit: string | null
  selected: boolean
}

const matchedItems = computed<MatchedItem[]>(() => {
  const list: MatchedItem[] = []
  for (const ring of props.ingredients) {
    const found = inventoryStore.items.find((inv) => {
      if (inv.ingredientId && ring.ingredient_id && inv.ingredientId === ring.ingredient_id) {
        return true
      }
      return inv.name.trim().toLowerCase() === ring.name.trim().toLowerCase()
    })

    if (found) {
      list.push({
        recipeIngredient: ring,
        inventoryItemId: found.id,
        inventoryName: found.name,
        currentAmount: found.amount,
        recipeAmount: ring.amount ?? null,
        unit: ring.unit || found.unit || null,
        selected: true
      })
    }
  }
  return list
})

const selectedItems = ref<Record<number, boolean>>({})

// Initialize selection map when matched items change
const isSelected = (itemId: number) => {
  return selectedItems.value[itemId] !== undefined ? selectedItems.value[itemId] : true
}

const toggleSelection = (itemId: number) => {
  selectedItems.value[itemId] = !isSelected(itemId)
}

const selectedCount = computed(() => {
  return matchedItems.value.filter((item) => isSelected(item.inventoryItemId)).length
})

const isSubmitting = ref(false)

async function applyConsumption() {
  if (isSubmitting.value) return
  isSubmitting.value = true

  let deductedCount = 0
  try {
    for (const item of matchedItems.value) {
      if (!isSelected(item.inventoryItemId)) continue

      if (
        item.currentAmount != null &&
        item.recipeAmount != null &&
        item.currentAmount > item.recipeAmount
      ) {
        const remaining = Math.round((item.currentAmount - item.recipeAmount) * 100) / 100
        await inventoryStore.updateItem(item.inventoryItemId, { amount: remaining })
      } else {
        // Consumed entirely
        await inventoryStore.deleteItem(item.inventoryItemId)
      }
      deductedCount++
    }

    emit('applied', deductedCount)
    emit('close')
  } finally {
    isSubmitting.value = false
  }
}
</script>

<template>
  <BaseBottomSheet
    :is-open="isOpen"
    title="Списать продукты"
    @close="emit('close')"
  >
    <div class="space-y-4">
      <div class="flex items-center gap-3 p-3.5 rounded-2xl bg-surface-container border border-border/60">
        <div class="w-10 h-10 rounded-xl bg-primary/10 text-primary flex items-center justify-center shrink-0">
          <UtensilsCrossed class="w-5 h-5 stroke-[2.2px]" />
        </div>
        <div class="min-w-0">
          <p class="text-sm font-semibold text-text truncate">
            {{ recipeTitle || 'Рецепт приготовлен' }}
          </p>
          <p class="text-xs text-text-muted mt-0.5">
            Отметьте продукты, которые хотите вычесть из холодильника
          </p>
        </div>
      </div>

      <div v-if="matchedItems.length === 0" class="text-center py-6 text-text-muted text-sm">
        В вашем холодильнике не найдено совпадающих ингредиентов для автосписания.
      </div>

      <div v-else class="space-y-2 max-h-[45vh] overflow-y-auto pr-1">
        <button
          v-for="item in matchedItems"
          :key="item.inventoryItemId"
          type="button"
          class="w-full flex items-center justify-between p-3 rounded-xl border text-left transition-colors active:scale-[0.99]"
          :class="
            isSelected(item.inventoryItemId)
              ? 'bg-primary-soft/40 border-primary/40'
              : 'bg-surface-container/60 border-border/40 opacity-70'
          "
          @click="toggleSelection(item.inventoryItemId)"
        >
          <div class="flex items-center gap-3 min-w-0">
            <component
              :is="isSelected(item.inventoryItemId) ? CheckSquare : Square"
              class="w-5 h-5 text-primary shrink-0"
            />
            <div class="min-w-0">
              <span class="text-sm font-medium text-text block truncate">
                {{ item.inventoryName }}
              </span>
              <span class="text-xs text-text-muted block">
                Списать: {{ item.recipeAmount ? `${item.recipeAmount} ${item.unit || ''}` : 'всё' }}
                <span v-if="item.currentAmount != null" class="opacity-75">
                  (в наличии {{ item.currentAmount }} {{ item.unit || '' }})
                </span>
              </span>
            </div>
          </div>
        </button>
      </div>

      <div class="flex gap-2.5 pt-2">
        <button
          type="button"
          class="flex-1 py-3 px-4 rounded-xl border border-border text-text font-medium text-sm hover:bg-surface-container active:scale-95 transition-all"
          @click="emit('close')"
        >
          Пропустить
        </button>
        <button
          type="button"
          class="flex-1 py-3 px-4 rounded-xl bg-primary text-on-primary font-bold text-sm shadow-md hover:bg-primary-hover active:scale-95 transition-all disabled:opacity-40 disabled:pointer-events-none flex items-center justify-center gap-1.5"
          :disabled="isSubmitting || (matchedItems.length > 0 && selectedCount === 0)"
          @click="applyConsumption"
        >
          <Check class="w-4 h-4 stroke-[2.5px]" />
          <span>{{ matchedItems.length === 0 ? 'Готово' : `Списать (${selectedCount})` }}</span>
        </button>
      </div>
    </div>
  </BaseBottomSheet>
</template>
