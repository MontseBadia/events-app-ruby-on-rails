require 'rails_helper'

describe "Creating a new user" do
  it "saves the user and shows the user's profile page" do
    user = User.create(user_attributes)

    visit root_url

    click_link 'Sign up'

    expect(current_path).to eq(signup_path)

    fill_in "Name",  with: "Example User"
    fill_in "Username", with: "Itsmeamigo"
    fill_in "Email", with: "user@example.com"
    fill_in "Password", with: "secret123456"
    fill_in "Confirm password", with: "secret123456"

    click_button 'Create Account'

    expect(current_path).to eq(user_path(User.last))

    expect(page).to have_text('Example User')
    expect(page).to have_text('Thanks for signing up!')

    expect(page).to have_link('Example User')
    expect(page).not_to have_link('Sign in')
    expect(page).not_to have_link('Sign up')
  end

  it "does not save the user if it's invalid" do
    visit signup_url

    expect {
      click_button 'Create Account'
    }.not_to change(User, :count)

    expect(page).to have_text('error')
  end
end