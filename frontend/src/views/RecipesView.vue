<script setup lang="ts">
import { onMounted, onUnmounted, ref, watch } from 'vue'
import { useVirtualizer } from '@tanstack/vue-virtual'
import { useRecipeStore, type CookingTimeFilter } from '@/stores/recipe'
import { useInventoryStore } from '@/stores/inventory'
import { useAuthStore } from '@/stores/auth'
import RecipeCard from '@/components/recipes/RecipeCard.vue'

const recipeStore = useRecipeStore()
const inventoryStore = useInventoryStore()
const authStore = useAuthStore()

const scrollContainer = ref<HTMLElement | null>(null)

const matchVirtualizer = useVirtualizer({
  get count() {
    return recipeStore.filteredMatchedRecipes.length
  },
  getScrollElement: () => scrollContainer.value,
  estimateSize: () => 360,
  overscan: 3
})

const rowVirtualizer = useVirtualizer({
  get count() {
    return recipeStore.allRecipes.length
  },
  getScrollElement: () => scrollContainer.value,
  estimateSize: () => 360,
  overscan: 3
})

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
  if (scrollContainer.value) {
    scrollContainer.value.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function checkInfiniteScroll() {
  if (recipeStore.activeTab !== 'all') return
  const virtualItems = rowVirtualizer.value.getVirtualItems()
  if (!virtualItems || virtualItems.length === 0) return
  const lastItem = virtualItems[virtualItems.length - 1]
  if (
    lastItem.index >= recipeStore.allRecipes.length - 2 &&
    recipeStore.hasMoreRecipes &&
    !recipeStore.isAllRecipesLoading
  ) {
    recipeStore.loadAllRecipes(recipeStore.page + 1, true)
  }
}

watch(
  () => rowVirtualizer.value.getVirtualItems(),
  () => {
    checkInfiniteScroll()
  }
)

watch(
  () => recipeStore.activeTab,
  async (tab) => {
    if (tab !== 'match') {
      recipeStore.saveExpiringOnly = false
    }
    if (tab === 'all' && recipeStore.allRecipes.length === 0) {
      await recipeStore.loadAllRecipes(1, false)
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
}

onUnmounted(() => {
  if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
  scrollContainer.value?.removeEventListener('scroll', checkInfiniteScroll)
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

onMounted(async () => {
  scrollContainer.value = document.querySelector('.content-wrapper') as HTMLElement
  scrollContainer.value?.addEventListener('scroll', checkInfiniteScroll, { passive: true })

  if (inventoryStore.items.length === 0) {
    inventoryStore.loadInventory()
  }
  await Promise.all([
    recipeStore.loadMatchedRecipes(),
    recipeStore.loadAllRecipes(1, false),
    recipeStore.loadFavorites()
  ])
})
</script>

<template>
  <div class="recipes-view">
    <!-- Search Bar -->
    <div class="search-header">
      <van-search
        v-model="recipeStore.searchQuery"
        placeholder="Поиск рецептов..."
        shape="round"
        clearable
      />
    </div>

    <!-- Navigation Tabs (Segmented Control) -->
    <div class="tabs-wrapper">
      <div class="tabs-segmented">
        <button
          type="button"
          class="tab-btn"
          :class="{ active: recipeStore.activeTab === 'match' }"
          @click="recipeStore.activeTab = 'match'"
        >
          <span class="tab-title">Подбор</span>
          <span
            v-if="recipeStore.filteredMatchedRecipes.length > 0"
            class="count-badge"
            :class="recipeStore.activeTab === 'match' ? 'badge-match-active' : 'badge-inactive'"
          >
            {{ recipeStore.filteredMatchedRecipes.length }}
          </span>
        </button>

        <button
          type="button"
          class="tab-btn"
          :class="{ active: recipeStore.activeTab === 'all' }"
          @click="recipeStore.activeTab = 'all'"
        >
          <span class="tab-title">Все рецепты</span>
          <span
            v-if="recipeStore.totalCount > 0"
            class="count-badge"
            :class="recipeStore.activeTab === 'all' ? 'badge-all-active' : 'badge-inactive'"
          >
            {{ recipeStore.totalCount }}
          </span>
        </button>

        <button
          type="button"
          class="tab-btn"
          :class="{ active: recipeStore.activeTab === 'favorites' }"
          @click="recipeStore.activeTab = 'favorites'; recipeStore.loadFavorites()"
        >
          <span class="tab-title">Избранное</span>
          <span
            v-if="recipeStore.favoriteRecipes.length > 0"
            class="count-badge"
            :class="recipeStore.activeTab === 'favorites' ? 'badge-fav-active' : 'badge-inactive'"
          >
            {{ recipeStore.favoriteRecipes.length }}
          </span>
        </button>
      </div>
    </div>

    <!-- Filter Chips Scroll -->
    <div class="filters-scroll">
      <!-- Expiring Toggle Chip (только для вкладки "Что приготовить") -->
      <button
        v-if="recipeStore.activeTab === 'match'"
        type="button"
        class="filter-chip expiring-toggle"
        :class="{ active: recipeStore.saveExpiringOnly }"
        @click="recipeStore.saveExpiringOnly = !recipeStore.saveExpiringOnly"
      >
        <span>🔥 Спасает продукты</span>
      </button>

      <!-- Time Filter Chips -->
      <button
        v-for="opt in timeOptions"
        :key="opt.value"
        type="button"
        class="filter-chip"
        :class="{ active: recipeStore.timeFilter === opt.value }"
        @click="recipeStore.timeFilter = opt.value"
      >
        {{ opt.label }}
      </button>

      <!-- Difficulty Filter Chips -->
      <button
        v-for="opt in difficultyOptions"
        :key="opt.value"
        type="button"
        class="filter-chip"
        :class="{ active: recipeStore.difficultyFilter === opt.value }"
        @click="recipeStore.difficultyFilter = opt.value"
      >
        {{ opt.label }}
      </button>
    </div>

    <!-- Tab: Smart Match -->
    <template v-if="recipeStore.activeTab === 'match'">
      <div
        v-if="recipeStore.isMatching && recipeStore.allRecipes.length === 0"
        class="loading-skeletons"
      >
        <van-skeleton title avatar :row="3" class="skeleton-card" />
        <van-skeleton title avatar :row="3" class="skeleton-card" />
      </div>

      <template v-else-if="recipeStore.filteredMatchedRecipes.length > 0">
        <div v-if="authStore.user?.excludedIngredientIds?.length" class="px-4 pt-1 pb-2">
          <div class="allergen-note">
            <van-icon name="shield-o" size="16" />
            <span>Рецепты с выбранным в профиле аллергеном исключены из подбора</span>
          </div>
        </div>

        <div class="relative w-full" :style="{ height: `${matchVirtualizer.getTotalSize()}px` }">
          <div
            v-for="virtualRow in matchVirtualizer.getVirtualItems()"
            :key="virtualRow.key as number | string"
            :ref="(el) => matchVirtualizer.measureElement(el as HTMLElement | null)"
            :data-index="virtualRow.index"
            class="absolute top-0 left-0 w-full px-4 pb-3"
            :style="{ transform: `translateY(${virtualRow.start}px)` }"
          >
            <RecipeCard
              v-if="recipeStore.filteredMatchedRecipes[virtualRow.index]"
              :recipe="recipeStore.filteredMatchedRecipes[virtualRow.index].recipe"
              :match-item="recipeStore.filteredMatchedRecipes[virtualRow.index]"
              :saving-ingredients="recipeStore.getSavingIngredients(recipeStore.filteredMatchedRecipes[virtualRow.index]?.recipe.ingredients)"
            />
          </div>
        </div>
      </template>

      <!-- Состояние: фильтр "Спасает продукты" активен, но в холодильнике нет истекающих продуктов -->
      <div
        v-else-if="recipeStore.saveExpiringOnly && recipeStore.expiringItems.length === 0"
        class="empty-state"
      >
        <van-empty
          image="search"
          description="В вашем холодильнике нет продуктов с истекающим сроком годности. Все продукты свежие!"
        >
          <router-link to="/fridge">
            <van-button round type="primary" color="#1E3A2F" class="action-btn">
              Перейти в холодильник
            </van-button>
          </router-link>
          <van-button
            round
            plain
            class="action-btn"
            style="margin-top: 10px;"
            @click="recipeStore.saveExpiringOnly = false"
          >
            Сбросить фильтр
          </van-button>
        </van-empty>
      </div>

      <!-- Состояние: фильтр "Спасает продукты" активен, но рецепты с ними не подобрались -->
      <div
        v-else-if="recipeStore.saveExpiringOnly && recipeStore.filteredMatchedRecipes.length === 0"
        class="empty-state"
      >
        <van-empty
          image="search"
          description="Не найдено рецептов с продуктами, требующими срочного использования."
        >
          <van-button
            round
            plain
            class="action-btn"
            @click="recipeStore.saveExpiringOnly = false"
          >
            Сбросить фильтр
          </van-button>
        </van-empty>
      </div>

      <div v-else-if="recipeStore.filteredAllRecipes.length > 0" class="recipes-list suggestions-fallback">
        <div class="fallback-note">
          <van-icon name="info-o" size="18" />
          <span>Пока нет рецептов, которые можно приготовить только из продуктов в холодильнике. Вот подходящие варианты:</span>
        </div>
        <RecipeCard
          v-for="r in recipeStore.visibleAllRecipes"
          :key="r.id"
          :recipe="r"
          :saving-ingredients="recipeStore.getSavingIngredients(r.ingredients)"
        />
      </div>

      <div v-else class="empty-state">
        <van-empty
          image="search"
          description="В каталоге пока нет рецептов. Попробуйте обновить список позже."
        >
          <router-link v-if="inventoryStore.items.length === 0" to="/fridge">
            <van-button round type="primary" color="#1E3A2F" class="action-btn">
              Заполнить холодильник
            </van-button>
          </router-link>
          <van-button
            v-if="recipeStore.searchQuery || recipeStore.timeFilter || recipeStore.difficultyFilter !== 'all' || recipeStore.saveExpiringOnly"
            round
            plain
            class="action-btn"
            @click="
              recipeStore.searchQuery = '';
              recipeStore.timeFilter = 0;
              recipeStore.difficultyFilter = 'all';
              recipeStore.saveExpiringOnly = false;
            "
          >
            Сбросить фильтры
          </van-button>
        </van-empty>
      </div>
    </template>

    <!-- Tab: All Recipes -->
    <template v-else-if="recipeStore.activeTab === 'all'">
      <div v-if="recipeStore.isLoading && recipeStore.allRecipes.length === 0" class="loading-skeletons">
        <van-skeleton title avatar :row="3" class="skeleton-card" />
        <van-skeleton title avatar :row="3" class="skeleton-card" />
      </div>

      <template v-else-if="recipeStore.allRecipes.length > 0">
        <div
          class="relative w-full"
          :style="{ height: `${rowVirtualizer.getTotalSize()}px` }"
        >
          <div
            v-for="virtualRow in rowVirtualizer.getVirtualItems()"
            :key="virtualRow.key as number | string"
            :ref="(el) => rowVirtualizer.measureElement(el as HTMLElement | null)"
            :data-index="virtualRow.index"
            class="absolute top-0 left-0 w-full px-4 pb-3"
            :style="{ transform: `translateY(${virtualRow.start}px)` }"
          >
            <RecipeCard
              v-if="recipeStore.allRecipes[virtualRow.index]"
              :recipe="recipeStore.allRecipes[virtualRow.index]"
              :saving-ingredients="recipeStore.getSavingIngredients(recipeStore.allRecipes[virtualRow.index]?.ingredients)"
            />
          </div>
        </div>

        <div v-if="recipeStore.isAllRecipesLoading" class="loading-more py-3 text-center">
          <van-loading size="20px" color="#1E3A2F">Загрузка рецептов...</van-loading>
        </div>
      </template>

      <div v-if="!recipeStore.isLoading && recipeStore.allRecipes.length === 0" class="empty-state">
        <van-empty image="search" description="Рецепты не найдены">
          <van-button
            round
            plain
            class="action-btn"
            @click="resetAllFilters"
          >
            Сбросить фильтры
          </van-button>
        </van-empty>
      </div>
    </template>

    <!-- Tab: Favorites -->
    <template v-else-if="recipeStore.activeTab === 'favorites'">
      <div v-if="recipeStore.isFavoritesLoading" class="loading-skeletons">
        <van-skeleton title avatar :row="3" class="skeleton-card" />
        <van-skeleton title avatar :row="3" class="skeleton-card" />
      </div>

      <div v-else-if="recipeStore.favoriteRecipes.length > 0" class="recipes-list">
        <RecipeCard
          v-for="r in recipeStore.favoriteRecipes"
          :key="r.id"
          :recipe="r"
          :saving-ingredients="recipeStore.getSavingIngredients(r.ingredients)"
        />
      </div>

      <div v-else-if="!recipeStore.isFavoritesLoading" class="empty-state">
        <van-empty
          image="default"
          description="У вас пока нет сохраненных рецептов. Нажмите на сердечко на карточке рецепта, чтобы добавить его сюда."
        >
          <van-button
            round
            type="primary"
            color="#1E3A2F"
            class="action-btn"
            @click="recipeStore.activeTab = 'all'"
          >
            Смотреть каталог рецептов
          </van-button>
        </van-empty>
      </div>
    </template>
  </div>
</template>

<style scoped>
.recipes-view {
  min-height: 100%;
  display: flex;
  flex-direction: column;
  background-color: #FAF8F5;
}

.search-header {
  padding: 10px 16px 4px;
  background-color: #FAF8F5;
}

.search-header :deep(.van-search) {
  width: 100%;
  padding: 0;
  background: transparent;
}

.search-header :deep(.van-search__content) {
  min-height: 46px;
  padding: 0 14px;
  background-color: #ffffff;
  border: 1px solid rgba(30, 58, 47, 0.08);
  border-radius: 16px;
  box-shadow: 0 1px 3px rgba(30, 58, 47, 0.03);
}

.search-header :deep(.van-field__control) {
  color: #1c1917;
  font-size: 14px;
}

.search-header :deep(.van-field__control::placeholder) {
  color: #a8a29e;
}

.tabs-wrapper {
  padding: 6px 16px 8px;
  background-color: #FAF8F5;
}

.tabs-segmented {
  background-color: #EAE6DF;
  width: 100%;
  padding: 4px;
  border-radius: 16px;
  display: flex;
  gap: 4px;
}

.tab-btn {
  flex: 1 1 0%;
  min-width: 0;
  border: none;
  background: transparent;
  padding: 7px 4px;
  min-height: 40px;
  font-size: 13px;
  font-weight: 500;
  color: #57534e;
  border-radius: 12px;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 4px;
  cursor: pointer;
  transition: all 0.2s cubic-bezier(0.16, 1, 0.3, 1);
  white-space: nowrap;
}

.tab-btn .tab-title {
  font-size: 12px;
  font-weight: 500;
  color: #57534e;
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

.tab-btn:hover .tab-title {
  color: #1c1917;
}

.tab-btn.active {
  background-color: #ffffff;
  box-shadow: 0 1px 4px rgba(30, 58, 47, 0.08), 0 1px 2px rgba(30, 58, 47, 0.04);
}

.tab-btn.active .tab-title {
  color: #1E3A2F;
  font-weight: 600;
}

.count-badge {
  font-size: 10px;
  font-weight: 700;
  padding: 1px 5px;
  flex-shrink: 0;
  border-radius: 9999px;
  line-height: 1.2;
}

.badge-match-active {
  background-color: #1E3A2F;
  color: #ffffff;
}

.badge-all-active {
  background-color: #44403c;
  color: #ffffff;
}

.badge-fav-active {
  background-color: #ef4444;
  color: #ffffff;
}

.badge-inactive {
  background-color: rgba(168, 162, 158, 0.3);
  color: #57534e;
}

.allergen-note {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 10px 14px;
  background-color: rgba(30, 58, 47, 0.05);
  border: 1px solid rgba(30, 58, 47, 0.12);
  border-radius: 14px;
  font-size: 12px;
  color: #1E3A2F;
  font-weight: 500;
}

.filters-scroll {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 4px 16px 12px;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
  background-color: #FAF8F5;
}

.filters-scroll::-webkit-scrollbar {
  display: none;
}

.filter-chip {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  padding: 6px 14px;
  min-height: 34px;
  border-radius: 9999px;
  border: 1px solid rgba(231, 229, 228, 0.8);
  background-color: #ffffff;
  font-size: 12px;
  font-weight: 500;
  color: #44403c;
  cursor: pointer;
  transition: all 0.15s cubic-bezier(0.16, 1, 0.3, 1);
  user-select: none;
}

.filter-chip:active {
  transform: scale(0.95);
}

.filter-chip.active {
  background-color: #1E3A2F;
  border-color: #1E3A2F;
  color: #ffffff;
  font-weight: 500;
  box-shadow: 0 1px 4px rgba(30, 58, 47, 0.15);
}

.expiring-toggle {
  background-color: rgba(254, 243, 199, 0.5);
  border-color: rgba(251, 191, 36, 0.5);
  color: #92400e;
  font-weight: 600;
}

.expiring-toggle.active {
  background-color: #1E3A2F;
  border-color: #1E3A2F;
  color: #ffffff;
}

.recipes-content {
  flex: 1 1 0%;
  min-width: 0;
  padding-bottom: 72px;
}

.loading-skeletons {
  padding: 12px 16px;
  display: flex;
  flex-direction: column;
  gap: 14px;
}

.skeleton-card {
  background-color: #ffffff;
  border-radius: 20px;
  padding: 16px;
  box-shadow: 0 4px 20px -2px rgba(30, 58, 47, 0.06);
}

.recipes-list {
  padding: 8px 16px 16px;
}

.fallback-note {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin: 0 0 14px;
  padding: 12px 14px;
  border-radius: 14px;
  background-color: rgba(30, 58, 47, 0.05);
  border: 1px solid rgba(30, 58, 47, 0.1);
  color: #1E3A2F;
  font-size: 13px;
  line-height: 1.45;
}

.fallback-note :deep(.van-icon) {
  flex: 0 0 auto;
  margin-top: 1px;
}

.empty-state {
  padding: 24px 16px;
}

.action-btn {
  min-width: 180px;
  min-height: 44px;
  font-weight: 600;
  margin-top: 8px;
  border-radius: 14px;
}
</style>
