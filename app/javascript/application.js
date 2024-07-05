// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import HelloComponent from './components/hello_vue.js'

createApp(HelloComponent).mount('#vue-app')
import "./controllers"
