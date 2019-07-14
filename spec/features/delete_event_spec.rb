require "rails_helper"

describe "Deleting an event" do #how is this working if link delete does not work?
  before do  
    admin = User.create(user_attributes(admin: true))
    sign_in(admin)
  end
  
  it "deletes the event and shows the listing page" do 
    event = Event.create(event_attributes(name: 'Yepa'))

    visit event_path(event)

    click_link 'Delete'

    expect(current_path).to eq(events_path)
    expect(page).not_to have_text(event.name)
    expect(page).to have_text("Event successfully deleted!")
  end
end
