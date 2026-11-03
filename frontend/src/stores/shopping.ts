import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { LocalShoppingItem } from '@/db/types'
import {
  getLocalShoppingList,
  addLocalShoppingItem,
  updateLocalShoppingItem,
  deleteLocalShoppingItem,
  clearBoughtShoppingItems,
  syncServerShoppingList
} from '@/db'
import {
  getShoppingListApi,
  createShoppingItemApi,
  updateShoppingItemApi,
  deleteShoppingItemApi,
  transferToInventoryApi
} from '@/api/shopping'
import { useAuthStore } from './auth'
import { useInventoryStore } from './inventory'
import { displayText } from '@/i18n/translation'

export interface AddShoppingItemPayload {
  ingredientId?: number | null
  name: string
  category?: string
  amount?: number | null
  unit?: string | null
}

export interface ShoppingCategoryGroup {
  category: string
  items: LocalShoppingItem[]
  pendingCount: number
  boughtCount: number
}

export const useShoppingStore = defineStore('shopping', () => {
  const items = ref<LocalShoppingItem[]>([])
  const isLoading = ref(false)
  const isSyncing = ref(false)
  const isTransferring = ref(false)

  const activeCategory = ref<string>('all')
  const searchQuery = ref('')

  const authStore = useAuthStore()
  const inventoryStore = useInventoryStore()

  const boughtCount = computed(() => items.value.filter((i) => i.isBought).length)
  const pendingCount = computed(() => items.value.filter((i) => !i.isBought).length)
  const totalCount = computed(() => items.value.length)

  const categories = computed(() => {
    const cats = new Set<string>()
    for (const item of items.value) {
      if (item.category) cats.add(item.category)
    }
    return Array.from(cats).sort()
  })

  const filteredItems = computed(() => {
    let result = items.value

    if (searchQuery.value.trim()) {
      const q = searchQuery.value.trim().toLowerCase()
      result = result.filter((i) => i.name.toLowerCase().includes(q) || displayText(i.name).toLowerCase().includes(q))
    }

    if (activeCategory.value !== 'all') {
      result = result.filter((i) => i.category === activeCategory.value)
    }

    return result
  })

  const groupedCategories = computed((): ShoppingCategoryGroup[] => {
    const groupsMap = new Map<string, LocalShoppingItem[]>()

    for (const item of filteredItems.value) {
      const cat = item.category || 'Другое'
      if (!groupsMap.has(cat)) {
        groupsMap.set(cat, [])
      }
      groupsMap.get(cat)!.push(item)
    }

    const groups: ShoppingCategoryGroup[] = []
    for (const [cat, catItems] of groupsMap.entries()) {
      const sorted = [...catItems].sort((a, b) => {
        if (a.isBought !== b.isBought) {
          return a.isBought ? 1 : -1
        }
        return a.name.localeCompare(b.name, 'ru')
      })

      const pending = sorted.filter((i) => !i.isBought).length
      const bought = sorted.filter((i) => i.isBought).length

      groups.push({
        category: cat,
        items: sorted,
        pendingCount: pending,
        boughtCount: bought
      })
    }

    return groups.sort((a, b) => a.category.localeCompare(b.category, 'ru'))
  })

  async function loadShoppingList(force = false) {
    isLoading.value = true
    try {
      const local = await getLocalShoppingList()
      items.value = local

      if (authStore.isAuthenticated) {
        syncWithServer(force)
      }
    } finally {
      isLoading.value = false
    }
  }

  async function syncWithServer(force = false) {
    if (isSyncing.value && !force) return
    isSyncing.value = true
    try {
      const serverItems = await getShoppingListApi()
      const merged = await syncServerShoppingList(serverItems)
      items.value = merged
    } catch {
      // Offline fallback
    } finally {
      isSyncing.value = false
    }
  }

  async function addItem(payload: AddShoppingItemPayload): Promise<number> {
    const category = payload.category?.trim() || 'Другое'
    const name = payload.name.trim()

    const localId = await addLocalShoppingItem({
      ingredientId: payload.ingredientId ?? null,
      name,
      category,
      amount: payload.amount ?? null,
      unit: payload.unit ?? null,
      isBought: false,
      synced: 0,
      updatedAt: new Date().toISOString()
    })

    const newItem: LocalShoppingItem = {
      id: localId,
      ingredientId: payload.ingredientId ?? null,
      name,
      category,
      amount: payload.amount ?? null,
      unit: payload.unit ?? null,
      isBought: false,
      synced: 0,
      updatedAt: new Date().toISOString()
    }

    items.value.push(newItem)

    if (authStore.isAuthenticated) {
      try {
        const resp = await createShoppingItemApi({
          ingredient_id: payload.ingredientId ?? null,
          custom_name: payload.ingredientId ? null : name,
          amount: payload.amount ?? null,
          unit: payload.unit ?? null
        })

        await updateLocalShoppingItem(localId, {
          serverId: resp.id,
          synced: 1
        })

        newItem.serverId = resp.id
        newItem.synced = 1
      } catch {
        // Will sync later
      }
    }

    return localId
  }

  async function toggleBought(id: number) {
    const item = items.value.find((i) => i.id === id)
    if (!item) return

    item.isBought = !item.isBought
    item.synced = 0
    await updateLocalShoppingItem(id, {
      isBought: item.isBought,
      synced: 0
    })

    if (authStore.isAuthenticated && item.serverId) {
      try {
        await updateShoppingItemApi(item.serverId, {
          is_bought: item.isBought
        })
        item.synced = 1
        await updateLocalShoppingItem(id, { synced: 1 })
      } catch {
        // Keeps local change
      }
    }
  }

  async function deleteItem(id: number) {
    const item = items.value.find((i) => i.id === id)
    const serverId = item?.serverId

    items.value = items.value.filter((i) => i.id !== id)
    await deleteLocalShoppingItem(id)

    if (authStore.isAuthenticated && serverId) {
      try {
        await deleteShoppingItemApi(serverId)
      } catch {
        // Offline deletion
      }
    }
  }

  async function transferBoughtToInventory(): Promise<number> {
    if (boughtCount.value === 0) return 0
    isTransferring.value = true

    try {
      let count = boughtCount.value
      if (authStore.isAuthenticated) {
        const res = await transferToInventoryApi()
        count = res.transferred_count
      }

      await clearBoughtShoppingItems()
      items.value = await getLocalShoppingList()

      await inventoryStore.loadInventory(true)

      return count
    } finally {
      isTransferring.value = false
    }
  }

  return {
    items,
    isLoading,
    isSyncing,
    isTransferring,
    activeCategory,
    searchQuery,
    boughtCount,
    pendingCount,
    totalCount,
    categories,
    filteredItems,
    groupedCategories,
    loadShoppingList,
    syncWithServer,
    addItem,
    toggleBought,
    deleteItem,
    transferBoughtToInventory
  }
})
