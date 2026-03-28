import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["readLabel"]
  static values = {
    senderId: Number,
    read: Boolean
  }

  connect() {
    const root = document.querySelector("[data-current-user-id]")
    const me = root ? parseInt(root.dataset.currentUserId, 10) : NaN
    const mine = Number.isFinite(me) && this.senderIdValue === me

    this.element.classList.add(mine ? "messaging-bubble--out" : "messaging-bubble--in")

    if (mine && this.hasReadLabelTarget) {
      this.readLabelTarget.textContent = this.readValue ? " · Read" : " · Sent"
    }
  }
}
