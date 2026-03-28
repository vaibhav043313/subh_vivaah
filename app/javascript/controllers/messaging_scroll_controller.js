import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.box = document.getElementById("conversation-messages")
    this.scrollMessages = this.scrollMessages.bind(this)

    if (this.box) {
      this.observer = new MutationObserver(() => {
        requestAnimationFrame(this.scrollMessages)
      })
      this.observer.observe(this.box, { childList: true, subtree: true })
    }

    this.scrollMessages()
  }

  disconnect() {
    this.observer?.disconnect()
  }

  scrollMessages() {
    if (!this.box) return
    this.box.scrollTop = this.box.scrollHeight
  }
}
