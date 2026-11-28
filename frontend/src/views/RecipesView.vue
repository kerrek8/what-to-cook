<script setup lang="ts">
import { onMounted, onUnmounted, ref, watch, nextTick } from 'vue'
import { useRecipeStore, type CookingTimeFilter } from '@/stores/recipe'
import { useInventoryStore } from '@/stores/inventory'
import { useAuthStore } from '@/stores/auth'
import RecipeCard from '@/components/recipes/RecipeCard.vue'
import { Search, X, Flame, BookOpen, Heart, ChefHat, RefreshCw } from 'lucide-vue-next'

const recipeStore = useRecipeStore()
const inventoryStore = useInventoryStore()
const authStore = useAuthStore()

const scrollContainer = ref<HTMLElement | null>(null)
const sentinelRef = ref<HTMLElement | null>(null)
let observer: IntersectionObserver | null = null

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
  if (scrollContainer.value) {
    scrollContainer.value.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function checkInfiniteScroll() {
  if (recipeStore.activeTab !== 'all') return
  const el = scrollContainer.value || document.documentElement
  const scrollTop = el.scrollTop || window.scrollY || 0
  const scrollHeight = el.scrollHeight || document.documentElement.scrollHeight
  const clientHeight = el.clientHeight || window.innerHeight

  if (scrollHeight - scrollTop - clientHeight < 500) {
    if (recipeStore.hasMoreRecipes && !recipeStore.isAllRecipesLoading) {
      recipeStore.loadAllRecipes(recipeStore.page + 1, true)
    }
  }
}

function setupObserver() {
  if (typeof IntersectionObserver === 'undefined') return
  if (observer) {
    observer.disconnect()
  }

  observer = new IntersectionObserver(
    (entries) => {
      const [entry] = entries
      if (entry && entry.isIntersecting) {
        if (
          recipeStore.activeTab === 'all' &&
          recipeStore.hasMoreRecipes &&
          !recipeStore.isAllRecipesLoading
        ) {
          recipeStore.loadAllRecipes(recipeStore.page + 1, true)
        }
      }
    },
    {
      root: null,
      rootMargin: '400px',
      threshold: 0.05
    }
  )

  if (sentinelRef.value) {
    observer.observe(sentinelRef.value)
  }
}

watch(sentinelRef, () => {
  if (sentinelRef.value && recipeStore.activeTab === 'all') {
    setupObserver()
  }
})

watch(
  () => recipeStore.activeTab,
  async (tab) => {
    if (tab !== 'match') {
      recipeStore.saveExpiringOnly = false
    } else {
      await recipeStore.loadMatchedRecipes()
    }
    if (tab === 'all') {
      if (recipeStore.allRecipes.length === 0) {
        await recipeStore.loadAllRecipes(1, false)
      }
      await nextTick()
      setupObserver()
    }
  }
)

let searchDebounceTimer: ReturnType<typeof setTimeout> | undefined

watch(
  [() => recipeStore.searchQuery, () => recipeStore.difficultyFilter, () => recipeStore.timeFilter],
  () => {
    if (recipeStore.activeTab !== 'all') return
    if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
    searchDebounceTimer = setTimeout(async () => {
      recipeStore.allRecipes = []
      await recipeStore.loadAllRecipes(1, false)
      scrollToTop()
      await nextTick()
      setupObserver()
    }, 400)
  }
)

async function resetAllFilters() {
  recipeStore.searchQuery = ''
  recipeStore.timeFilter = 0
  recipeStore.difficultyFilter = 'all'
  recipeStore.saveExpiringOnly = false
  recipeStore.allRecipes = []
  await recipeStore.loadAllRecipes(1, false)
  scrollToTop()
  await nextTick()
  setupObserver()
}

onMounted(async () => {
  scrollContainer.value = document.querySelector('.content-wrapper') as HTMLElement
  scrollContainer.value?.addEventListener('scroll', checkInfiniteScroll, { passive: true })
  window.addEventListener('scroll', checkInfiniteScroll, { passive: true })

  if (inventoryStore.items.length === 0) {
    inventoryStore.loadInventory()
  }
  await Promise.all([
    recipeStore.loadMatchedRecipes(),
    recipeStore.loadAllRecipes(1, false),
    recipeStore.loadFavorites()
  ])

  await nextTick()
  setupObserver()
})

onUnmounted(() => {
  if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
  scrollContainer.value?.removeEventListener('scroll', checkInfiniteScroll)
  window.removeEventListener('scroll', checkInfiniteScroll)
  if (observer) {
    observer.disconnect()
    observer = null
  }
})

const timeOptions: Array<{ label: string; value: CookingTimeFilter }> = [
  { label: 'Любое время', value: 0 },
  { label: '≤ 15 мин', value: 15 },
  { label: 'До 30 мин', value: 30 },
  { label: 'До 1 часа', value: 60 },
  { label: '> 1 часа', value: 61 }
]

const difficultyOptions: Array<{ label: string; value: string }> = [
  { label: 'Любая сложность', value: 'all' },
  { label: 'Легко', value: 'легко' },
  { label: 'Средне', value: 'средне' },
  { label: 'Сложно', value: 'сложно' }
]
</script>

<template>
  <div class="min-h-full pb-20 flex flex-col">
    <!-- Sticky Search & Tabs Header -->
    <div class="sticky top-0 z-30 bg-white/95 backdrop-blur-md border-b border-slate-200/80 px-4 pt-3 pb-2 flex flex-col gap-2.5 shadow-xs">
      <!-- Search Bar -->
      <div class="relative flex items-center">
        <Search class="absolute left-3.5 w-4 h-4 text-slate-400 pointer-events-none stroke-[2.2px]" />
        <input
          v-model="recipeStore.searchQuery"
          type="text"
          placeholder="Поиск рецептов по названию или ингредиенту..."
          class="w-full pl-10 pr-9 py-2.5 bg-slate-50 border border-slate-200 rounded-2xl text-sm placeholder:text-slate-400 focus:outline-none focus:ring-2 focus:ring-emerald-700/20 focus:border-emerald-700 focus:bg-white transition-all"
        />
        <button
          v-if="recipeStore.searchQuery"
          type="button"
          class="absolute right-3 p-1 text-slate-400 hover:text-slate-600 rounded-full"
          aria-label="Очистить поиск"
          @click="recipeStore.searchQuery = ''"
        >
          <X class="w-4 h-4" />
        </button>
      </div>

      <!-- Segmented Control Tabs (Подбор / Каталог / Избранное) -->
      <div class="grid grid-cols-3 p-1 bg-slate-100/90 rounded-2xl border border-slate-200/60 text-xs font-semibold">
        <button
          type="button"
          class="py-2 px-2 rounded-xl flex items-center justify-center gap-1.5 transition-all"
          :class="recipeStore.activeTab === 'match' ? 'bg-white text-emerald-950 shadow-xs' : 'text-slate-500 hover:text-slate-700'"
          @click="recipeStore.activeTab = 'match'"
        >
          <Flame class="w-3.5 h-3.5" :class="recipeStore.activeTab === 'match' ? 'text-emerald-800' : 'text-slate-400'" />
          <span class="truncate">Подбор</span>
          <span
            v-if="recipeStore.filteredMatchedRecipes.length > 0"
            class="px-1.5 py-0.2 rounded-full text-[10px] font-bold"
            :class="recipeStore.activeTab === 'match' ? 'bg-emerald-950 text-white' : 'bg-slate-200 text-slate-600'"
          >
            {{ recipeStore.filteredMatchedRecipes.length }}
          </span>
        </button>

        <button
          type="button"
          class="py-2 px-2 rounded-xl flex items-center justify-center gap-1.5 transition-all"
          :class="recipeStore.activeTab === 'all' ? 'bg-white text-emerald-950 shadow-xs' : 'text-slate-500 hover:text-slate-700'"
          @click="recipeStore.activeTab = 'all'"
        >
          <BookOpen class="w-3.5 h-3.5" :class="recipeStore.activeTab === 'all' ? 'text-emerald-800' : 'text-slate-400'" />
          <span class="truncate">Каталог</span>
        </button>

        <button
          type="button"
          class="py-2 px-2 rounded-xl flex items-center justify-center gap-1.5 transition-all"
          :class="recipeStore.activeTab === 'favorites' ? 'bg-white text-emerald-950 shadow-xs' : 'text-slate-500 hover:text-slate-700'"
          @click="recipeStore.activeTab = 'favorites'"
        >
          <Heart class="w-3.5 h-3.5" :class="recipeStore.activeTab === 'favorites' ? 'text-rose-600 fill-rose-600' : 'text-slate-400'" />
          <span class="truncate">Избранное</span>
          <span
            v-if="recipeStore.favoriteRecipes.length > 0"
            class="px-1.5 py-0.2 rounded-full text-[10px] font-bold"
            :class="recipeStore.activeTab === 'favorites' ? 'bg-rose-600 text-white' : 'bg-slate-200 text-slate-600'"
          >
            {{ recipeStore.favoriteRecipes.length }}
          </span>
        </button>
      </div>

      <!-- Horizontal Filter Chips (Время / Сложность / Спасает) -->
      <div class="flex items-center gap-1.5 overflow-x-auto no-scrollbar -mx-4 px-4 py-0.5">
        <!-- Save Expiring Products Filter (Only in Match tab) -->
        <button
          v-if="recipeStore.activeTab === 'match'"
          type="button"
          class="shrink-0 flex items-center gap-1 px-3 py-1.5 rounded-xl text-xs font-semibold border transition-all"
          :class="recipeStore.saveExpiringOnly ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-amber-50 text-amber-900 border-amber-200 hover:bg-amber-100'"
          @click="recipeStore.saveExpiringOnly = !recipeStore.saveExpiringOnly"
        >
          <span>🔥 Спасает продукты</span>
        </button>

        <!-- Time Filters -->
        <button
          v-for="opt in timeOptions"
          :key="opt.value"
          type="button"
          class="shrink-0 px-3 py-1.5 rounded-xl text-xs font-semibold border transition-all whitespace-nowrap"
          :class="recipeStore.timeFilter === opt.value ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'"
          @click="recipeStore.timeFilter = opt.value"
        >
          {{ opt.label }}
        </button>

        <!-- Difficulty Filters -->
        <button
          v-for="diff in difficultyOptions"
          :key="diff.value"
          type="button"
          class="shrink-0 px-3 py-1.5 rounded-xl text-xs font-semibold border transition-all whitespace-nowrap"
          :class="recipeStore.difficultyFilter === diff.value ? 'bg-emerald-950 text-white border-emerald-950' : 'bg-white text-slate-600 border-slate-200 hover:bg-slate-50'"
          @click="recipeStore.difficultyFilter = diff.value"
        >
          {{ diff.label }}
        </button>
      </div>
    </div>

    <!-- Tab 1: Match ("Подбор") Content -->
    <div v-if="recipeStore.activeTab === 'match'" class="p-4 flex flex-col gap-3">
      <!-- Loading Skeletons -->
      <div v-if="recipeStore.isMatching" class="flex flex-col gap-3">
        <div v-for="n in 3" :key="n" class="h-64 rounded-3xl bg-slate-100 animate-pulse border border-slate-200" />
      </div>

      <!-- Matched Recipe Cards -->
      <template v-else-if="recipeStore.filteredMatchedRecipes.length > 0">
        <RecipeCard
          v-for="item in recipeStore.filteredMatchedRecipes"
          :key="item.recipe.id"
          :recipe="item.recipe"
          :match-item="item"
          :saving-ingredients="recipeStore.getSavingIngredients(item.recipe.ingredients)"
        />
      </template>

      <!-- Empty State -->
      <div v-else class="py-16 text-center flex flex-col items-center">
        <div class="w-16 h-16 rounded-3xl bg-emerald-50 text-emerald-800 border border-emerald-100 shadow-xs flex items-center justify-center mb-4">
          <ChefHat class="w-8 h-8 stroke-[1.8px]" />
        </div>
        <h3 class="text-base font-bold text-slate-900 mb-1">Нет подходящих рецептов</h3>
        <p class="text-xs text-slate-500 max-w-xs mb-5">
          Добавьте больше продуктов в холодильник или сбросьте фильтры времени и сложности.
        </p>
        <button
          type="button"
          class="py-2.5 px-5 rounded-2xl bg-emerald-950 text-white text-sm font-semibold flex items-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/15"
          @click="resetAllFilters"
        >
          Сбросить фильтры
        </button>
      </div>
    </div>

    <!-- Tab 2: Catalog ("Все рецепты") Content with Infinite Scroll -->
    <div v-else-if="recipeStore.activeTab === 'all'" class="p-4 flex flex-col gap-3">
      <!-- Initial Loading Skeletons -->
      <div v-if="recipeStore.isAllRecipesLoading && recipeStore.allRecipes.length === 0" class="flex flex-col gap-3">
        <div v-for="n in 3" :key="n" class="h-64 rounded-3xl bg-slate-100 animate-pulse border border-slate-200" />
      </div>

      <template v-else-if="recipeStore.allRecipes.length > 0">
        <RecipeCard
          v-for="recipe in recipeStore.allRecipes"
          :key="recipe.id"
          :recipe="recipe"
        />

        <!-- Infinite Scroll Sentinel -->
        <div ref="sentinelRef" class="py-4 flex justify-center items-center">
          <div v-if="recipeStore.isAllRecipesLoading" class="flex items-center gap-2 text-xs font-semibold text-slate-500">
            <RefreshCw class="w-4 h-4 animate-spin text-emerald-800" />
            <span>Загрузка рецептов...</span>
          </div>
          <p v-else-if="!recipeStore.hasMoreRecipes" class="text-xs text-slate-400 font-medium py-2">
            Все рецепты каталога загружены ({{ recipeStore.allRecipes.length }})
          </p>
        </div>
      </template>

      <!-- Empty State -->
      <div v-else class="py-16 text-center flex flex-col items-center">
        <div class="w-16 h-16 rounded-3xl bg-emerald-50 text-emerald-800 border border-emerald-100 shadow-xs flex items-center justify-center mb-4">
          <BookOpen class="w-8 h-8 stroke-[1.8px]" />
        </div>
        <h3 class="text-base font-bold text-slate-900 mb-1">Рецепты не найдены</h3>
        <p class="text-xs text-slate-500 max-w-xs mb-5">
          По запросу "{{ recipeStore.searchQuery }}" ничего не найдено.
        </p>
        <button
          type="button"
          class="py-2.5 px-5 rounded-2xl bg-emerald-950 text-white text-sm font-semibold flex items-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/15"
          @click="resetAllFilters"
        >
          Сбросить поиск
        </button>
      </div>
    </div>

    <!-- Tab 3: Favorites Content -->
    <div v-else-if="recipeStore.activeTab === 'favorites'" class="p-4 flex flex-col gap-3">
      <template v-if="recipeStore.favoriteRecipes.length > 0">
        <RecipeCard
          v-for="recipe in recipeStore.favoriteRecipes"
          :key="recipe.id"
          :recipe="recipe"
        />
      </template>

      <!-- Empty Favorites -->
      <div v-else class="py-16 text-center flex flex-col items-center">
        <div class="w-16 h-16 rounded-3xl bg-rose-50 text-rose-600 border border-rose-100 shadow-xs flex items-center justify-center mb-4">
          <Heart class="w-8 h-8 stroke-[1.8px]" />
        </div>
        <h3 class="text-base font-bold text-slate-900 mb-1">Нет сохраненных рецептов</h3>
        <p class="text-xs text-slate-500 max-w-xs mb-5">
          Нажмите на сердечко в любом рецепте, чтобы сохранить его в избранное для быстрой готовки.
        </p>
        <button
          type="button"
          class="py-2.5 px-5 rounded-2xl bg-emerald-950 text-white text-sm font-semibold flex items-center gap-2 hover:bg-emerald-900 active:scale-98 transition-all shadow-md shadow-emerald-950/15"
          @click="recipeStore.activeTab = 'all'"
        >
          Перейти в каталог
        </button>
      </div>
    </div>
  </div>
</template>
