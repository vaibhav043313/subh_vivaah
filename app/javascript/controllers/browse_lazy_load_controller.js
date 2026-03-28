import { Controller } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

export default class extends Controller {
  static values = { url: String }
  static targets = ["sentinel", "status"]

  connect() {
    this.loading = false
    this.observer = new IntersectionObserver(this.onIntersect.bind(this), {
      root: null,
      rootMargin: "320px 0px",
      threshold: 0
    })
    if (this.hasSentinelTarget) {
      this.observer.observe(this.sentinelTarget)
    }
  }

  disconnect() {
    this.observer?.disconnect()
  }

  onIntersect(entries) {
    const entry = entries[0]
    if (!entry?.isIntersecting || this.loading || !this.urlValue) return

    this.loadNext()
  }

  async loadNext() {
    this.loading = true
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = "Loading more profiles…"
      this.statusTarget.classList.remove("visually-hidden")
    }

    try {
      const response = await fetch(this.urlValue, {
        headers: { Accept: "text/vnd.turbo-stream.html" },
        credentials: "same-origin"
      })

      if (!response.ok) {
        throw new Error(`HTTP ${response.status}`)
      }

      const html = await response.text()
      Turbo.renderStreamMessage(html)
    } catch {
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = "Could not load more. Scroll up and try again, or refresh the page."
        this.statusTarget.classList.remove("visually-hidden")
      }
    } finally {
      this.loading = false
    }
  }
}
