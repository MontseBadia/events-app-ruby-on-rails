require "rails_helper"

describe "viewing an individual user" do
  it "shows the user's details" do
    user = User.create(user_attributes)

    sign_in(user)

    visit user_url(user)

    expect(page).to have_text(user.name)
    expect(page).to have_text(user.email)
  end

  it "displays the event likers and categories in the sidebar" do 
    event = Event.create(event_attributes)
    user = User.create!(user_attributes)
    sign_in(user)

    # event.likers << user
    user.liked_events << event

    visit user_path(user)

    within("aside#sidebar") do 
      expect(page).to have_text(event.name)
    end
  end

  it "includes username in the page title" do
    user = User.create!(user_attributes(name: 'Maria'))
    sign_in(user)
   
    visit user_path(user)

    expect(page).to have_title("Events - #{user.name}")
  end
end