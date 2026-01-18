import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.position = 'relative'
    this.animateShine()
    // Crée l'animation toutes les 4 secondes
    this.interval = setInterval(() => {
      this.animateShine()
    }, 4000)
  }

  disconnect() {
    if (this.interval) {
      clearInterval(this.interval)
    }
  }

  animateShine() {
    const shine = document.createElement('div')
    shine.classList.add('logo-shine')

    this.element.appendChild(shine)

    // Démarre l'animation après un court délai
    setTimeout(() => {
      shine.classList.add('active')
    }, 10)

    // Supprime après l'animation (2.5s)
    setTimeout(() => {
      shine.remove()
    }, 2500)
  }
}
