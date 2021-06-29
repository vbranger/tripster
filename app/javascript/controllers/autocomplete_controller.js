import { Controller } from "stimulus";

export default class extends Controller {

  connect() {
    console.log("connected");
  }

  search(e) {
    var autocomplete = new google.maps.places.Autocomplete(e.target);

    autocomplete.setFields(["place_id", "name"]);

    google.maps.event.addListener(autocomplete, 'place_changed', function() {
      var place = autocomplete.getPlace();
      const body = document.querySelector('body')
      body.insertAdjacentHTML('afterend', '<div id="details"></div>')
      const details = document.getElementById('details')
      const service = new google.maps.places.PlacesService(details);
      service.getDetails({placeId: place.place_id},function(PlaceResult, PlacesServiceStatus){
        document.getElementById("trip_photo_url").value = PlaceResult.photos[0].getUrl()
      });
  
    });
  }

}