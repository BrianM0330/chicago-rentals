import { Controller } from "@hotwired/stimulus"
import L from "leaflet"

export default class extends Controller {
  static targets = ["canvas", "sidebar", "sidebarFrame"]

  static values = {
    latitude: Number,
    longitude: Number,
    zoom: Number,
    pins: Array
  }

  connect() {
    this.map = L.map(this.canvasTarget, {
      zoomControl: true
    }).setView(
      [this.latitudeValue, this.longitudeValue],
      this.zoomValue
    )

    this.map.on('click', () => {
      if (this.sidebarTarget.dataset.state !== "open") return
      this.closeSidebar()
    })

    L.tileLayer("https://{s}.basemaps.cartocdn.com/dark_nolabels/{z}/{x}/{y}{r}.png", {
      subdomains: "abcd",
      maxZoom: 20,
      attribution: "&copy; OpenStreetMap &copy; CARTO"
    }).addTo(this.map)

    L.tileLayer("https://{s}.basemaps.cartocdn.com/dark_only_labels/{z}/{x}/{y}{r}.png", {
      subdomains: "abcd",
      maxZoom: 20
    }).addTo(this.map)

    this.pinsValue.forEach(pin => {
      L.marker([pin.lat, pin.lng])
        .addTo(this.map)
        .on('click', () => {
          this.map.flyTo([pin.lat, pin.lng], 15)
          this.loadSidebar(pin.id)
        })
    });
  }

  loadSidebar(pinId) {
    this.sidebarFrameTarget.src = `/pins/${pinId}`
    this.openSidebar()
  }

  openSidebar() {
    this.sidebarTarget.dataset.state = "open"
    this.sidebarTarget.setAttribute("aria-hidden", "false")
  }

  closeSidebar() {
    this.sidebarTarget.dataset.state = "closed"
    this.sidebarTarget.setAttribute("aria-hidden", "true")
  }

  disconnect() {
    this.map?.remove()
  }
}
