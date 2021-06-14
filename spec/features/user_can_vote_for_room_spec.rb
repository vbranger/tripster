require 'rails_helper'

feature "User access vote page for room" do
  context "when aasm(room_state) => votes" do
    scenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", aasm_state: "votes")
      create(:participant, user: user, trip: trip)
      4.times { create(:room, trip: trip) }

      visit trip_rooms_path(trip)
      expect(page).to have_css 'strong', text: 'Mon classement'
    end
  end
  context "when aasm(room_state) => propositions" do
    scenario "unsuccessfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", aasm_state: "propositions")

      visit trip_rooms_path(trip)
      expect(page).not_to have_css 'strong', text: 'Mon classement'
    end
  end
end
