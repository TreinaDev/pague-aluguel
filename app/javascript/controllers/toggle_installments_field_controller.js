import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="toggle-installments-field"
export default class extends Controller {
  static targets = ["limited", "installments"]

  connect() {
    this.toggleInstallmentsField() // Initialize the state based on the checkbox
  }

  toggleInstallmentsField() {
    if (this.limitedTarget.checked) {
      this.installmentsTarget.style.display = 'block';
    } else {
      this.installmentsTarget.style.display = 'none';
    }
  }

  toggle(event) {
    this.toggleInstallmentsField()
  }
}
