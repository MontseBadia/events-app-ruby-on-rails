require 'rails_helper'

describe "Signing in" do 
  it "prompts for an email and password" do 
    visit root_path

    click_link "Sign in"

    expect(current_path).to eq(signin_path)
    expect(find_field('Email').value).to eq(nil)
    expect(find_field('Password').value).to eq(nil)
  end

  it "signs in the user if the email/password combination is valid" do
    user = User.create!(user_attributes)

    visit signin_path
    
    fill_in "Email", with: user.email
    fill_in "Password", with: user.password

    click_button "Sign In"

    expect(current_path).to eq(user_path(user))
    expect(page).to have_text("Welcome back, #{user.name}!")

    expect(page).to have_link(user.name)
    expect(page).to have_link('Sign out')
    expect(page).not_to have_link('Sign in')
    expect(page).not_to have_link('Sign up')
  end

  it "does not sign in the user if the email/password combination is not valid" do 
    user = User.create!(user_attributes)

    visit signin_path
    
    fill_in "Email", with: user.email
    fill_in "Password", with: 'otherthing'

    click_button "Sign In"

    expect(page).to have_text("Invalid")

    expect(page).not_to have_link(user.name)
    expect(page).not_to have_link('Sign out')
    expect(page).to have_link('Sign in')
    expect(page).to have_link('Sign up')
  end

  it "redirects to intended page" do
    user = User.create!(user_attributes)
    
    visit users_url

    expect(current_path).to eq(new_session_path)

    sign_in(user)

    expect(current_path).to eq(users_path)
  end
end