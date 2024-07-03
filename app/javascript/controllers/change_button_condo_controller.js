import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="change-button-condo"
export default class extends Controller {
  static targets = ["allCondosBtn", "hideCondosBtn"]

  connect() {
    this.hideCondosBtnTarget.hidden = true

    this.allCondosBtnTarget.addEventListener("click", () => {
      this.toggle()
    })

    this.hideCondosBtnTarget.addEventListener("click", () => {
      this.untoggle()
    })
  }

  toggle() {
    this.allCondosBtnTarget.hidden = true
    this.hideCondosBtnTarget.hidden = false
  }

  untoggle() {
    this.allCondosBtnTarget.hidden = false
    this.hideCondosBtnTarget.hidden = true
  }
}
