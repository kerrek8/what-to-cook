import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'

const routes: RouteRecordRaw[] = [
  {
    path: '/',
    redirect: '/fridge'
  },
  {
    path: '/fridge',
    name: 'fridge',
    component: () => import('@/views/FridgeView.vue'),
    meta: { title: 'Холодильник' }
  },
  {
    path: '/recipes',
    name: 'recipes',
    component: () => import('@/views/RecipesView.vue'),
    meta: { title: 'Рецепты' }
  },
  {
    path: '/shopping',
    name: 'shopping',
    component: () => import('@/views/ShoppingView.vue'),
    meta: { title: 'Список покупок' }
  },
  {
    path: '/profile',
    name: 'profile',
    component: () => import('@/views/ProfileView.vue'),
    meta: { title: 'Профиль' }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

export default router
