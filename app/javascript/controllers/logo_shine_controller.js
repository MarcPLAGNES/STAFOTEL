import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.style.position = 'relative'
    this.animateSnake()
    // Crée l'animation toutes les 4 secondes
    this.interval = setInterval(() => {
      this.animateSnake()
    }, 4000)
  }

  disconnect() {
    if (this.interval) {
      clearInterval(this.interval)
    }
  }

  animateSnake() {
    // Définit le chemin en forme de S (coordonnées x, y en pourcentage)
    const path = [
      { x: 20, y: 10 },   // Haut du S
      { x: 28, y: 20 },
      { x: 20, y: 30 },   // Courbe supérieure
      { x: 12, y: 40 },
      { x: 12, y: 50 },   // Centre du S
      { x: 20, y: 60 },
      { x: 20, y: 70 },   // Courbe inférieure
      { x: 12, y: 80 },
      { x: 8, y: 90 }     // Bas du S
    ]

    // Anime chaque point du chemin en séquence
    path.forEach((point, index) => {
      setTimeout(() => {
        this.addSparkle(point.x, point.y)
      }, index * 80) // 80ms entre chaque point pour un mouvement fluide
    })
  }

  addSparkle(x, y) {
    const sparkle = document.createElement('div')
    sparkle.classList.add('logo-sparkle')

    sparkle.style.left = `${x}%`
    sparkle.style.top = `${y}%`

    this.element.appendChild(sparkle)

    // Animation de scintillement
    setTimeout(() => {
      sparkle.classList.add('active')
    }, 10)

    // Supprime après l'animation
    setTimeout(() => {
      sparkle.remove()
    }, 500)
  }
}
