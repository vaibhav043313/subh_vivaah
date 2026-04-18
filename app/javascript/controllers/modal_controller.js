import { Controller } from "@hotwired/stimulus"

// Native <dialog>: close on backdrop click; close button calls close()
export default class extends Controller {
  backdropClose(event) {
    if (event.target === this.element) this.element.close()
  }

  close() {
    this.element.close()
  }
}
