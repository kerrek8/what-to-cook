import { defineStore } from 'pinia'
import { ref, computed } from 'vue'
import type { LocalInventoryItem } from '@/db/types'
import {
  getLocalInventory,
  addLocalInventoryItem,
  updateLocalInventoryItem,
  deleteLocalInventoryItem,
  syncServerInventory
} from '@/db'
import {
  getInventoryApi,
  createInventoryApi,
  updateInventoryApi,
  deleteInventoryApi
} from '@/api/inventory'
import { useAuthStore } from './auth'
import { getFreshnessInfo } from '@/utils/freshness'

export interface AddItemData {
  ingredientId?: number | null
  name: string
  category: string
  amount?: number | null
  unit?: string | null
  approximateQuantity?: 'few' | 'medium' | 'much' | null
  expirationDate?: string | null
  isPantryEssential?: boolean
}

export const useInventoryStore = defineStore('inventory', () => {
  const items = ref<LocalInventoryItem[]>([])
  const isLoading = ref<boolean>(false)
  const isSyncing = ref<boolean>(false)
  const activeCategory = ref<string>('all')
  const searchQuery = ref<string>('')

  const authStore = useAuthStore()

  const categories = computed(() => {
    const set = new Set<string>()
    items.value.forEach((item) => {
      if (item.category) set.add(item.category)
    })
    return Array.from(set)
  })

  const expiringCount = computed(() => {
    return items.value.filter((item) => {
      const info = getFreshnessInfo(item.expirationDate)
      return info.status === 'warning' || info.status === 'danger'
    }).length
  })

  const filteredItems = computed(() => {
    let result = items.value

    const q = searchQuery.value.trim().toLowerCase()
    if (q) {
      result = result.filter(
        (item) =>
          item.name.toLowerCase().includes(q) ||
          item.category.toLowerCase().includes(q)
      )
    }

    if (activeCategory.value === 'expiring') {
      result = result.filter((item) => {
        const info = getFreshnessInfo(item.expirationDate)
        return info.status === 'warning' || info.status === 'danger'
      })
      result.sort((a, b) => {
        if (!a.expirationDate) return 1
        if (!b.expirationDate) return -1
        return a.expirationDate.localeCompare(b.expirationDate)
      })
    } else if (activeCategory.value !== 'all') {
      result = result.filter((item) => item.category === activeCategory.value)
    }

    return result
  })

  async function loadInventory(refreshServer = true): Promise<void> {
    isLoading.value = true
    try {
      items.value = await getLocalInventory()

      if (refreshServer && authStore.isAuthenticated && navigator.onLine) {
        await syncWithServer()
      }
    } finally {
      isLoading.value = false
    }
  }

  async function syncWithServer(): Promise<void> {
    if (!authStore.isAuthenticated || !navigator.onLine) return
    isSyncing.value = true
    try {
      const serverItems = await getInventoryApi()
      items.value = await syncServerInventory(serverItems)
    } catch {
      // Offline fallback: continue using local items
    } finally {
      isSyncing.value = false
    }
  }

  async function addItem(data: AddItemData): Promise<number> {
    const localId = await addLocalInventoryItem({
      ingredientId: data.ingredientId ?? null,
      serverId: null,
      name: data.name,
      category: data.category || 'Другое',
      amount: data.amount ?? null,
      unit: data.unit ?? null,
      approximateQuantity: data.approximateQuantity ?? null,
      expirationDate: data.expirationDate ?? null,
      isPantryEssential: data.isPantryEssential ?? false,
      synced: 0,
      updatedAt: new Date().toISOString()
    })

    items.value = await getLocalInventory()

    if (authStore.isAuthenticated && navigator.onLine) {
      try {
        const res = await createInventoryApi({
          ingredient_id: data.ingredientId ?? null,
          custom_name: data.ingredientId ? null : data.name,
          amount: data.amount ?? null,
          unit: data.unit ?? null,
          approximate_quantity: data.approximateQuantity ?? null,
          in_stock: true,
          expiration_date: data.expirationDate ?? null
        })

        await updateLocalInventoryItem(localId, {
          serverId: res.id,
          synced: 1
        })
        items.value = await getLocalInventory()
      } catch {
        // Will sync later
      }
    }

    return localId
  }

  async function updateItem(
    id: number,
    changes: Partial<LocalInventoryItem>
  ): Promise<void> {
    const target = items.value.find((i) => i.id === id)
    if (!target) return

    await updateLocalInventoryItem(id, {
      ...changes,
      synced: 0
    })

    items.value = await getLocalInventory()

    if (target.serverId && authStore.isAuthenticated && navigator.onLine) {
      try {
        await updateInventoryApi(target.serverId, {
          ingredient_id: changes.ingredientId !== undefined ? changes.ingredientId : target.ingredientId,
          custom_name: changes.name || target.name,
          amount: changes.amount !== undefined ? changes.amount : target.amount,
          unit: changes.unit !== undefined ? changes.unit : target.unit,
          approximate_quantity:
            changes.approximateQuantity !== undefined
              ? changes.approximateQuantity
              : target.approximateQuantity,
          in_stock: true,
          expiration_date:
            changes.expirationDate !== undefined
              ? changes.expirationDate
              : target.expirationDate
        })

        await updateLocalInventoryItem(id, { synced: 1 })
        items.value = await getLocalInventory()
      } catch {
        // Will sync later
      }
    }
  }

  async function deleteItem(id: number): Promise<void> {
    const target = items.value.find((i) => i.id === id)
    await deleteLocalInventoryItem(id)
    items.value = items.value.filter((i) => i.id !== id)

    if (target?.serverId && authStore.isAuthenticated && navigator.onLine) {
      try {
        await deleteInventoryApi(target.serverId)
      } catch {
        // Deletion logged
      }
    }
  }

  return {
    items,
    isLoading,
    isSyncing,
    activeCategory,
    searchQuery,
    categories,
    expiringCount,
    filteredItems,
    loadInventory,
    syncWithServer,
    addItem,
    updateItem,
    deleteItem
  }
})
