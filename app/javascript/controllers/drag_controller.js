// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus";
import Sortable from "sortablejs";
import Rails from '@rails/ujs';


export default class extends Controller {
  static targets = ['list','row', 'rank']

  connect() {
    this.sortable = Sortable.create(this.element, {
      ghostClass: "ghost",
      animation: 150,
      onEnd: this.end.bind(this)
    })
    console.log("connecté")
    let ranks = []
    this.rowTargets.forEach(function(item) {
      ranks.push(item.dataset.id)
    })
    if (document.getElementById("ranks")) {
      document.getElementById("ranks").value = ranks;
    }

  }
  end(event) {

    this.rankTargets.forEach(function(item, index){
      item.innerText = `${index + 1}.`
    })

    let ranks = []
    this.rowTargets.forEach(function(item) {
      ranks.push(item.dataset.id)
    })
    if (document.getElementById("ranks")) {
      document.getElementById("ranks").value = ranks;
    }

  }

}
