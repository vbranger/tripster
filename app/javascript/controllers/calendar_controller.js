import { Controller } from "stimulus";


export default class extends Controller {
  static targets = ['display', 'range']

  connect() {
    this.displayTarget.textContent = "Sélectionne des dates";
    let range = document.getElementById('range_start').value
    console.log(range)
    console.log(this.rangeTarget.value)
  }

  refresh() {
    let start_date;
    let end_date;
    console.log('test')
    let range = document.getElementById('range_start').value
    console.log(range);
    // 2021-05-27 ou 2021-05-27 to 2021-05-31
    console.log(range.length)
    if (range.length === 10) {
      start_date = new Date(range)
      console.log(start_date.toLocaleDateString())
      this.displayTarget.textContent = start_date.toLocaleDateString();
    } else {
      start_date = new Date(range.substring(0,10))
      end_date = new Date(range.substring(14))
      let result = `${start_date.toLocaleDateString()} => ${end_date.toLocaleDateString()}`
      this.displayTarget.textContent = result
    }

  }

  

}
