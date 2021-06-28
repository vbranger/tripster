require 'rails_helper'

xfeature "User can add a room index" do
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

feature "User can cancel room creation" do
  context "from edit page after scrap" do
    scenario "successfully" do 
      sign_in
      trip = create(:trip, aasm_state: "propositions")
      room = create(:room, name: "Maison en bord de mer", trip: trip)
      p room
      p trip.rooms
      visit new_trip_room_path(trip)
      fill_in "room_url", with: "https://www.booking.com/hotel/it/residence-150.fr.html"
      find('.btn-primary').click
      click_on('back-btn')
      expect(page).not_to have_content('Ferrini')
      expect(page).to have_content('Maison en bord de mer')
    end
  end
end
