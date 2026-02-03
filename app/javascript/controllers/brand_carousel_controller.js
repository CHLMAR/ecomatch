import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["logo", "brandName", "logoContainer"]
  static values = {
    searchId: Number,
    brands: Array,
    interval: { type: Number, default: 700 }
  }

  connect() {
    console.log("[BrandCarousel] Connected with", this.brandsValue.length, "brands")
    this.currentIndex = 0
    this.startCarousel()
  }

  // disconnect() {
  //   this.stopCarousel()
  // }

  startCarousel() {
    if (this.brandsValue.length <= 1) return

    this.carouselTimer = setInterval(() => {
      this.nextBrand()
    }, this.intervalValue)
  }

  stopCarousel() {
    if (this.carouselTimer) {
      clearInterval(this.carouselTimer)
    }
  }

  nextBrand() {
    this.currentIndex = (this.currentIndex + 1) % this.brandsValue.length
    const [name, logoUrl] = this.brandsValue[this.currentIndex]

    if (this.hasLogoTarget) {
      this.logoTarget.src = logoUrl
      this.logoTarget.alt = name
    }

    if (this.hasBrandNameTarget) {
      this.brandNameTarget.textContent = name
    }
  }
}
