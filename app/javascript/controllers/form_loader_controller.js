import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.boundHandleSubmit = this.handleSubmit.bind(this)
    this.formTarget.addEventListener("submit", this.boundHandleSubmit)
  }

  disconnect() {
    this.formTarget.removeEventListener("submit", this.boundHandleSubmit)
  }

  handleSubmit(event) {
    event.preventDefault()
    this.formTarget.removeEventListener("submit", this.boundHandleSubmit)
    this.formTarget.submit()
  }
}
