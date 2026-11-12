<script setup lang="ts">
import { computed, ref, watch } from 'vue'
import { useRouter } from 'vue-router'
import { Clock, ChefHat, Heart } from 'lucide-vue-next'
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
        <ChefHat :size="36" class="placeholder-icon" />
        <span class="placeholder-cat">{{ recipe.description || 'Рецепт' }}</span>
      </div>

      <!-- Bottom gradient scrim -->
      <div class="media-scrim" />

      <!-- Top-left glassmorphic badges -->
      <div class="badge-overlay">
        <!-- Ready: 100% -->
        <span
          v-if="readinessTier === 'ready'"
          class="backdrop-blur-md bg-emerald-950/80 border border-emerald-400/40 text-emerald-100 font-semibold px-3 py-1 rounded-full text-xs shadow-sm flex items-center gap-1.5"
        >
          <span class="glow-dot bg-emerald-400 shadow-[0_0_6px_rgba(52,211,153,0.8)]" />
          <span>Можно готовить</span>
        </span>

        <!-- Almost Ready: 1 to buy -->
        <span
          v-else-if="readinessTier === 'almost'"
          class="backdrop-blur-md bg-amber-950/80 border border-amber-400/40 text-amber-200 font-semibold px-3 py-1 rounded-full text-xs shadow-sm flex items-center gap-1.5"
        >
          <span class="glow-dot bg-amber-400 shadow-[0_0_6px_rgba(251,191,36,0.8)]" />
          <span>{{ matchItem && matchItem.missing_ingredients && matchItem.missing_ingredients.length === 1 ? `Купить: ${matchItem.missing_ingredients[0].name}` : `${matchItem ? matchItem.match_percentage + '% • 1 докупить' : '1 докупить'}` }}</span>
        </span>

        <!-- Partial Match Percentage -->
        <span
          v-else-if="matchItem"
          class="backdrop-blur-md bg-stone-900/65 border border-white/20 text-white font-medium px-2.5 py-1 rounded-full text-xs flex items-center gap-1"
        >
          {{ matchItem.match_percentage }}%
        </span>

        <!-- Saving Expiring Ingredients -->
        <span
          v-if="savingIngredients && savingIngredients.length > 0"
          class="backdrop-blur-md bg-rose-950/80 border border-rose-400/40 text-rose-100 font-semibold px-2.5 py-1 rounded-full text-xs shadow-sm flex items-center gap-1.5"
        >
          🔥 Спасает {{ savingIngredients[0].name }}
        </span>
      </div>

      <!-- Top-right floating favorite glass button -->
      <button
        type="button"
        class="fav-btn"
        :class="{ active: recipe.is_favorite }"
        :aria-label="recipe.is_favorite ? 'Удалить из избранного' : 'Добавить в избранное'"
        @click="onFavoriteClick"
      >
        <Heart
          :size="18"
          :class="recipe.is_favorite ? 'heart-active' : 'heart-idle'"
        />
      </button>
    </div>

    <div class="card-body">
      <h3 class="card-title">{{ recipe.title }}</h3>

      <div class="card-meta">
        <span class="meta-item">
          <Clock :size="14" class="meta-icon" />
          <span>{{ recipe.cooking_time_minutes }} мин</span>
        </span>
        <span class="meta-divider">•</span>
        <span class="meta-item difficulty-tag" :class="difficultyClass">
          <ChefHat :size="14" class="meta-icon" />
          <span>{{ difficultyLabel }}</span>
        </span>
        <template v-if="matchItem">
          <span class="meta-divider">•</span>
          <span class="meta-item ingredients-count">
            {{ matchItem.available_count }}/{{ matchItem.total_ingredients }} инг.
          </span>
        </template>
      </div>

      <!-- Missing ingredients badge -->
      <div v-if="missingPreview" class="missing-badge">
        <span class="missing-label">Купить:</span>
        <span class="missing-names">
          {{ missingPreview }}<template v-if="matchItem && matchItem.missing_ingredients.length > 2"> +{{ matchItem.missing_ingredients.length - 2 }}</template>
        </span>
      </div>
    </div>
  </div>
</template>

<style scoped>
.recipe-card {
  background-color: #ffffff;
  border-radius: 20px;
  overflow: hidden;
  box-shadow: 0 4px 20px -2px rgba(30, 58, 47, 0.06), 0 2px 6px -1px rgba(30, 58, 47, 0.04);
  border: 1px solid rgba(30, 58, 47, 0.05);
  margin-bottom: 14px;
  display: flex;
  flex-direction: column;
  cursor: pointer;
  transition: transform 0.2s cubic-bezier(0.16, 1, 0.3, 1), box-shadow 0.2s cubic-bezier(0.16, 1, 0.3, 1), border-color 0.2s ease;
  user-select: none;
}

.recipe-card:active {
  transform: scale(0.985);
}

.card-ready {
  border-color: rgba(30, 58, 47, 0.28);
  box-shadow: 0 6px 24px -2px rgba(30, 58, 47, 0.12), 0 2px 8px -1px rgba(30, 58, 47, 0.06);
}

.card-almost {
  border-color: rgba(232, 168, 124, 0.45);
}

.card-media {
  position: relative;
  width: 100%;
  aspect-ratio: 16 / 9;
  background-color: #f5f2eb;
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
  flex-direction: column;
  align-items: center;
  justify-content: center;
  gap: 8px;
  background: linear-gradient(135deg, #FAF8F5 0%, #EFEAE1 100%);
}

.placeholder-icon {
  color: #a8a29e;
}

.placeholder-cat {
  font-size: 11px;
  font-weight: 600;
  color: #78716c;
  text-transform: uppercase;
  letter-spacing: 0.5px;
  max-width: 80%;
  text-align: center;
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}

.media-scrim {
  position: absolute;
  inset: 0;
  background: linear-gradient(to top, rgba(0, 0, 0, 0.55) 0%, rgba(0, 0, 0, 0.1) 40%, transparent 60%);
  pointer-events: none;
}

.badge-overlay {
  position: absolute;
  top: 12px;
  left: 12px;
  display: flex;
  flex-direction: column;
  gap: 6px;
  align-items: flex-start;
  z-index: 2;
  max-width: calc(100% - 64px);
}

.glow-dot {
  width: 6px;
  height: 6px;
  border-radius: 9999px;
  flex-shrink: 0;
}

.fav-btn {
  position: absolute;
  top: 12px;
  right: 12px;
  width: 36px;
  height: 36px;
  border-radius: 9999px;
  background-color: rgba(0, 0, 0, 0.3);
  backdrop-filter: blur(12px);
  -webkit-backdrop-filter: blur(12px);
  border: 1px solid rgba(255, 255, 255, 0.2);
  display: flex;
  align-items: center;
  justify-content: center;
  cursor: pointer;
  z-index: 3;
  transition: transform 0.15s ease, background-color 0.15s ease;
}

.fav-btn:hover {
  background-color: rgba(0, 0, 0, 0.5);
}

.fav-btn:active {
  transform: scale(0.9);
}

.heart-active {
  color: #ef4444;
  fill: #ef4444;
}

.heart-idle {
  color: rgba(255, 255, 255, 0.95);
  stroke-width: 2.2;
}

.card-body {
  padding: 14px 16px 16px;
  display: flex;
  flex-direction: column;
}

.card-title {
  margin: 0 0 8px 0;
  font-size: 17px;
  font-weight: 600;
  color: #1c1917;
  line-height: 1.35;
  letter-spacing: -0.01em;
  display: -webkit-box;
  -webkit-line-clamp: 2;
  -webkit-box-orient: vertical;
  overflow: hidden;
}

.card-meta {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 12px;
  color: #78716C;
  font-weight: 500;
}

.meta-item {
  display: inline-flex;
  align-items: center;
  gap: 4px;
}

.meta-icon {
  flex-shrink: 0;
  color: #a8a29e;
}

.meta-divider {
  color: #d6d3d1;
}

.difficulty-tag.easy {
  color: #15803d;
}
.difficulty-tag.easy .meta-icon {
  color: #15803d;
}

.difficulty-tag.medium {
  color: #b45309;
}
.difficulty-tag.medium .meta-icon {
  color: #b45309;
}

.difficulty-tag.hard {
  color: #be123c;
}
.difficulty-tag.hard .meta-icon {
  color: #be123c;
}

.ingredients-count {
  color: #78716C;
}

.missing-badge {
  background-color: rgba(254, 243, 199, 0.7);
  border: 1px solid rgba(251, 191, 36, 0.5);
  border-radius: 12px;
  padding: 6px 12px;
  font-size: 12px;
  color: #78350f;
  margin-top: 10px;
  display: flex;
  align-items: center;
  gap: 6px;
}

.missing-label {
  font-weight: 600;
  color: #92400e;
  flex-shrink: 0;
}

.missing-names {
  overflow: hidden;
  text-overflow: ellipsis;
  white-space: nowrap;
}
</style>
