<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import type { RecipeResponse, RecipeMatchItem } from '@/types/recipe'
import { useRecipeStore } from '@/stores/recipe'
import { getImageUrl } from '@/utils/imageUrl'

const props = defineProps<{
  recipe: RecipeResponse
  matchItem?: RecipeMatchItem
  savingIngredients?: Array<{ id: number; name: string }>
}>()

const router = useRouter()
const recipeStore = useRecipeStore()
const imageError = ref(false)

watch(() => props.recipe.image_url, () => {
  imageError.value = false
})

const difficultyLabel = computed(() => {
  switch (props.recipe.difficulty) {
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
      return props.recipe.difficulty
  }
})

const difficultyClass = computed(() => {
  switch (props.recipe.difficulty) {
    case 'easy':
    case 'легко':
      return 'easy'
    case 'medium':
    case 'средне':
      return 'medium'
    case 'hard':
    case 'сложно':
      return 'hard'
    default:
      return 'medium'
  }
})

type ReadinessTier = 'ready' | 'almost' | 'partial' | 'none'
const readinessTier = computed<ReadinessTier>(() => {
  if (!props.matchItem) return 'none'
  if (props.matchItem.can_cook_now || props.matchItem.match_percentage === 100) {
    return 'ready'
  }
  if (props.matchItem.missing_ingredients?.length === 1 || props.matchItem.match_percentage >= 80) {
    return 'almost'
  }
  return 'partial'
})

const missingPreview = computed(() => {
  if (!props.matchItem || props.matchItem.missing_ingredients.length === 0) return null
  return props.matchItem.missing_ingredients
    .slice(0, 2)
    .map((m) => m.name)
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
  <div
    class="recipe-card"
    :class="{
      'card-ready': readinessTier === 'ready',
      'card-almost': readinessTier === 'almost'
    }"
    @click="goToDetail"
  >
    <div class="card-media">
      <img
        v-if="recipe.image_url && !imageError"
        :src="getImageUrl(recipe.image_url)"
        :alt="recipe.title"
        class="card-img"
        loading="lazy"
        @error="imageError = true"
      />
      <div v-else class="card-img placeholder-img">
        <van-icon name="photograph" size="32" color="#78909c" />
        <span class="placeholder-cat">{{ recipe.description || 'Рецепт' }}</span>
      </div>

      <div class="badge-overlay">
        <span v-if="readinessTier === 'ready'" class="match-pill match-ready">
          ✓ Можно готовить
        </span>
        <span v-else-if="readinessTier === 'almost'" class="match-pill match-almost">
          🟡 {{ matchItem && matchItem.missing_ingredients && matchItem.missing_ingredients.length === 1 ? `Купить: ${matchItem.missing_ingredients[0].name}` : `${matchItem ? matchItem.match_percentage : ''}% ・ 1 докупить` }}
        </span>
        <span v-else-if="matchItem" class="match-pill match-partial">
          {{ matchItem.match_percentage }}%
        </span>

        <span
          v-if="savingIngredients && savingIngredients.length > 0"
          class="saving-pill"
        >
          🔥 Спасает {{ savingIngredients[0].name }}
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
      <h3 class="card-title">{{ recipe.title }}</h3>

      <div class="card-meta">
        <span class="meta-item">
          <van-icon name="clock-o" size="14" />
          {{ recipe.cooking_time_minutes }} мин
        </span>
        <span class="meta-divider">•</span>
        <span class="meta-item difficulty-tag" :class="difficultyClass">
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
  transition: transform 0.15s ease, box-shadow 0.15s ease, border-color 0.15s ease;
  user-select: none;
  border: 2px solid transparent;
}

.recipe-card:active {
  transform: scale(0.98);
}

.card-ready {
  border: 2px solid #1E392A;
  box-shadow: 0 4px 16px rgba(30, 57, 42, 0.12);
}

.card-almost {
  border: 1.5px solid #F39C12;
}

.card-media {
  position: relative;
  width: 100%;
  height: 180px;
  background-color: #f0f0f0;
}

.card-img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  display: block;
}

.placeholder-cat {
  font-size: 11px;
  font-weight: 600;
  color: #78909c;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.placeholder-img {
  display: flex;
  align-items: center;
  justify-content: center;
  background-color: #eceff1;
}

.badge-overlay {
  position: absolute;
  top: 10px;
  left: 10px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: flex-start;
  z-index: 2;
}

.match-pill {
  font-size: 12px;
  font-weight: 700;
  padding: 4px 10px;
  border-radius: 12px;
  color: #ffffff;
  box-shadow: 0 2px 6px rgba(0, 0, 0, 0.15);
}

.match-ready {
  background: linear-gradient(135deg, #1E392A 0%, #2D5A43 100%);
  color: #ffffff;
  font-weight: 700;
}

.match-almost {
  background: #FEF9E7;
  color: #B7950B;
  font-weight: 600;
  border: 1px solid #F9E79F;
}

.match-partial {
  background: rgba(0, 0, 0, 0.65);
  color: #ffffff;
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
