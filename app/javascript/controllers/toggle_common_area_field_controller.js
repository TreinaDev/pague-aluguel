import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-common-area-field"
export default class extends Controller {
  static targets = ["select", "commonareas"]

  connect() {
    this.toggleField() // Initial check
  }

  toggleField() {
    const selectedValue = this.selectTarget.value
    const enableValue = this.data.get("enableValue")

    if (selectedValue === enableValue) {
      this.commonareasTarget.style.display = 'block'
    } else {
      this.commonareasTarget.style.display = 'none'
    }
  }
}
