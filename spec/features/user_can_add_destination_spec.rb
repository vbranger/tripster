require 'rails_helper'

feature "User can add a destination" do
  context "when aasm(destination_state) => propositions" do
    scenario "successfully" do
      user = sign_in
      trip = create(:trip, user: user, name: "test", destination_state: "propositions")
      visit trip_path(trip)
      click_on 'Destination'
      click_on "Ajouter"
      fill_in "name", with: "Cotignac"
      find('.btn-primary').click
      expect(page).to have_content('Cotignac')
    end
  end
end