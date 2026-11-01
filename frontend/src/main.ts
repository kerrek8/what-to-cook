import { createApp } from 'vue'
import Vant, { Locale } from 'vant'
import ruRU from 'vant/es/locale/lang/ru-RU'
import 'vant/lib/index.css'

import App from './App.vue'
import router from './router'
import pinia from './stores'
import './assets/main.css'

const app = createApp(App)

Locale.use('ru-RU', ruRU)

app.use(pinia)
app.use(router)
app.use(Vant)

app.mount('#app')
