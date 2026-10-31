import axios, { type AxiosRequestConfig, type InternalAxiosRequestConfig } from 'axios'

const baseURL = import.meta.env.VITE_API_URL || 'http://localhost:8080'

export const apiClient = axios.create({
  baseURL,
  withCredentials: true,
  headers: {
    'Content-Type': 'application/json'
  }
})

let isRefreshing = false
let failedQueue: Array<{
  resolve: (value?: unknown) => void
  reject: (reason?: unknown) => void
}> = []

const processQueue = (error: unknown = null) => {
  failedQueue.forEach((promise) => {
    if (error) {
      promise.reject(error)
    } else {
      promise.resolve()
    }
  })
  failedQueue = []
}

apiClient.interceptors.request.use(
  (config: InternalAxiosRequestConfig) => {
    const token = localStorage.getItem('access_token')
    if (token && config.headers) {
      config.headers.Authorization = `Bearer ${token}`
    }
    return config
  },
  (error) => Promise.reject(error)
)

apiClient.interceptors.response.use(
  (response) => response,
  async (error) => {
    const originalRequest = error.config as AxiosRequestConfig & { _retry?: boolean }

    if (!error.response || error.response.status !== 401 || originalRequest._retry) {
      return Promise.reject(error)
    }

    const authUrls = ['/api/v1/auth/login', '/api/v1/auth/register', '/api/v1/auth/refresh']
    if (originalRequest.url && authUrls.some((url) => originalRequest.url?.includes(url))) {
      return Promise.reject(error)
    }

    if (isRefreshing) {
      return new Promise((resolve, reject) => {
        failedQueue.push({ resolve, reject })
      })
        .then(() => apiClient(originalRequest))
        .catch((err) => Promise.reject(err))
    }

    originalRequest._retry = true
    isRefreshing = true

    try {
      const response = await axios.post<{ access_token: string }>(
        `${baseURL}/api/v1/auth/refresh`,
        {},
        { withCredentials: true }
      )

      const newToken = response.data.access_token
      localStorage.setItem('access_token', newToken)

      if (originalRequest.headers) {
        originalRequest.headers.Authorization = `Bearer ${newToken}`
      }

      processQueue(null)
      return apiClient(originalRequest)
    } catch (refreshError) {
      processQueue(refreshError)
      localStorage.removeItem('access_token')
      window.dispatchEvent(new CustomEvent('auth:expired'))
      return Promise.reject(refreshError)
    } finally {
      isRefreshing = false
    }
  }
)
