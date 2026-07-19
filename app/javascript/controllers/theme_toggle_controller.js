import { Controller } from "@hotwired/stimulus"

const STORAGE_KEY = "subh-vivaah-theme"
const THEMES = ["light", "dark"]

export default class extends Controller {
  static targets = ["label"]

  connect() {
    this.onThemeChange = () => this.sync()
    window.addEventListener("theme:change", this.onThemeChange)
    this.apply(this.currentTheme)
  }

  disconnect() {
    window.removeEventListener("theme:change", this.onThemeChange)
  }

  toggle(event) {
    event.preventDefault()

    const nextTheme = this.currentTheme === "dark" ? "light" : "dark"
    this.apply(nextTheme, { persist: true, broadcast: true })
  }

  apply(theme, { persist = false, broadcast = false } = {}) {
    const safeTheme = THEMES.includes(theme) ? theme : "light"

    document.documentElement.dataset.theme = safeTheme
    document.documentElement.style.colorScheme = safeTheme

    if (persist) {
      try {
        window.localStorage.setItem(STORAGE_KEY, safeTheme)
      } catch (_error) {
        // Storage can be unavailable in private or locked-down browser contexts.
      }
    }

    this.sync()

    if (broadcast) {
      window.dispatchEvent(new CustomEvent("theme:change", { detail: { theme: safeTheme } }))
    }
  }

  sync() {
    const dark = this.currentTheme === "dark"
    const label = dark ? "Switch to light mode" : "Switch to dark mode"

    this.element.setAttribute("aria-pressed", dark)
    this.element.setAttribute("aria-label", label)
    this.element.setAttribute("title", label)
    if (this.hasLabelTarget) this.labelTarget.textContent = label
  }

  get currentTheme() {
    const documentTheme = document.documentElement.dataset.theme
    if (THEMES.includes(documentTheme)) return documentTheme

    return this.storedTheme || "light"
  }

  get storedTheme() {
    try {
      const stored = window.localStorage.getItem(STORAGE_KEY)
      return THEMES.includes(stored) ? stored : null
    } catch (_error) {
      return null
    }
  }

}
