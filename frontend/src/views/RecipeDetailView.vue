<script setup lang="ts">
import { ref, computed, onMounted, onUnmounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { showToast } from 'vant'
import { useRecipeStore } from '@/stores/recipe'
import { useInventoryStore } from '@/stores/inventory'
import type { RecipeIngredientResponse } from '@/types/recipe'
import CookingTimer from '@/components/recipes/CookingTimer.vue'
import { getImageUrl } from '@/utils/imageUrl'

const route = useRoute()
const router = useRouter()
const recipeStore = useRecipeStore()
const inventoryStore = useInventoryStore()

const recipeId = computed(() => Number(route.params.id))
const isAddingToShopping = ref(false)
const shoppingAdded = ref(false)
const completedSteps = ref<Record<number, boolean>>({})
const showTimer = ref(false)
const timerRef = ref<InstanceType<typeof CookingTimer> | null>(null)
const timerPresetMinutes = ref<number | undefined>(undefined)
const heroImageError = ref(false)

watch(recipeId, () => {
  heroImageError.value = false
})

onMounted(async () => {
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
  if (ing.display_text) return ing.display_text
  if (ing.amount != null) {
    return `${ing.amount} ${ing.unit ?? ''}`.trim()
  }
  return ing.is_pantry_essential ? 'По вкусу (Базовый)' : 'По вкусу'
}

function getCriticalityBadge(crit: string): { label: string; class: string } {
  switch (crit) {
    case 'critical':
    case 'основной':
      return { label: 'Основной', class: 'crit-critical' }
    case 'essential':
    case 'важный':
      return { label: 'Важный', class: 'crit-essential' }
    default:
      return { label: 'Опциональный', class: 'crit-optional' }
  }
}

function extractTimerMinutes(stepText: string): number | null {
  const match = stepText.match(/(\d+)\s*(?:мин|минут|минуты)/i)
  if (match && match[1]) {
    const mins = parseInt(match[1], 10)
    if (!isNaN(mins) && mins > 0 && mins <= 180) {
      return mins
    }
  }
  return null
}

function startStepTimer(mins: number) {
  timerPresetMinutes.value = mins
  showTimer.value = true
  setTimeout(() => {
    timerRef.value?.setPreset(mins)
  }, 100)
}

function toggleStep(index: number) {
  completedSteps.value[index] = !completedSteps.value[index]
}

async function onAddToShoppingList() {
  if (!recipe.value) return
  if (missingIngredients.value.length === 0) {
    showToast('Все ингредиенты уже есть дома!')
    return
  }

  isAddingToShopping.value = true
  try {
    await recipeStore.addMissingToShopping(recipe.value.id)
    shoppingAdded.value = true
    showToast({
      type: 'success',
      message: 'Недостающие ингредиенты добавлены в список покупок!'
    })
  } catch {
    showToast({
      type: 'fail',
      message: 'Не удалось добавить ингредиенты'
    })
  } finally {
    isAddingToShopping.value = false
  }
}

function onFavoriteToggle() {
  if (recipe.value) {
    recipeStore.toggleFavorite(recipe.value.id)
  }
}
</script>

<template>
  <div class="detail-container">
    <van-nav-bar
      title="Рецепт"
      left-arrow
      fixed
      placeholder
      @click-left="router.back()"
    />

    <div v-if="recipeStore.isDetailLoading" class="skeleton">
      <van-skeleton title avatar :row="6" />
    </div>

    <template v-else-if="recipe">
      <div class="hero-wrapper">
        <img
          v-if="recipe.image_url && !heroImageError"
          :src="getImageUrl(recipe.image_url)"
          :alt="recipe.title"
          class="hero-img"
          @error="heroImageError = true"
        />
        <div v-else class="hero-img placeholder-hero">
          <van-icon name="photograph" size="48" color="#78909c" />
          <span class="placeholder-cat">{{ recipe.description || 'Рецепт' }}</span>
        </div>

        <button
          type="button"
          class="fav-btn"
          :class="{ active: recipe.is_favorite }"
          aria-label="В избранное"
          @click="onFavoriteToggle"
        >
          <van-icon
            :name="recipe.is_favorite ? 'like' : 'like-o'"
            :color="recipe.is_favorite ? '#e53935' : '#424242'"
            size="22"
          />
        </button>
      </div>

      <div class="detail-content safe-area-bottom">
        <h1 class="recipe-title">{{ recipe.title }}</h1>

        <!-- Saving banner -->
        <div v-if="savingProducts.length > 0" class="saving-banner">
          <span class="fire-icon">🔥</span>
          <div class="saving-text">
            <strong>Спасает продукты!</strong>
            Использует скоропортящиеся:
            {{ savingProducts.map((p) => p.name).join(', ') }}
          </div>
        </div>

        <!-- Meta row -->
        <div class="meta-pills">
          <div class="meta-pill">
            <van-icon name="clock-o" color="#2e7d32" size="16" />
            <span>{{ recipe.cooking_time_minutes }} мин</span>
          </div>
          <div class="meta-pill">
            <van-icon name="bar-chart-o" color="#2e7d32" size="16" />
            <span>{{ difficultyLabel }}</span>
          </div>
          <div class="meta-pill">
            <van-icon name="friends-o" color="#2e7d32" size="16" />
            <span>2-4 порции</span>
          </div>
        </div>

        <p v-if="recipe.description" class="recipe-desc">
          {{ recipe.description }}
        </p>

        <!-- Ingredients Section -->
        <div class="section-block">
          <div class="section-header">
            <h2 class="section-title">Ингредиенты</h2>
            <span class="ingredients-summary">
              {{ availableIngredients.length }}/{{ recipe.ingredients?.length || 0 }} в наличии
            </span>
          </div>

          <!-- Есть дома -->
          <div v-if="availableIngredients.length > 0" class="group-box in-stock-box">
            <h3 class="group-title">
              <span class="badge-dot green-dot"></span>
              Есть дома ({{ availableIngredients.length }})
            </h3>
            <ul class="ingredient-list">
              <li
                v-for="ing in availableIngredients"
                :key="ing.ingredient_id"
                class="ingredient-item"
              >
                <div class="ing-left">
                  <van-icon name="passed" color="#2e7d32" size="16" />
                  <span class="ing-name">{{ ing.name }}</span>
                </div>
                <span class="ing-amount">{{ formatIngredientAmount(ing) }}</span>
              </li>
            </ul>
          </div>

          <!-- Нужно купить -->
          <div v-if="missingIngredients.length > 0" class="group-box missing-box">
            <h3 class="group-title">
              <span class="badge-dot red-dot"></span>
              Нужно купить ({{ missingIngredients.length }})
            </h3>
            <ul class="ingredient-list">
              <li
                v-for="ing in missingIngredients"
                :key="ing.ingredient_id"
                class="ingredient-item"
              >
                <div class="ing-left">
                  <span
                    class="crit-badge"
                    :class="getCriticalityBadge(ing.criticality).class"
                  >
                    {{ getCriticalityBadge(ing.criticality).label }}
                  </span>
                  <span class="ing-name">{{ ing.name }}</span>
                </div>
                <span class="ing-amount">{{ formatIngredientAmount(ing) }}</span>
              </li>
            </ul>

            <!-- 1-Click Shopping List Button -->
            <van-button
              round
              block
              type="primary"
              color="#2e7d32"
              icon="cart-o"
              :loading="isAddingToShopping"
              :disabled="shoppingAdded"
              class="add-shopping-btn"
              @click="onAddToShoppingList"
            >
              <template v-if="shoppingAdded">
                ✓ Добавлено в список покупок
              </template>
              <template v-else>
                Добавить недостающие ({{ missingIngredients.length }}) в список
              </template>
            </van-button>
          </div>
        </div>

        <!-- Timer Widget (embedded if active) -->
        <div v-if="showTimer" class="timer-section">
          <CookingTimer
            ref="timerRef"
            :initial-minutes="timerPresetMinutes"
            @close="showTimer = false"
          />
        </div>

        <!-- Instructions Section -->
        <div class="section-block">
          <div class="section-header">
            <h2 class="section-title">Приготовление</h2>
            <button
              v-if="!showTimer"
              type="button"
              class="open-timer-btn"
              @click="showTimer = true"
            >
              <van-icon name="clock-o" />
              Таймер
            </button>
          </div>

          <div class="steps-list">
            <div
              v-for="(step, idx) in recipe.instructions"
              :key="idx"
              class="step-item"
              :class="{ completed: completedSteps[idx] }"
              @click="toggleStep(idx)"
            >
              <div class="step-num" :class="{ done: completedSteps[idx] }">
                <van-icon v-if="completedSteps[idx]" name="success" size="14" />
                <span v-else>{{ idx + 1 }}</span>
              </div>
              <div class="step-body">
                <p class="step-text">{{ step }}</p>
                <div
                  v-if="extractTimerMinutes(step)"
                  class="step-timer-row"
                >
                  <button
                    type="button"
                    class="step-timer-chip"
                    @click.stop="startStepTimer(extractTimerMinutes(step)!)"
                  >
                    ⏱️ Запустить {{ extractTimerMinutes(step) }} мин
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <div v-else class="not-found">
      <van-empty description="Рецепт не найден">
        <van-button round type="primary" color="#2e7d32" @click="router.push('/recipes')">
          Вернуться к рецептам
        </van-button>
      </van-empty>
    </div>
  </div>
</template>

<style scoped>
.detail-container {
  min-height: 100%;
  background-color: #f7f8fa;
  padding-bottom: 72px;
}

.skeleton {
  padding: 24px 16px;
}

.hero-wrapper {
  position: relative;
  width: 100%;
  height: 220px;
  background-color: #e0e0e0;
}

.hero-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.placeholder-hero {
  display: flex;
  align-items: center;
  justify-content: center;
}

.fav-btn {
  position: absolute;
  top: 14px;
  right: 14px;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.95);
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 5;
}

.fav-btn:active {
  transform: scale(0.92);
}

.detail-content {
  padding: 16px;
  display: flex;
  flex-direction: column;
  gap: 16px;
}

.recipe-title {
  margin: 0;
  font-size: 22px;
  font-weight: 800;
  color: #1a1a1a;
  line-height: 1.25;
}

.saving-banner {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  background-color: #ffebee;
  border: 1px solid #ffcdd2;
  border-radius: 12px;
  padding: 10px 14px;
}

.fire-icon {
  font-size: 20px;
}

.saving-text {
  font-size: 13px;
  color: #c62828;
  line-height: 1.4;
}

.saving-text strong {
  display: block;
}

.meta-pills {
  display: flex;
  gap: 8px;
  flex-wrap: wrap;
}

.meta-pill {
  display: inline-flex;
  align-items: center;
  gap: 6px;
  background-color: #ffffff;
  padding: 6px 12px;
  border-radius: 20px;
  font-size: 13px;
  font-weight: 600;
  color: #424242;
  border: 1px solid #e0e0e0;
}

.recipe-desc {
  margin: 0;
  font-size: 14px;
  color: #616161;
  line-height: 1.5;
}

.section-block {
  background-color: #ffffff;
  border-radius: 16px;
  padding: 16px;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.04);
}

.section-header {
  display: flex;
  align-items: center;
  justify-content: space-between;
  margin-bottom: 12px;
}

.section-title {
  margin: 0;
  font-size: 18px;
  font-weight: 700;
  color: #1a1a1a;
}

.ingredients-summary {
  font-size: 12px;
  color: #757575;
  font-weight: 500;
}

.open-timer-btn {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background-color: #e8f5e9;
  color: #2e7d32;
  border: 1px solid #c8e6c9;
  border-radius: 16px;
  padding: 4px 10px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
}

.group-box {
  border-radius: 12px;
  padding: 12px;
  margin-bottom: 12px;
}

.in-stock-box {
  background-color: #f1f8e9;
  border: 1px solid #dcedc8;
}

.missing-box {
  background-color: #fff8e1;
  border: 1px solid #ffe082;
}

.group-title {
  margin: 0 0 10px;
  font-size: 14px;
  font-weight: 700;
  display: flex;
  align-items: center;
  gap: 6px;
  color: #212121;
}

.badge-dot {
  width: 8px;
  height: 8px;
  border-radius: 50%;
}

.green-dot {
  background-color: #2e7d32;
}

.red-dot {
  background-color: #f57c00;
}

.ingredient-list {
  list-style: none;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  gap: 8px;
}

.ingredient-item {
  display: grid;
  grid-template-columns: minmax(0, 1fr) minmax(0, 42%);
  align-items: start;
  font-size: 13px;
  gap: 10px;
}

.ing-left {
  display: flex;
  align-items: center;
  gap: 6px;
  flex: 1;
  min-width: 0;
}

.ing-name {
  color: #212121;
  font-weight: 500;
  min-width: 0;
  overflow-wrap: anywhere;
  line-height: 1.35;
}

.ing-amount {
  color: #616161;
  font-weight: 600;
  min-width: 0;
  max-width: 100%;
  white-space: normal;
  overflow-wrap: anywhere;
  text-align: right;
  line-height: 1.35;
}

.crit-badge {
  font-size: 10px;
  font-weight: 700;
  padding: 2px 6px;
  border-radius: 6px;
  flex-shrink: 0;
  white-space: nowrap;
}

.crit-critical {
  background-color: #ffebee;
  color: #c62828;
}

.crit-essential {
  background-color: #fff3e0;
  color: #ef6c00;
}

.crit-optional {
  background-color: #e8f5e9;
  color: #2e7d32;
}

.add-shopping-btn {
  margin-top: 14px;
  min-height: 44px;
  font-weight: 700;
  font-size: 14px;
}

.timer-section {
  margin-bottom: 8px;
}

.steps-list {
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.step-item {
  display: flex;
  gap: 12px;
  padding: 8px 6px;
  border-radius: 10px;
  cursor: pointer;
  transition: background-color 0.2s ease;
}

.step-item:active {
  background-color: #f5f5f5;
}

.step-item.completed .step-text {
  text-decoration: line-through;
  color: #9e9e9e;
}

.step-num {
  width: 28px;
  height: 28px;
  min-width: 28px;
  border-radius: 50%;
  background-color: #e8f5e9;
  color: #2e7d32;
  font-size: 13px;
  font-weight: 700;
  display: flex;
  align-items: center;
  justify-content: center;
  margin-top: 2px;
  transition: all 0.2s ease;
}

.step-num.done {
  background-color: #2e7d32;
  color: #ffffff;
}

.step-body {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.step-text {
  margin: 0;
  font-size: 14px;
  line-height: 1.5;
  color: #212121;
}

.step-timer-chip {
  display: inline-flex;
  align-items: center;
  gap: 4px;
  background-color: #e3f2fd;
  color: #1565c0;
  border: 1px solid #bbdefb;
  border-radius: 14px;
  padding: 4px 10px;
  font-size: 12px;
  font-weight: 600;
  cursor: pointer;
  min-height: 32px;
}

.step-timer-chip:active {
  background-color: #bbdefb;
}

.not-found {
  padding: 40px 16px;
}
</style>
