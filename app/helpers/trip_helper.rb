module TripHelper
  def trip_image(trip)
    trip.photo_url? ? trip.photo_url : "undraw_around.svg"
  end

  def trip_background_class(trip)
    trip.photo_url? ? "trip_background" : "trip_background_generic"
  end
end