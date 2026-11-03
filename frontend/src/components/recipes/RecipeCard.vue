<script setup lang="ts">
import { computed } from 'vue'
import { useRouter } from 'vue-router'
import type { RecipeResponse, RecipeMatchItem } from '@/types/recipe'
import { useRecipeStore } from '@/stores/recipe'
import { displayText } from '@/i18n/translation'

const props = defineProps<{
  recipe: RecipeResponse
  matchItem?: RecipeMatchItem
  savingIngredients?: Array<{ id: number; name: string }>
}>()

const router = useRouter()
const recipeStore = useRecipeStore()

const difficultyLabel = computed(() => {
  switch (props.recipe.difficulty) {
    case 'easy':
      return 'Легко'
    case 'medium':
      return 'Средне'
    case 'hard':
      return 'Сложно'
    default:
      return props.recipe.difficulty
  }
})

const matchBadgeClass = computed(() => {
  if (!props.matchItem) return ''
  const pct = props.matchItem.match_percentage
  if (pct === 100) return 'match-perfect'
  if (pct >= 70) return 'match-high'
  return 'match-medium'
})

const missingPreview = computed(() => {
  if (!props.matchItem || props.matchItem.missing_ingredients.length === 0) return null
  return props.matchItem.missing_ingredients
    .slice(0, 2)
    .map((m) => displayText(m.name))
    .join(', ')
})

function goToDetail() {
  router.push(`/recipes/${props.recipe.id}`)
}

function onFavoriteClick(e: MouseEvent) {
  e.stopPropagation()
  recipeStore.toggleFavorite(props.recipe.id)
}
</script>

<template>
  <div class="recipe-card" @click="goToDetail">
    <div class="card-media">
      <img
        v-if="recipe.image_url"
        :src="recipe.image_url"
        :alt="recipe.localized_title || displayText(recipe.title)"
        class="card-img"
        loading="lazy"
      />
      <div v-else class="card-img placeholder-img">
        <van-icon name="photograph" size="32" color="#b0bec5" />
      </div>

      <div class="badge-overlay">
        <span v-if="matchItem" class="match-pill" :class="matchBadgeClass">
          {{ matchItem.match_percentage }}%
          <template v-if="matchItem.can_cook_now">・Готово</template>
        </span>

        <span
          v-if="savingIngredients && savingIngredients.length > 0"
          class="saving-pill"
        >
          🔥 Спасает {{ displayText(savingIngredients[0].name) }}
        </span>
      </div>

      <button
        type="button"
        class="fav-btn"
        :class="{ active: recipe.is_favorite }"
        aria-label="В избранное"
        @click="onFavoriteClick"
      >
        <van-icon
          :name="recipe.is_favorite ? 'like' : 'like-o'"
          :color="recipe.is_favorite ? '#e53935' : '#757575'"
          size="20"
        />
      </button>
    </div>

    <div class="card-body">
      <h3 class="card-title">{{ recipe.localized_title || displayText(recipe.title) }}</h3>

      <div class="card-meta">
        <span class="meta-item">
          <van-icon name="clock-o" size="14" />
          {{ recipe.cooking_time_minutes }} мин
        </span>
        <span class="meta-divider">•</span>
        <span class="meta-item difficulty-tag" :class="recipe.difficulty">
          {{ difficultyLabel }}
        </span>
        <template v-if="matchItem">
          <span class="meta-divider">•</span>
          <span class="meta-item ingredients-count">
            {{ matchItem.available_count }}/{{ matchItem.total_ingredients }} инг.
          </span>
        </template>
      </div>

      <p v-if="missingPreview" class="missing-text">
        Купить: {{ missingPreview
        }}<template v-if="matchItem && matchItem.missing_ingredients.length > 2">
          +{{ matchItem.missing_ingredients.length - 2 }}</template
        >
      </p>
    </div>
  </div>
</template>

<style scoped>
.recipe-card {
  background-color: #ffffff;
  border-radius: 16px;
  overflow: hidden;
  box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
  margin-bottom: 14px;
  display: flex;
  flex-direction: column;
  cursor: pointer;
  transition: transform 0.15s ease, box-shadow 0.15s ease;
  user-select: none;
}

.recipe-card:active {
  transform: scale(0.985);
  box-shadow: 0 1px 4px rgba(0, 0, 0, 0.08);
}

.card-media {
  position: relative;
  width: 100%;
  height: 160px;
  background-color: #eceff1;
  overflow: hidden;
}

.card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.placeholder-img {
  display: flex;
  align-items: center;
  justify-content: center;
  background: linear-gradient(135deg, #f5f5f5 0%, #e0e0e0 100%);
}

.badge-overlay {
  position: absolute;
  top: 10px;
  left: 10px;
  display: flex;
  flex-wrap: wrap;
  gap: 6px;
  z-index: 2;
  max-width: calc(100% - 60px);
}

.match-pill {
  font-size: 11px;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 12px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
  color: #ffffff;
}

.match-perfect {
  background-color: #2e7d32;
}

.match-high {
  background-color: #f57c00;
}

.match-medium {
  background-color: #757575;
}

.saving-pill {
  background-color: #d32f2f;
  color: #ffffff;
  font-size: 11px;
  font-weight: 700;
  padding: 3px 8px;
  border-radius: 12px;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.fav-btn {
  position: absolute;
  top: 10px;
  right: 10px;
  width: 44px;
  height: 44px;
  border-radius: 50%;
  background-color: rgba(255, 255, 255, 0.9);
  backdrop-filter: blur(4px);
  border: none;
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 3;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.12);
  transition: transform 0.2s cubic-bezier(0.175, 0.885, 0.32, 1.275);
}

.fav-btn:active {
  transform: scale(0.9);
}

.card-body {
  padding: 12px 14px 14px;
  display: flex;
  flex-direction: column;
  gap: 6px;
}

.card-title {
  margin: 0;
  font-size: 16px;
  font-weight: 700;
  color: #1a1a1a;
  line-height: 1.35;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 6px;
  font-size: 12px;
  color: #616161;
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 3px;
}

.meta-divider {
  color: #bdbdbd;
}

.difficulty-tag.easy {
  color: #2e7d32;
  font-weight: 600;
}

.difficulty-tag.medium {
  color: #f57c00;
  font-weight: 600;
}

.difficulty-tag.hard {
  color: #d32f2f;
  font-weight: 600;
}

.missing-text {
  margin: 2px 0 0;
  font-size: 12px;
  color: #e65100;
  background-color: #fff3e0;
  padding: 4px 8px;
  border-radius: 6px;
  display: inline-block;
  align-self: flex-start;
}
</style>
