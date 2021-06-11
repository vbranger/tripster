require 'rails_helper'

feature "User creates a trip" do
  scenario "successfully" do
    sign_in
    click_on "+"
    fill_in "trip_name", with: "nouveau voyage test"
    click_on "Suite"
    click_on "Suite"
    click_on "Suite"
    expect(page).to have_css 'p', text: 'nouveau voyage test'
  end
end

feature "User can destroy a trip" do
  context "trip belongs to user" do
    scenario "Trip can be destroyed" do
      user = sign_in
      trip = create(:trip, user: user, name: "test")
      visit trip_path(trip)
      click_on "Supprimer ce trip"
      expect(page).not_to have_css 'p', text: "test"
    end
  end

  context "trip do not belongs to user" do
    scenario "Trip can't be destroyed" do
      sign_in
      other_user = create(:user, email: "other_user@example.fr")
      trip = create(:trip, user: other_user, name: "test")

      visit trip_path(trip)
      expect(page).not_to have_css 'a', text: "Supprimer ce trip"
    end
  end
end
