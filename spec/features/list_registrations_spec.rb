require 'rails_helper'

describe "Viewing the list of registrations per event" do 
  it "shows the registrations" do 
    event = Event.create(event_attributes)

    registration1 = event.registrations.create(name: 'Moe', email: 'moe@moe.com', how_heard: 'Newsletter')
    registration2 = event.registrations.create(name: 'Larry', email: 'larry@larry.com', how_heard: 'Newsletter')
    registration3 = event.registrations.create(name: 'Curly', email: 'curly@curly.com', how_heard: 'Newsletter')

    visit event_registrations_path(event)

    expect(page).to have_text(registration1.name)
    expect(page).to have_text(registration2.name)
    expect(page).to have_text(registration3.name)
    expect(page).to have_text(registration1.how_heard)
    expect(page).to have_text(registration2.how_heard)
    expect(page).to have_text(registration3.how_heard)
  end

  it "does not show the registrations for other events" do 
    event1 = Event.create(event_attributes(name: 'KC'))
    registration1 = event1.registrations.create(name: 'Moe', email: 'moe@moe.com', how_heard: 'Newsletter')

    event2 = Event.create(event_attributes(name: 'LA'))
    registration2 = event2.registrations.create(name: 'Larry', email: 'larry@larry.com', how_heard: 'Newsletter')

    visit event_registrations_path(event2)

    expect(page).to have_text(registration2.name)
    expect(page).not_to have_text(registration1.name)
  end
end