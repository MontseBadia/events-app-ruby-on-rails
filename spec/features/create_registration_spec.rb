require 'rails_helper'

describe "Creating a new registration" do 
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "saves the registration" do 
    event = Event.create(event_attributes)

    visit event_url(event)

    click_link "Register"

    expect(current_path).to eq(new_event_registration_path(event))

    # fill_in "Name", with: "Larry"
    # fill_in "Email", with: "larry@larry.com"
    select 'Newsletter', :from => "registration_how_heard" # --> why :from with ':'?

    click_button 'Create Registration'

    expect(current_path).to eq(event_registrations_path(event))
    expect(page).to have_text("Thanks, you are registered!")

    registration = Registration.find_by(how_heard: 'Newsletter')
    expect(page).to have_text(registration.user.name)
  end

  it "does not save the registration if it's invalid" do 
    event = Event.create(event_attributes)

    visit new_event_registration_path(event)

    expect{click_button 'Create Registration'}.not_to change(Registration, :count)

    expect(page).to have_text('error')
  end
end