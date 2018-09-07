require "rails_helper"

describe "edit an event" do 
  it "will display event details" do
    event = Event.create(event_attributes)

    visit edit_event_url(event)

    expect(page).to have_text(event.name)
    expect(find_field('Name').value).to eq(event.name)
    expect(find_field('Location').value).to eq(event.location)
    expect(find_field('Description').value).to eq(event.description)
    expect(find_field('Price').value).to eq("#{event.price}") #--> important to pass as string
    # expect(find_field('starts_at').value).to eq(event.starts_at) --> find out how to fix it
  end

  it "updates the event and shows the event's updated details" do
    event = Event.create(event_attributes)

    visit edit_event_path(event)

    expect(find_field('Name').value).to eq(event.name)

    fill_in 'Name', with: "Updated Event Name"

    click_button 'Update Event'

    expect(current_path).to eq(event_path(event))
    expect(page).to have_text("Updated Event Name")
    expect(page).to have_text("Event successfully updated!")
  end

  it "does not update the event if any field is invalid" do  
    event = Event.create(event_attributes)

    visit edit_event_path(event)

    fill_in 'Name', with: ''
    click_button 'Update Event'

    expect(current_path).to eq(current_path)
    expect(page).to have_text('error')
  end
end