require "rails_helper"

describe "viewing an individual event" do
  it "shows the event's details" do
    event = Event.create(event_attributes(price: 10.00))

    visit event_url(event)

    expect(page).to have_text(event.name)
    expect(page).to have_text(event.location)
    # expect(page).to have_text("$10.00")
    expect(page).to have_text(event.description)
    expect(page).to have_text(event.starts_at)
    expect(page).to have_text(event.capacity)
    expect(page).to have_css("img[src*='avatar.png']") # ---> finds img tag with src = 'avatar.png'
  end

  it "shows the price if the price is not $0" do 
    event = Event.create(event_attributes(price: 20.00))

    visit event_url(event)

    expect(page).to have_text("$20.00")
  end

  it "shows 'Free' if the price is $0" do
    event = Event.create(event_attributes(price: 0.00))

    visit event_url(event)

    expect(page).to have_text("Free")
  end

  it "displays the event likers and categories in the sidebar" do 
    event = Event.create(event_attributes)
    category = Category.create!(name: 'Rails')
    user = User.create!(user_attributes)
    sign_in(user)

    event.likers << user
    event.categories << category

    visit event_path(event)

    within("aside#sidebar") do 
      expect(page).to have_text(user.name)
      expect(page).to have_text(category.name)
    end
  end

  it "includes event title in the page title" do
    event = Event.create(event_attributes(name: 'Yepa'))

    visit event_path(event)
    expect(page).to have_title("Events - #{event.name}")
  end

  it "has a friendly URL" do
    event = Event.create!(event_attributes(name: 'Tomorrow Crazy'))

    visit event_path(event)
    expect(current_path).to eq("/events/tomorrow-crazy")
  end
end
