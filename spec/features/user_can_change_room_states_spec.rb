require 'rails_helper'

feature "User change room states" do
  context "from not_started to propositions" do
    xscenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, aasm_state: "not_started")
      visit trip_path(trip)
      within find('#hp_room_card') do
        find('.btn').click
      end
      expect(page).to have_css '.home_card a', text: 'Voir'
    end
  end
  context "from propositions to votes" do
    scenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", aasm_state: "propositions")
      4.times { create(:room) }
      visit trip_rooms_path(trip)
      click_on "Voter"

      expect(page).to have_css 'strong', text: 'Mon classement'
    end
  end
  context "from draw to choosen" do
    scenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", aasm_state: "draw")
      rooms = []
      2.times { rooms << create(:room, trip: trip) }
      trip.update(choosen_room_ids: rooms.map(&:id))
      visit trip_rooms_path(trip)

      trip.choosen_room_ids.map {|id| Room.find(id)}
      first(".btn-primary").click


      expect(page).to have_css 'button', text: 'Confirmer'
    end
  end
  context "from choosen to booked" do
    scenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", aasm_state: "choosen")
      room = create(:room, trip: trip)
      trip.update(choosen_room_ids: [room.id])
      visit trip_rooms_path(trip)

      first(".btn-outline-primary").click

      expect(page).to have_css 'p', text: 'Votre réservation est confirmée !'
    end
  end
end
