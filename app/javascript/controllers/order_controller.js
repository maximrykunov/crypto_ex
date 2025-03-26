import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="order"
export default class extends Controller {
  static targets = ["send_amount", "price", "base_commision", "base_miner_fee", "you_get", "fee_text"]

  updateTotal() {
    console.log('xxxxxxxxxxx start');
    let send_amount = parseFloat(this.send_amountTarget.value) || 0;
    let price = parseFloat(this.priceTarget.value) || 0;
    let commision = parseFloat(this.base_commisionTarget.value) || 0;
    let miner_fee = parseFloat(this.base_miner_feeTarget.value) || 0;
    let mul = Number((send_amount * price).toFixed(8));
    let fee = Number((mul * commision).toFixed(8));
    let you_get = Number((mul - fee - miner_fee).toFixed(8));
    console.log('xxxxxxxxxxx', price);
    this.you_getTarget.value = `${you_get}`;
    this.fee_textTarget.textContent = `${fee}`;
  }

  say_hello() {
    console.log('xxxxxxxxxxx');
    this.element.textContent = "Hello Orders Controller"
  }

  connect() {
    console.log("Контроллер 'order' был подключён.");
    this.updateTotal();
  }
}