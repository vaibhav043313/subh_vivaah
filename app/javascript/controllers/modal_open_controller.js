import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { dialogId: String }

  open() {
    const el = document.getElementById(this.dialogIdValue)
    if (el && typeof el.showModal === "function") el.showModal()
  }
}
