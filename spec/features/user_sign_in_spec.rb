require 'rails_helper'
#test ici 

feature "User can log in" do
  context "user is logged" do
    scenario "successfully" do
      sign_in
      visit root_path
      expect(page).to have_css '.btn-circle'
    end
  end

  context "user is not logged" do
    scenario "successfully" do
      visit root_path

      expect(page).to have_css 'h1', text: 'Organisez facilement vos vacances en groupe'
    end
  end
end