module Features
  def sign_in
    sign_in_as "person@example.com"
  end

  def sign_in_as(email)
    user = create(:user, email: email)
    visit root_path
    find_link("Se connecter").click
    fill_in "Email", with: user.email
    fill_in 'user_password', with: user.password
    click_on "Se connecter"
    user
  end
end
