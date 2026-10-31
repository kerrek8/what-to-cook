import { createRouter, createWebHistory, type RouteRecordRaw } from 'vue-router'
import { useAuthStore } from '@/stores/auth'

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
  },
  {
    path: '/login',
    name: 'login',
    component: () => import('@/views/LoginView.vue'),
    meta: { title: 'Вход', guestOnly: true }
  },
  {
    path: '/register',
    name: 'register',
    component: () => import('@/views/RegisterView.vue'),
    meta: { title: 'Регистрация', guestOnly: true }
  }
]

const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes
})

router.beforeEach(async (to, _from, next) => {
  const authStore = useAuthStore()

  if (!authStore.isInitialized) {
    await authStore.init()
  }

  if (to.meta.requiresAuth && !authStore.isAuthenticated) {
    next({ path: '/login', query: { redirect: to.fullPath } })
    return
  }

  if (to.meta.guestOnly && authStore.isAuthenticated) {
    next({ path: '/profile' })
    return
  }

  next()
})

export default router
