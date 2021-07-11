require 'rails_helper'

feature "User visits homepage" do
  scenario "successfully" do
    visit root_path

    expect(page).to have_css 'h1', text: 'Organisez vos vacances à plusieurs'
  end
end
