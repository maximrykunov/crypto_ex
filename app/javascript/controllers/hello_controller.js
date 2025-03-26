import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    console.log("Hello, new Stimulus!")
    this.element.textContent = "Hello World!!!!"
  }
}
