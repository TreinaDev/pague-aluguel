import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="masked-document-number"
export default class extends Controller {
  connect() {
    Inputmask('999.999.999-99', {
      removeMaskOnSubmit: false
    }).mask(this.element)
    if(!this.element.innerHTML){
      this.element.innerHTML = ''
    }
  }
}
