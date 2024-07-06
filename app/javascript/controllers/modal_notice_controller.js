import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    const globalNotice = document.getElementById("global-notice");
    if (globalNotice) {
      const modal = document.querySelector("turbo-frame#modal .dean-modal");
      if (modal) {
        modal.insertAdjacentHTML('afterbegin', globalNotice.outerHTML);
        globalNotice.remove();
      }
    }
  }
}
