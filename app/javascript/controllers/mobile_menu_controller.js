import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["toggle", "panel"]

  connect() {
    this.openClass = "is-menu-open"
    this._onKeydown = (event) => {
      if (event.key === "Escape" && this.element.classList.contains(this.openClass)) {
        this.close()
      }
    }
    document.addEventListener("keydown", this._onKeydown)
  }

  disconnect() {
    document.removeEventListener("keydown", this._onKeydown)
    document.body.classList.remove("mobile-menu-open")
  }

  toggle(event) {
    event.preventDefault()
    this.element.classList.toggle(this.openClass)
    this._sync()
  }

  close(event) {
    if (event && event.type !== "submit") event.preventDefault()
    this.element.classList.remove(this.openClass)
    this._sync()
  }

  closeOnBackdrop(event) {
    if (event.target === event.currentTarget) this.close()
  }

  closeOnLink(event) {
    if (event.target.closest("a")) this.close()
  }

  _sync() {
    const open = this.element.classList.contains(this.openClass)
    if (this.hasToggleTarget) {
      this.toggleTarget.setAttribute("aria-expanded", open)
    }
    document.body.classList.toggle("mobile-menu-open", open)
  }
}
