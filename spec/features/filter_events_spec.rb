require 'rails_helper'

describe "Filtering events" do
  it "shows upcoming events" do 
    event = Event.create!(event_attributes(starts_at: 1.month.from_now))

    visit events_url

    click_link 'Upcoming Events'

    expect(current_path).to eq(events_path)
    expect(page).to have_text(event.name)
  end 

  it "shows recent events" do 
    event = Event.create!(event_attributes(starts_at: 1.month.ago))

    visit events_url

    click_link 'Recent Events'

    expect(current_path).to eq(filtered_events_path(:recent))
    expect(page).to have_text(event.name)
  end 

  it "shows past events" do 
    event = Event.create!(event_attributes(starts_at: 1.month.ago))

    visit events_url

    click_link 'Past Events'

    expect(current_path).to eq(filtered_events_path(:past))
    expect(page).to have_text(event.name)
  end

  it "shows free events" do 
    event1 = Event.create!(event_attributes(name: 'M', price: 0))
    event2 = Event.create!(event_attributes(name: 'L', price: 10, slug: 'l'))

    visit events_url

    click_link 'Free Events'

    expect(current_path).to eq(filtered_events_path(:free))
    expect(page).to have_text(event1.name)
    expect(page).not_to have_text(event2.name)
  end
end