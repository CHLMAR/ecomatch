import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    this.timeout = null
  }

  // Called on dropdown change - submit immediately
  submit() {
    this.formTarget.requestSubmit()
  }

  // Called on text input - debounce 400ms to avoid excessive requests
  debounceSubmit() {
    clearTimeout(this.timeout)
    this.timeout = setTimeout(() => {
      this.formTarget.requestSubmit()
    }, 400)
  }
}
