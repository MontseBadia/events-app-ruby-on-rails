require 'rails_helper'

describe "Viewing the list of registrations per event" do 
  before do
    @user = User.create!(user_attributes)
    sign_in(@user)
  end

  it "shows the registrations" do 
    event = Event.create(event_attributes)

    registration1 = event.registrations.new(how_heard: 'Newsletter')
    user1 = User.create!(name: 'Mark1', username: 'markito2periquito1',
            email: 'mark@mark1.com', password: 'secret1234561',
            password_confirmation: 'secret1234561')
    registration1.user = user1
    registration1.save

    registration2 = event.registrations.new(how_heard: 'Newsletter')
    user2 = User.create!(name: 'Mark2', username: 'markito2periquito2',
            email: 'mark@mark2.com', password: 'secret1234562',
            password_confirmation: 'secret1234562')
    registration2.user = user2
    registration2.save

    visit event_registrations_path(event)

    # expect(page).to have_text(registration1.name)
    # expect(page).to have_text(registration2.name)
    # expect(page).to have_text(registration3.name)
    expect(page).to have_text(registration1.how_heard)
    expect(page).to have_text(registration2.how_heard)
  end

  it "does not show the registrations for other events" do 
    event1 = Event.create(event_attributes(name: 'KC'))
    registration1 = event1.registrations.new(how_heard: 'Newsletter')
    user1 = User.create!(name: 'Mark1', username: 'markito2periquito1',
            email: 'mark@mark1.com', password: 'secret1234561',
            password_confirmation: 'secret1234561')
    registration1.user = user1
    registration1.save

    event2 = Event.create(event_attributes(name: 'LA', slug: 'l'))
    registration2 = event2.registrations.new(how_heard: 'Newsletter')
    user2 = User.create!(name: 'Mark2', username: 'markito2periquito2',
            email: 'mark@mark2.com', password: 'secret1234562',
            password_confirmation: 'secret1234562')
    registration2.user = user2
    registration2.save

    visit event_registrations_path(event2)

    expect(page).to have_text(registration2.user.name)
    expect(page).not_to have_text(registration1.user.name)
  end
end