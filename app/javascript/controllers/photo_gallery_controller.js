import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["main", "thumb"]

  select(event) {
    const button = event.currentTarget
    const url = button.dataset.fullUrl
    if (url) this.mainTarget.src = url

    this.thumbTargets.forEach((el) => el.classList.toggle("is-active", el === button))
  }
}
