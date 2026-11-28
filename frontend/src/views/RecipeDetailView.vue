<script setup lang="ts">
import { ref, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useRecipeStore } from '@/stores/recipe'
import { useInventoryStore } from '@/stores/inventory'
import { useShoppingStore } from '@/stores/shopping'
import { useToastStore } from '@/stores/toast'
import type { RecipeIngredientResponse } from '@/types/recipe'
import { getImageUrl } from '@/utils/imageUrl'
import { formatScaledAmount } from '@/utils/servings'
import {
  ArrowLeft,
  Heart,
  Clock,
  BarChart2,
  Users,
  CheckCircle2,
  Plus,
  Play,
  Flame,
  ChefHat,
  ShoppingBag
} from 'lucide-vue-next'

const route = useRoute()
const router = useRouter()
const recipeStore = useRecipeStore()
const inventoryStore = useInventoryStore()
const shoppingStore = useShoppingStore()
const toast = useToastStore()

const recipeId = computed(() => Number(route.params.id))
const isAddingToShopping = ref(false)
const shoppingAdded = ref(false)
const completedSteps = ref<Record<number, boolean>>({})
const currentServings = ref(2)
const heroImageError = ref(false)
const activeSection = ref<'ingredients' | 'instructions'>('ingredients')

onMounted(async () => {
  if (typeof document !== 'undefined') {
    document.querySelector('.content-wrapper')?.scrollTo({ top: 0 })
  }
  if (typeof window !== 'undefined') {
    window.scrollTo(0, 0)
  }
  if (inventoryStore.items.length === 0) {
    inventoryStore.loadInventory()
  }
  await recipeStore.loadRecipeById(recipeId.value)
})

const recipe = computed(() => recipeStore.currentRecipe)

const savingProducts = computed(() => {
  if (!recipe.value) return []
  return recipeStore.getSavingIngredients(recipe.value.ingredients)
})

function isAvailable(ing: RecipeIngredientResponse): boolean {
  if (ing.is_pantry_essential) return true
  const ingName = ing.name.toLowerCase().trim()
  return inventoryStore.items.some((item) => {
    if (ing.ingredient_id && item.ingredientId === ing.ingredient_id) return true
    const localName = item.name.toLowerCase().trim()
    return localName.includes(ingName) || ingName.includes(localName)
  })
}

const availableIngredients = computed(() => {
  if (!recipe.value?.ingredients) return []
  return recipe.value.ingredients.filter((ing) => isAvailable(ing))
})

const missingIngredients = computed(() => {
  if (!recipe.value?.ingredients) return []
  return recipe.value.ingredients.filter((ing) => !isAvailable(ing))
})

const difficultyLabel = computed(() => {
  switch (recipe.value?.difficulty) {
    case 'easy':
    case 'легко':
      return 'Легко'
    case 'medium':
    case 'средне':
      return 'Средне'
    case 'hard':
    case 'сложно':
      return 'Сложно'
    default:
      return recipe.value?.difficulty || 'Средне'
  }
})

function formatIngredientAmount(ing: RecipeIngredientResponse): string {
  const scaled = formatScaledAmount(ing.amount, ing.unit, ing.display_text, 2, currentServings.value)
  if (scaled === 'По вкусу' && ing.is_pantry_essential) {
    return 'По вкусу (Базовый)'
  }
  return scaled
}

function criticalityBadge(criticality?: string): { label: string; className: string } {
  switch (criticality) {
    case 'основной':
      return {
        label: 'Основной',
        className: 'bg-rose-50 text-rose-700 border-rose-200/80'
      }
    case 'важный':
      return {
        label: 'Важный',
        className: 'bg-amber-50 text-amber-800 border-amber-200/80'
      }
    case 'опциональный':
      return {
        label: 'Опционально',
        className: 'bg-slate-100 text-slate-600 border-slate-200/80'
      }
    default:
      return {
        label: 'Важный',
        className: 'bg-amber-50 text-amber-800 border-amber-200/80'
      }
  }
}

function toggleStep(index: number) {
  completedSteps.value[index] = !completedSteps.value[index]
}

async function onAddToShoppingList() {
  if (!recipe.value) return
  if (missingIngredients.value.length === 0) {
    toast.show('Все ингредиенты уже есть дома!', 'info')
    return
  }

  isAddingToShopping.value = true
  try {
    await recipeStore.addMissingToShopping(recipe.value.id)
    await shoppingStore.loadItems(true)
    shoppingAdded.value = true
    toast.show('Недостающие ингредиенты добавлены в список покупок', 'success')
  } catch {
    toast.show('Не удалось добавить ингредиенты', 'fail')
  } finally {
    isAddingToShopping.value = false
  }
}

function onFavoriteToggle() {
  if (recipe.value) {
    recipeStore.toggleFavorite(recipe.value.id)
  }
}

function startCooking() {
  router.push(`/recipes/${recipeId.value}/cook`)
}
</script>

<template>
  <div class="min-h-full pb-28 bg-slate-50">
    <!-- Loading skeleton -->
    <div v-if="recipeStore.isDetailLoading" class="p-4 flex flex-col gap-4">
      <div class="w-full h-72 rounded-3xl bg-slate-200 animate-pulse" />
      <div class="h-8 w-2/3 bg-slate-200 rounded-xl animate-pulse" />
      <div class="h-20 bg-slate-200 rounded-2xl animate-pulse" />
      <div class="h-40 bg-slate-200 rounded-2xl animate-pulse" />
    </div>

    <!-- Loaded Recipe View -->
    <div v-else-if="recipe" class="flex flex-col">
      <!-- Hero Image & Navigation Header Overlay -->
      <div class="relative w-full h-80 bg-slate-900 overflow-hidden">
        <img
          v-if="recipe.image_url && !heroImageError"
          :src="getImageUrl(recipe.image_url)"
          :alt="recipe.title"
          class="w-full h-full object-cover"
          @error="heroImageError = true"
        />
        <div v-else class="w-full h-full flex flex-col items-center justify-center text-slate-500 bg-slate-800">
          <ChefHat class="w-16 h-16 stroke-[1.5px] text-slate-400 mb-2" />
          <span class="text-sm font-medium">{{ recipe.description || 'Рецепт' }}</span>
        </div>

        <!-- Gradient Vignette -->
        <div class="absolute inset-0 bg-gradient-to-t from-slate-950 via-slate-950/20 to-slate-950/40 pointer-events-none" />

        <!-- Top Navigation Overlay -->
        <div class="absolute top-4 inset-x-4 flex items-center justify-between z-10">
          <button
            type="button"
            class="w-10 h-10 rounded-full bg-slate-900/60 backdrop-blur-md text-white flex items-center justify-center border border-white/20 active:scale-95 transition-all"
            aria-label="Назад"
            @click="router.back()"
          >
            <ArrowLeft class="w-5 h-5 stroke-[2.2px]" />
          </button>

          <button
            type="button"
            class="w-10 h-10 rounded-full bg-slate-900/60 backdrop-blur-md text-white flex items-center justify-center border border-white/20 active:scale-95 transition-all"
            aria-label="В избранное"
            @click="onFavoriteToggle"
          >
            <Heart
              class="w-5 h-5 transition-colors"
              :class="recipe.is_favorite ? 'text-rose-500 fill-rose-500' : 'text-white'"
            />
          </button>
        </div>

        <!-- Recipe Title inside Hero Bottom -->
        <div class="absolute bottom-4 inset-x-4 z-10">
          <h1 class="text-2xl font-black text-white leading-tight drop-shadow-md">
            {{ recipe.title }}
          </h1>
        </div>
      </div>

      <!-- Main Body Container -->
      <div class="p-4 flex flex-col gap-4 -mt-3 bg-slate-50 rounded-t-3xl relative z-10 shadow-lg">
        <!-- Saving Products Alert Banner -->
        <div
          v-if="savingProducts.length > 0"
          class="flex items-start gap-2.5 p-3.5 rounded-2xl bg-amber-500/15 border border-amber-500/30 text-amber-950"
        >
          <Flame class="w-5 h-5 text-amber-600 shrink-0 mt-0.5" />
          <div class="flex flex-col text-xs leading-relaxed">
            <span class="font-bold text-amber-900">🔥 Спасает продукты!</span>
            <span class="text-amber-800">
              Использует скоропортящиеся:
              <strong>{{ savingProducts.map((p) => p.name).join(', ') }}</strong>
            </span>
          </div>
        </div>

        <!-- Meta Information Cards Row -->
        <div class="grid grid-cols-[1fr_1fr_1.45fr] gap-2">
          <!-- Time -->
          <div class="p-3 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex flex-col items-center justify-center text-center">
            <Clock class="w-4 h-4 text-emerald-800 mb-1" />
            <span class="text-[11px] text-slate-400 font-medium">Время</span>
            <span class="text-xs font-bold text-slate-800">{{ recipe.cooking_time_minutes }} мин</span>
          </div>

          <!-- Difficulty -->
          <div class="p-3 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex flex-col items-center justify-center text-center">
            <BarChart2 class="w-4 h-4 text-emerald-800 mb-1" />
            <span class="text-[11px] text-slate-400 font-medium">Сложность</span>
            <span class="text-xs font-bold text-slate-800">{{ difficultyLabel }}</span>
          </div>

          <!-- Servings Stepper -->
          <div class="py-2.5 px-2 rounded-2xl bg-white border border-slate-200/80 shadow-xs flex flex-col items-center justify-center text-center overflow-hidden">
            <div class="flex items-center gap-1 mb-1 text-slate-400">
              <Users class="w-3.5 h-3.5 text-emerald-800" />
              <span class="text-[11px] font-medium">Порции</span>
            </div>
            <div class="flex items-center justify-center gap-1 w-full">
              <button
                type="button"
                class="w-9 h-9 rounded-xl bg-[#EBF3EF] text-[#165337] font-bold flex items-center justify-center hover:bg-emerald-100 active:scale-90 transition-all disabled:opacity-30 text-sm shrink-0"
                aria-label="Уменьшить порции"
                :disabled="currentServings <= 1"
                @click="currentServings--"
              >
                -
              </button>
              <span class="text-xs font-bold text-slate-800 min-w-[16px] text-center">{{ currentServings }}</span>
              <button
                type="button"
                class="w-9 h-9 rounded-xl bg-[#EBF3EF] text-[#165337] font-bold flex items-center justify-center hover:bg-emerald-100 active:scale-90 transition-all disabled:opacity-30 text-sm shrink-0"
                aria-label="Увеличить порции"
                :disabled="currentServings >= 12"
                @click="currentServings++"
              >
                +
              </button>
            </div>
          </div>
        </div>

        <!-- Description -->
        <p v-if="recipe.description" class="text-xs text-slate-600 leading-relaxed px-1">
          {{ recipe.description }}
        </p>

        <!-- Section Tab Bar (Ингредиенты / Инструкции) -->
        <div class="grid grid-cols-2 p-1 bg-slate-200/70 rounded-2xl border border-slate-200/60 text-xs font-semibold">
          <button
            type="button"
            class="py-2.5 px-3 rounded-xl flex items-center justify-center gap-1.5 transition-all"
            :class="activeSection === 'ingredients' ? 'bg-white text-emerald-950 shadow-xs' : 'text-slate-500 hover:text-slate-700'"
            @click="activeSection = 'ingredients'"
          >
            <span>Ингредиенты</span>
            <span
              class="px-1.5 py-0.5 rounded-full text-[10px] font-bold"
              :class="activeSection === 'ingredients' ? 'bg-emerald-950 text-white' : 'bg-slate-300/70 text-slate-700'"
            >
              {{ availableIngredients.length }}/{{ recipe.ingredients?.length || 0 }}
            </span>
          </button>

          <button
            type="button"
            class="py-2.5 px-3 rounded-xl flex items-center justify-center gap-1.5 transition-all"
            :class="activeSection === 'instructions' ? 'bg-white text-emerald-950 shadow-xs' : 'text-slate-500 hover:text-slate-700'"
            @click="activeSection = 'instructions'"
          >
            <span>Инструкции</span>
            <span
              class="px-1.5 py-0.5 rounded-full text-[10px] font-bold"
              :class="activeSection === 'instructions' ? 'bg-emerald-950 text-white' : 'bg-slate-300/70 text-slate-700'"
            >
              {{ recipe.instructions?.length || 0 }}
            </span>
          </button>
        </div>

        <!-- Ingredients Section -->
        <div v-if="activeSection === 'ingredients'" class="p-4 rounded-3xl bg-white border border-slate-200/80 shadow-xs flex flex-col gap-3">
          <div class="flex items-center justify-between border-b border-slate-100 pb-2.5">
            <h2 class="text-base font-bold text-slate-900">Ингредиенты</h2>
            <span class="text-xs font-semibold px-2 py-0.5 rounded-full bg-emerald-50 text-emerald-800 border border-emerald-100">
              {{ availableIngredients.length }}/{{ recipe.ingredients?.length || 0 }} в наличии
            </span>
          </div>

          <!-- In-Stock Ingredients List -->
          <div v-if="availableIngredients.length > 0" class="flex flex-col gap-1.5">
            <span class="text-[11px] font-bold uppercase tracking-wider text-emerald-800 flex items-center gap-1">
              <span class="w-1.5 h-1.5 rounded-full bg-emerald-500" />
              Есть дома ({{ availableIngredients.length }})
            </span>
            <div
              v-for="ing in availableIngredients"
              :key="ing.ingredient_id || ing.name"
              class="flex items-center justify-between gap-2 py-2 px-2.5 rounded-xl bg-emerald-50/40 text-xs text-slate-800"
            >
              <div class="flex items-center gap-2 min-w-0">
                <CheckCircle2 class="w-4 h-4 text-emerald-600 shrink-0" />
                <div class="flex flex-wrap items-center gap-1.5 min-w-0">
                  <span class="font-medium truncate">{{ ing.name }}</span>
                  <span
                    class="text-[10px] font-semibold px-1.5 py-0.5 rounded-md border leading-none shrink-0"
                    :class="criticalityBadge(ing.criticality).className"
                  >
                    {{ criticalityBadge(ing.criticality).label }}
                  </span>
                </div>
              </div>
              <span class="text-slate-500 font-semibold shrink-0">{{ formatIngredientAmount(ing) }}</span>
            </div>
          </div>

          <!-- Missing Ingredients List -->
          <div v-if="missingIngredients.length > 0" class="flex flex-col gap-1.5 pt-1">
            <div class="flex items-center justify-between">
              <span class="text-[11px] font-bold uppercase tracking-wider text-slate-500 flex items-center gap-1">
                <span class="w-1.5 h-1.5 rounded-full bg-slate-400" />
                Не хватает ({{ missingIngredients.length }})
              </span>
            </div>

            <div
              v-for="ing in missingIngredients"
              :key="ing.ingredient_id || ing.name"
              class="flex items-center justify-between gap-2 py-2 px-2.5 rounded-xl bg-slate-50 text-xs text-slate-600"
            >
              <div class="flex flex-wrap items-center gap-1.5 min-w-0">
                <span class="font-medium text-slate-700 truncate">{{ ing.name }}</span>
                <span
                  class="text-[10px] font-semibold px-1.5 py-0.5 rounded-md border leading-none shrink-0"
                  :class="criticalityBadge(ing.criticality).className"
                >
                  {{ criticalityBadge(ing.criticality).label }}
                </span>
              </div>
              <span class="text-slate-400 font-semibold shrink-0">{{ formatIngredientAmount(ing) }}</span>
            </div>

            <!-- Prominent Add to Shopping List CTA Button -->
            <button
              type="button"
              class="mt-2 py-3 px-4 rounded-2xl flex items-center justify-center gap-2 font-bold text-xs shadow-xs transition-all active:scale-98 select-none border"
              :class="
                shoppingAdded
                  ? 'bg-emerald-100 text-emerald-800 border-emerald-300'
                  : 'bg-emerald-950 text-white hover:bg-emerald-900 border-emerald-900 shadow-sm'
              "
              :disabled="isAddingToShopping"
              @click="onAddToShoppingList"
            >
              <ShoppingBag class="w-4 h-4" />
              <span>{{ shoppingAdded ? '✓ Добавлено в список покупок' : `Добавить недостающие (${missingIngredients.length}) в список покупок` }}</span>
            </button>
          </div>
        </div>

        <!-- Cooking Steps Checklist -->
        <div v-else class="p-4 rounded-3xl bg-white border border-slate-200/80 shadow-xs flex flex-col gap-3">
          <h2 class="text-base font-bold text-slate-900 border-b border-slate-100 pb-2.5">
            Шаги приготовления
          </h2>

          <div class="flex flex-col gap-3">
            <div
              v-for="(step, idx) in recipe.instructions"
              :key="idx"
              class="flex items-start gap-3 p-3 rounded-2xl border transition-all cursor-pointer"
              :class="completedSteps[idx] ? 'bg-emerald-50/40 border-emerald-200/60 opacity-70' : 'bg-slate-50/60 border-slate-200/60'"
              @click="toggleStep(idx)"
            >
              <div
                class="w-6 h-6 rounded-full flex items-center justify-center text-xs font-bold shrink-0 mt-0.5 border"
                :class="completedSteps[idx] ? 'bg-emerald-800 text-white border-emerald-800' : 'bg-white text-slate-600 border-slate-300'"
              >
                {{ idx + 1 }}
              </div>
              <p
                class="text-xs text-slate-700 leading-relaxed flex-1 select-none"
                :class="{ 'line-through text-slate-400': completedSteps[idx] }"
              >
                {{ step }}
              </p>
            </div>
          </div>
        </div>
      </div>

      <!-- Bottom Floating Cook CTA Button (Figma Row 4/5) -->
      <div class="fixed bottom-4 inset-x-4 max-w-lg mx-auto z-30 safe-area-bottom">
        <button
          type="button"
          class="w-full py-4 px-6 rounded-2xl bg-emerald-950 text-white font-bold text-base flex items-center justify-center gap-2.5 shadow-elevated hover:bg-emerald-900 active:scale-98 transition-all border border-emerald-800"
          @click="startCooking"
        >
          <Play class="w-5 h-5 fill-white" />
          <span>Начать готовить (Cook Mode)</span>
        </button>
      </div>
    </div>
  </div>
</template>
