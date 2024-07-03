import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["allAdminsBtn", "hideAdminsBtn"]

  connect() {
    this.hideAdminsBtnTarget.hidden = true

    this.allAdminsBtnTarget.addEventListener("click", () => {
      this.toggle()
    })

    this.hideAdminsBtnTarget.addEventListener("click", () => {
      this.untoggle()
    })
  }

  toggle() {
    this.allAdminsBtnTarget.hidden = true
    this.hideAdminsBtnTarget.hidden = false
  }

  untoggle() {
    this.allAdminsBtnTarget.hidden = false
    this.hideAdminsBtnTarget.hidden = true
  }
}
