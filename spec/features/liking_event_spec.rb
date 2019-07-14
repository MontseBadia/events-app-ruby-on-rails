require 'rails_helper'

describe "Liking an event" do
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "add a the liked event for the user and shows the unlike button" do
    event = Event.create!(event_attributes)

    visit event_url(event)

    expect(page).to have_text("0 likes")

    expect {
      click_button 'Like'
    }.to change(@user.likes, :count).by(1)

    expect(current_path).to eq(event_path(event))

    expect(page).to have_text("Glad you liked it!")
    expect(page).to have_text("1 like")
    expect(page).to have_button("Unlike")
  end

  it "remove the liked event for the user and shows the like button" do
    event = Event.create!(event_attributes)

    visit event_url(event)

    click_button 'Like'
    expect(page).to have_text("1 like")

    expect {
      click_button 'Unlike'
    }.to change(@user.likes, :count).by(-1)
    
    expect(current_path).to eq(event_path(event))

    expect(page).to have_text("Sorry!")
    expect(page).to have_text("0 likes")
    expect(page).to have_button("Like")
  end
end