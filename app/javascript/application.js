// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import * as Popper from "@popperjs/core"
import * as bootstrap from "bootstrap"
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import HelloComponent from './components/hello_vue.js'

createApp(HelloComponent).mount('#vue-app')

document.addEventListener("turbo:frame-missing", (event) => {
  const { detail: { response, visit } } = event
  event.preventDefault()
  visit(response)
})
