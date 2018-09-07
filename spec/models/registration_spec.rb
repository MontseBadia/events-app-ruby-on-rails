require 'rails_helper'

describe "A registration" do 
  it "belongs to an event" do
    event = Event.new(event_attributes)

    registration = event.registrations.new(registration_attributes)

    expect(registration.event).to eq(event)
  end

  it "with example attributes is valid" do 
    event = Event.new(event_attributes)

    registration = Registration.new(registration_attributes)

    registration.event = event

    expect(registration.valid?).to eq(true)
  end

  it "requires a name" do 
    registration = Registration.new(name: '')

    registration.valid?

    expect(registration.errors[:name].any?).to eq(true)
  end
  
  it "requires an email" do 
    registration = Registration.new(email: '')

    registration.valid?

    expect(registration.errors[:email].any?).to eq(true)
  end

  it "requires a how heard" do 
    registration = Registration.new(how_heard: '')

    registration.valid?

    expect(registration.errors[:how_heard].any?).to eq(true)
  end

  it "rejects an incorrect value of how heard" do 
    registration = Registration.new(how_heard: 'mama')

    registration.valid?

    expect(registration.errors[:how_heard].any?).to eq(true)
  end

  it "accepts a correct value for how heard" do 
    how_heard = [    
      'Newsletter',
      'Blog Post',
      'Twitter',
      'Web Search',
      'Friend/Coworker',
      'Other'
    ]
    how_heard.each do |value| 
      registration = Registration.new(how_heard: value)

      registration.valid?

      expect(registration.errors[:how_heard].any?).to eq(false)
    end
  end
end