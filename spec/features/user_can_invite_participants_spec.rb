require 'rails_helper'

feature "User can invite other participant" do
  context "when other participant is already registered" do
    scenario "other participant is added to the trip" do
      user = sign_in
      other_user = create(:user, first_name: "Florian", email: "other_user@gmail.com")
      trip = create(:trip, user: user, name: "test")
      visit trip_path(trip)
      click_on "Ajouter un participant"
      fill_in "invite_email", with: other_user.email
      click_on "Inviter"
      expect(page).to have_css 'p', text: 'Florian'
    end
  end

  context "when other participant is not registered" do
    scenario "other participant still need to register" do
      user = sign_in
      trip = create(:trip, user: user, name: "test")
      visit trip_path(trip)
      click_on "Ajouter un participant"
      fill_in "invite_email", with: "new_user@gmail.com"
      click_on "Inviter"
      expect(trip.participants.count).to eq(1)
    end
  end
end