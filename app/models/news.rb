class News < ApplicationRecord
  belongs_to :user
  belongs_to :imageable, :polymorphic => true, optional: true
  after_create :write_content

  def write_content
    user_link = "<a href='/user/#{user.id}'>#{user.first_name}</a>"
    trip_link = "<a href='/trips/#{trip_id}'>#{Trip.find(trip_id).name}</a>"
    case action_type 
    when "trips#update"
      update(content: "#{user_link} a défini une nouvelle destination : #{Trip.find(trip_id).destination}")
    when "trips#create"
      update(content: "#{user_link} a créé #{trip_link}")
    when "invites#create", "users/registrations#create"
      update(content: "#{user_link} a rejoint le trip")
    when "participants#destroy"
      update(content: "#{user_link} a quitté #{trip_link}")
    when "rooms#create"
      room_link = "<a href='/trips/#{trip_id}/rooms/#{imageable_id}'>#{Room.find(imageable_id).name}</a>"
      update(content: "#{user_link} a ajouté #{room_link}")
    when "rooms#like"
      room_link = "<a href='/trips/#{trip_id}/rooms/#{imageable_id}'>#{Room.find(imageable_id).name}</a>"
      update(content: "#{user_link} a aimé #{room_link}")
    when "rooms#unlike"
      room_link = "<a href='/trips/#{trip_id}/rooms/#{imageable_id}'>#{Room.find(imageable_id).name}</a>"
      update(content: "#{user_link} n'aime plus #{room_link}")
    when "reviews#create", "reviews#update"
      review = Review.find(imageable_id)
      room = review.room
      room_link = "<a href='/trips/#{trip_id}/rooms/#{room.id}'>#{room.name}</a>"
      update(content: "#{user_link} a donné #{review.score} étoiles à #{room_link}")
    else
      update(content: "Autre info")
    end
  end
end
