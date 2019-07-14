require "rails_helper"

describe "Creating a new event" do 
  before do  
    admin = User.create(user_attributes(admin: true))
    sign_in(admin)

    @category1 = Category.create!(name: 'Social')
    @category2 = Category.create!(name: 'User Group')
    @category3 = Category.create!(name: 'Homie')
  end
  
  it "saves the event and shows the new event's details" do 
    event = Event.create(event_attributes)

    visit new_event_path(event)

    expect(find_field('Name').value).to eq(nil)
    expect(find_field('Capacity').value).to eq("1") # ---> 1 has to be passed as string
    # expect(find_field('Image file name').value).to eq("")

    fill_in 'Name', with: "New Event Name"
    fill_in 'Capacity', with: "3"
    fill_in 'Description', with: "fdsklafj dsafkd jfjd dlsjf kjl"
    fill_in 'Location', with: "Barcelona"
    fill_in 'Price', with: 10.00

    check(@category1.name) #--> capybara checks the box!
    check(@category2.name)

    click_button 'Create Event'

    expect(current_path).to eq(event_path(Event.last))
    expect(page).to have_text("New Event Name")
    expect(page).to have_text("3")
    expect(page).to have_text("Event successfully created!")
    expect(page).to have_text(@category1.name)
    expect(page).to have_text(@category2.name)
    expect(page).not_to have_text(@category3.name)
  end

  it "does not save the event if it is not valid" do
    visit new_event_path

    click_button 'Create Event'

    expect(current_path).to eq(current_path)
    expect(page).to have_text('error')
  end
end