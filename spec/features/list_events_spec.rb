require "rails_helper"

describe "viewing the list of events" do
  it "shows the event" do
    event1 = Event.create(name: "BugSmash",
                          location: "Denver",
                          price: 10.00,
                          description: 'A fun evening of fdksaf fdksajf fjdsjfmlf ftueo j.',
                          starts_at: 10.days.from_now)
    event2 = Event.create(name: "Hackathon",
                          location: "Texas",
                          price: 15.00,
                          description: 'A fun evening of fdksaf fdksajf fjdsjfmlf ftueo j.',
                          starts_at: 15.days.from_now)
    event3 = Event.create(name: "Kata Camp",
                          location: "Dallas",
                          price: 75.00,
                          description: 'A fun evening of fdksaf fdksajf fjdsjfmlf ftueo j.',
                          starts_at: 30.days.from_now)
    
    visit events_url

    # expect(page).to have_text("3 Events")
    expect(page).to have_text(event1.name)
    expect(page).to have_text(event2.name)
    expect(page).to have_text(event3.name)

    expect(page).to have_text(event1.location)
    expect(page).to have_text(event1.description[0..10])
    expect(page).to have_text(event1.starts_at)
    expect(page).to have_text("$10.00")
  end

  it "does not show a past event" do
    event = Event.create(event_attributes(starts_at: 1.week.ago))

    visit events_url

    expect(page).not_to have_text(event.name)
  end
end