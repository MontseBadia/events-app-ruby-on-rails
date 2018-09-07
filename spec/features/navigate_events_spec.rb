require "rails_helper"

describe "navigating events" do
  it "allows navigation from detail page to listing page" do
    event = Event.create(event_attributes)

    visit event_url(event)

    click_link "All Events"

    expect(current_path).to eq(events_path)
  end

  it "allows navigation from listing page to detail page" do
    event = Event.create(event_attributes)

    visit events_url

    click_link event.name

    expect(current_path).to eq(event_path(event))
  end

  it "allows navigation from detail page to edit page" do
    event = Event.create(event_attributes)

    visit event_url(event)

    click_link "Edit"

    expect(current_path).to eq(edit_event_path(event))
  end

  it "allows navigation from listing page to create event" do
    event = Event.create(event_attributes)

    visit events_url

    click_link "Add New Event"

    expect(current_path).to eq(new_event_path)    
  end

  it "allows navigation from create event page to listing page" do
    event = Event.create(event_attributes)

    visit new_event_url

    click_link "Cancel"

    expect(current_path).to eq(events_path)    
  end

  it "allows navigation from edit event page to listing page" do
    event = Event.create(event_attributes)

    visit edit_event_url(event)

    click_link "Cancel"

    expect(current_path).to eq(events_path)    
  end
end