import { Controller } from "@hotwired/stimulus"
import Inputmask from 'inputmask'

// Connects to data-controller="document-number"
export default class extends Controller {
  connect() {
    Inputmask('999.999.999-99', {
      removeMaskOnSubmit: true
    }).mask(this.element)
    if(!this.element.innerHTML){
      this.element.innerHTML = ''
    }
  }
}
