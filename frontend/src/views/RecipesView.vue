<script setup lang="ts">
import { computed, onMounted, onUnmounted, ref, watch } from 'vue'
import { useRecipeStore, type CookingTimeFilter } from '@/stores/recipe'
import { useInventoryStore } from '@/stores/inventory'
import { useAuthStore } from '@/stores/auth'
import RecipeCard from '@/components/recipes/RecipeCard.vue'

const recipeStore = useRecipeStore()
const inventoryStore = useInventoryStore()
const authStore = useAuthStore()

const matchPage = ref(1)
const matchPageSize = 15

function scrollToTop() {
  window.scrollTo({ top: 0, behavior: 'smooth' })
  const scrollContainer = document.querySelector('.content-wrapper')
  if (scrollContainer) {
    scrollContainer.scrollTo({ top: 0, behavior: 'smooth' })
  }
}

function handleMatchPageChange(page: number) {
  matchPage.value = page
  scrollToTop()
}

async function handleAllPageChange(page: number) {
  await recipeStore.setPage(page)
  scrollToTop()
}

const visibleMatchedRecipes = computed(() => {
  const start = (matchPage.value - 1) * matchPageSize
  return recipeStore.filteredMatchedRecipes.slice(start, start + matchPageSize)
})

watch(
  [
    () => recipeStore.searchQuery,
    () => recipeStore.difficultyFilter,
    () => recipeStore.timeFilter,
    () => recipeStore.saveExpiringOnly,
    () => recipeStore.activeTab
  ],
  () => {
    matchPage.value = 1
  }
)

watch(
  () => recipeStore.activeTab,
  (tab) => {
    if (tab !== 'match') {
      recipeStore.saveExpiringOnly = false
    }
  }
)

let searchDebounceTimer: ReturnType<typeof setTimeout> | undefined

watch(
  [() => recipeStore.searchQuery, () => recipeStore.difficultyFilter, () => recipeStore.timeFilter],
  () => {
    if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
    searchDebounceTimer = setTimeout(async () => {
      await recipeStore.loadAllRecipes(1)
    }, 400)
  }
)

onUnmounted(() => {
  if (searchDebounceTimer) clearTimeout(searchDebounceTimer)
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
  if (inventoryStore.items.length === 0) {
    inventoryStore.loadInventory()
  }
  await Promise.all([
    recipeStore.loadMatchedRecipes(),
    recipeStore.loadAllRecipes(),
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
    <!-- Navigation Tabs -->
    <div class="tabs-nav">
      <button
        type="button"
        class="tab-btn"
        :class="{ active: recipeStore.activeTab === 'match' }"
        @click="recipeStore.activeTab = 'match'"
      >
        <span>Что приготовить</span>
        <span
          v-if="recipeStore.filteredMatchedRecipes.length > 0"
          class="count-badge green-badge"
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
        <span>Все рецепты</span>
        <span
          v-if="recipeStore.totalCount > 0"
          class="count-badge grey-badge"
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
        <span>Избранное</span>
        <span
          v-if="recipeStore.favoriteRecipes.length > 0"
          class="count-badge red-badge"
        >
          {{ recipeStore.favoriteRecipes.length }}
        </span>
      </button>
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

      <div
        v-else-if="recipeStore.filteredMatchedRecipes.length > 0"
        class="recipes-list"
      >
        <div v-if="authStore.user?.excludedIngredientIds?.length" class="allergen-note">
          <van-icon name="shield-o" size="16" />
          <span>Рецепты с выбранным в профиле аллергеном исключены из подбора</span>
        </div>
        <RecipeCard
          v-for="item in visibleMatchedRecipes"
          :key="item.recipe.id"
          :recipe="item.recipe"
          :match-item="item"
          :saving-ingredients="recipeStore.getSavingIngredients(item.used_ingredients)"
        />
      </div>

      <van-pagination
        v-if="recipeStore.filteredMatchedRecipes.length > matchPageSize"
        :model-value="matchPage"
        :total-items="recipeStore.filteredMatchedRecipes.length"
        :items-per-page="matchPageSize"
        prev-text="Назад"
        next-text="Далее"
        mode="simple"
        @change="handleMatchPageChange"
      />

      <!-- Состояние: фильтр "Спасает продукты" активен, но в холодильнике нет истекающих продуктов -->
      <div
        v-else-if="recipeStore.saveExpiringOnly && recipeStore.expiringItems.length === 0"
        class="empty-state"
      >
        <van-empty
          image="warning-o"
          description="В вашем холодильнике нет продуктов с истекающим сроком годности. Все продукты свежие!"
        >
          <router-link to="/fridge">
            <van-button round type="primary" color="#2e7d32" class="action-btn">
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
            <van-button round type="primary" color="#2e7d32" class="action-btn">
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
              matchPage = 1;
            "
          >
            Сбросить фильтры
          </van-button>
        </van-empty>
      </div>
    </template>

    <!-- Tab: All Recipes -->
    <template v-else-if="recipeStore.activeTab === 'all'">
      <div v-if="recipeStore.isLoading" class="loading-skeletons">
        <van-skeleton title avatar :row="3" class="skeleton-card" />
        <van-skeleton title avatar :row="3" class="skeleton-card" />
      </div>

      <div v-else-if="recipeStore.filteredAllRecipes.length > 0" class="recipes-list">
        <RecipeCard
          v-for="r in recipeStore.visibleAllRecipes"
          :key="r.id"
          :recipe="r"
          :saving-ingredients="recipeStore.getSavingIngredients(r.ingredients)"
        />
      </div>
      <van-pagination
        v-if="recipeStore.totalCount > recipeStore.pageSize"
        :model-value="recipeStore.page"
        :total-items="recipeStore.totalCount"
        :items-per-page="recipeStore.pageSize"
        prev-text="Назад"
        next-text="Далее"
        mode="simple"
        @change="handleAllPageChange"
      />

      <div v-if="!recipeStore.isLoading && recipeStore.filteredAllRecipes.length === 0" class="empty-state">
        <van-empty image="search" description="Рецепты не найдены">
          <van-button
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
            color="#2e7d32"
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
}

.search-header {
  padding: 10px 16px;
  background-color: #ffffff;
  border-bottom: 1px solid #e7ece7;
}

.search-header :deep(.van-search) {
  width: 100%;
  padding: 0;
  background: transparent;
}

.search-header :deep(.van-search__content) {
  min-height: 48px;
  padding: 0 12px;
  background-color: #f5f7f5;
  border: 1px solid #e2e9e2;
  border-radius: 14px;
}

.search-header :deep(.van-field__control) {
  color: #243126;
  font-size: 15px;
}

.search-header :deep(.van-field__control::placeholder) {
  color: #7c887e;
}

.tabs-nav {
  display: flex;
  background-color: #ffffff;
  border-bottom: 1px solid #e0e0e0;
  padding: 0 8px;
}

.tab-btn {
  flex: 1;
  border: none;
  background: none;
  padding: 12px 6px;
  min-height: 44px;
  font-size: 14px;
  font-weight: 600;
  color: #757575;
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 6px;
  cursor: pointer;
  position: relative;
  transition: color 0.2s ease;
}

.tab-btn.active {
  color: #2e7d32;
  font-weight: 700;
}

.tab-btn.active::after {
  content: '';
  position: absolute;
  bottom: 0;
  left: 20%;
  right: 20%;
  height: 3px;
  background-color: #2e7d32;
  border-radius: 3px 3px 0 0;
}

.count-badge {
  font-size: 11px;
  font-weight: 700;
  padding: 1px 6px;
  border-radius: 10px;
  color: #ffffff;
}

.green-badge {
  background-color: #2e7d32;
}

.grey-badge {
  background-color: #78909c;
}

.red-badge {
  background-color: #e53935;
}

.allergen-note {
  display: flex;
  align-items: center;
  gap: 8px;
  margin-bottom: 12px;
  padding: 8px 12px;
  background-color: #f1f8e9;
  border: 1px solid #c8e6c9;
  border-radius: 10px;
  font-size: 12px;
  color: #2e7d32;
  font-weight: 500;
}

.filters-scroll {
  display: flex;
  gap: 8px;
  overflow-x: auto;
  padding: 8px 12px;
  -webkit-overflow-scrolling: touch;
  scrollbar-width: none;
}

.filters-scroll::-webkit-scrollbar {
  display: none;
}

.filter-chip {
  flex-shrink: 0;
  display: inline-flex;
  align-items: center;
  padding: 6px 14px;
  min-height: 36px;
  border-radius: 18px;
  border: 1px solid #e0e0e0;
  background-color: #ffffff;
  font-size: 13px;
  font-weight: 500;
  color: #4a4a4a;
  cursor: pointer;
  transition: all 0.2s ease;
}

.filter-chip.active {
  background-color: #2e7d32;
  border-color: #2e7d32;
  color: #ffffff;
  font-weight: 600;
}

.expiring-toggle {
  background-color: #fff3e0;
  border-color: #ffe082;
  color: #e65100;
  font-weight: 600;
}

.expiring-toggle.active {
  background-color: #e65100;
  border-color: #e65100;
  color: #ffffff;
}

.recipes-content {
  flex: 1;
  padding-bottom: 72px;
}

.loading-skeletons {
  padding: 12px;
  display: flex;
  flex-direction: column;
  gap: 12px;
}

.skeleton-card {
  background-color: #ffffff;
  border-radius: 16px;
  padding: 16px;
}

.recipes-list {
  padding: 12px 16px 16px;
}

.fallback-note {
  display: flex;
  align-items: flex-start;
  gap: 10px;
  margin: 0 0 14px;
  padding: 12px 14px;
  border-radius: 12px;
  background-color: #edf5ee;
  color: #315d37;
  font-size: 14px;
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
}
</style>
