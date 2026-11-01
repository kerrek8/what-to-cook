<script setup lang="ts">
import { onMounted, ref } from 'vue'
import { showToast } from 'vant'
import { useRecipeStore, type CookingTimeFilter } from '@/stores/recipe'
import { useInventoryStore } from '@/stores/inventory'
import { useAuthStore } from '@/stores/auth'
import RecipeCard from '@/components/recipes/RecipeCard.vue'

const recipeStore = useRecipeStore()
const inventoryStore = useInventoryStore()
const authStore = useAuthStore()

const isRefreshing = ref(false)

const timeOptions: Array<{ label: string; value: CookingTimeFilter }> = [
  { label: 'Любое время', value: 0 },
  { label: '≤ 15 мин', value: 15 },
  { label: 'До 30 мин', value: 30 },
  { label: 'До 1 часа', value: 60 },
  { label: '> 1 часа', value: 61 }
]

const difficultyOptions: Array<{ label: string; value: string }> = [
  { label: 'Любая сложность', value: 'all' },
  { label: 'Легко', value: 'easy' },
  { label: 'Средне', value: 'medium' },
  { label: 'Сложно', value: 'hard' }
]

onMounted(async () => {
  if (inventoryStore.items.length === 0) {
    inventoryStore.loadInventory()
  }
  await Promise.all([
    recipeStore.loadMatchedRecipes(),
    recipeStore.loadAllRecipes()
  ])
})

async function onRefresh() {
  isRefreshing.value = true
  try {
    await Promise.all([
      inventoryStore.loadInventory(true),
      recipeStore.loadMatchedRecipes(true),
      recipeStore.loadAllRecipes(true)
    ])
    showToast({ type: 'success', message: 'Рецепты обновлены' })
  } catch {
    showToast({ type: 'fail', message: 'Ошибка обновления' })
  } finally {
    isRefreshing.value = false
  }
}
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
      <!-- Expiring Toggle Chip -->
      <button
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

    <!-- Pull Refresh Content -->
    <van-pull-refresh v-model="isRefreshing" class="recipes-content" @refresh="onRefresh">
      <!-- Skeletons while loading -->
      <div
        v-if="recipeStore.isMatching || recipeStore.isLoading"
        class="loading-skeletons"
      >
        <van-skeleton title avatar :row="3" class="skeleton-card" />
        <van-skeleton title avatar :row="3" class="skeleton-card" />
      </div>

      <!-- Tab: Smart Match -->
      <template v-else-if="recipeStore.activeTab === 'match'">
        <div
          v-if="recipeStore.filteredMatchedRecipes.length > 0"
          class="recipes-list"
        >
          <RecipeCard
            v-for="item in recipeStore.filteredMatchedRecipes"
            :key="item.recipe.id"
            :recipe="item.recipe"
            :match-item="item"
            :saving-ingredients="recipeStore.getSavingIngredients(item.used_ingredients)"
          />
        </div>

        <div v-else-if="recipeStore.filteredAllRecipes.length > 0" class="recipes-list suggestions-fallback">
          <p class="fallback-note">Пока нет точных совпадений. Вот блюда и продукты, которых не хватает:</p>
          <RecipeCard
            v-for="r in recipeStore.filteredAllRecipes"
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
              "
            >
              Сбросить фильтры
            </van-button>
          </van-empty>
        </div>
      </template>

      <!-- Tab: All Recipes -->
      <template v-else-if="recipeStore.activeTab === 'all'">
        <div v-if="recipeStore.filteredAllRecipes.length > 0" class="recipes-list">
          <RecipeCard
            v-for="r in recipeStore.filteredAllRecipes"
            :key="r.id"
            :recipe="r"
            :saving-ingredients="recipeStore.getSavingIngredients(r.ingredients)"
          />
        </div>
        <van-pagination
          v-if="recipeStore.totalPages > 1"
          :model-value="recipeStore.page"
          :total-items="recipeStore.recipeTotal"
          :items-per-page="recipeStore.pageSize"
          mode="simple"
          @change="recipeStore.setPage"
        />

        <div v-if="recipeStore.filteredAllRecipes.length === 0" class="empty-state">
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
        <div v-if="recipeStore.favoriteRecipes.length > 0" class="recipes-list">
          <RecipeCard
            v-for="r in recipeStore.favoriteRecipes"
            :key="r.id"
            :recipe="r"
            :saving-ingredients="recipeStore.getSavingIngredients(r.ingredients)"
          />
        </div>

        <div v-else class="empty-state">
          <van-empty
            image="like-o"
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
    </van-pull-refresh>
  </div>
</template>

<style scoped>
.recipes-view {
  min-height: 100%;
  display: flex;
  flex-direction: column;
}

.search-header {
  padding: 4px 8px 0;
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

.red-badge {
  background-color: #e53935;
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
  padding: 8px 12px;
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
