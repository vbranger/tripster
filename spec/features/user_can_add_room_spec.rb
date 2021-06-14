require 'rails_helper'

feature "User can add a room index" do
  context "when aasm(room_state) => propositions" do
    scenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", aasm_state: "propositions")
      visit trip_path(trip)
      within find('#hp_room_card') do
        find('.btn').click
      end
      click_on "Ajouter"
      fill_in "room_url", with: "https://www.booking.com/hotel/it/residence-150.fr.html"
      find('.btn-primary').click
      find('.btn-primary').click
      expect(page).to have_css 'a', text: 'Ecrire un avis'
    end
  end
end
