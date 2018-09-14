require 'rails_helper'

describe "Signing out" do  
  it "deletes the user id from the session" do 
    user = User.create!(user_attributes)

    sign_in(user)

    click_link 'Sign out'

    expect(page).to have_text('signed out')
    expect(page).not_to have_link('Sign out')
    expect(page).to have_link('Sign in')
  end 
end