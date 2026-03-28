import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    unread: Boolean
  }

  markOnce() {
    if (!this.unreadValue) return

    this.unreadValue = false

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        Accept: "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")?.content || "",
        "X-Requested-With": "XMLHttpRequest"
      },
      credentials: "same-origin"
    })
      .then((response) => {
        if (response.ok) {
          this.element.removeAttribute("data-notification-unread")
        } else {
          this.unreadValue = true
        }
      })
      .catch(() => {
        this.unreadValue = true
      })
  }
}
