require "rails_helper"

describe "An event" do
  it "is free if the price is $0" do
    event = Event.new(price: 0) #.new but not .create cause no need to save in db ¿

    expect(event.free?).to eq(true)
  end  

  it "is not free if the price is not $0" do
    event = Event.new(price: 10.00)

    expect(event.free?).to eq(false)
  end  

  it "is free if the price is blank" do
    event = Event.new(price: nil)

    expect(event.free?).to eq(true)
  end  

  it "requires a name" do
    event = Event.new(name: '')

    event.valid?
    expect(event.errors[:name].any?).to eq(true)
  end

  it "requires a location" do
    event = Event.new(location: '')

    event.valid?
    expect(event.errors[:location].any?).to eq(true)
  end

  it "requires a description" do
    event = Event.new(description: '')

    event.valid?
    expect(event.errors[:description].any?).to eq(true)
  end

  it "requires a description longer than 25 characters" do
    event = Event.new(description: 'ade')

    event.valid?
    expect(event.errors[:description].any?).to eq(true)
  end

  it "requires a price" do
    event = Event.new(price: nil)

    event.valid?
    expect(event.errors[:price].any?).to eq(true)
  end

  it "accepts a price of 0" do
    event = Event.new(price: 0)

    event.valid?
    expect(event.errors[:price].any?).to eq(false)
  end

  it "accepts a price greater than 0" do
    event = Event.new(price: 10)

    event.valid?
    expect(event.errors[:price].any?).to eq(false)
  end

  it "requires a price greater than 0" do
    event = Event.new(price: -1)

    event.valid?
    expect(event.errors[:price].any?).to eq(true)
  end

  it "requires a capacity" do
    event = Event.new(capacity: nil)

    event.valid?
    expect(event.errors[:capacity].any?).to eq(true)
  end

  
  it "requires a capacity greater than 0" do
    event = Event.new(capacity: -1)

    event.valid?
    expect(event.errors[:capacity].any?).to eq(true)
  end

  it "requires a capacity as an integer value" do
    event = Event.new(capacity: 1.06)

    event.valid?
    expect(event.errors[:capacity].any?).to eq(true)
  end

  it "accepts properly formatted image file names" do
    file_names = %w[e.png event.png event.jpg event.gif event.GIF] #--> REVISE
    file_names.each do |file_name|
      event = Event.new(image_file_name: file_name)
      event.valid?
      expect(event.errors[:image_file_name].any?).to eq(false)
    end
  end
  
  it "rejects improperly formatted image file names" do
    file_names = %w[event .jpg .png .gif event.pdf event.doc] # --> REVISE
    file_names.each do |file_name|
      event = Event.new(image_file_name: file_name)
      event.valid?
      expect(event.errors[:image_file_name].any?).to eq(true)
    end
  end

  it "is valid with example attributes" do 
    event = Event.new(event_attributes)

    expect(event.valid?).to eq(true)
  end

  it "has many registrations" do  
    event = Event.new(event_attributes)

    registration1 = event.registrations.new(registration_attributes)
    registration2 = event.registrations.new(registration_attributes)

    expect(event.registrations).to include(registration1)
    expect(event.registrations).to include(registration2)
  end

  it "deletes associated registrations" do  
    event = Event.create(event_attributes)

    event.registrations.create(registration_attributes)

    expect{event.destroy}.to change(Registration, :count).by(-1)
  end

  it "calculates the spots available for the event" do
    event = Event.create(event_attributes)

    registration = event.registrations.new(registration_attributes)

    expect(event.spots_left).to eq(0)
  end

  it "finds out whether the event is sold out" do
    event = Event.create(event_attributes)

    registration = event.registrations.new(registration_attributes)

    expect(event.sold_out?).to eq(true)
  end
end

describe "Events are shown" do 
  it "if they take place in the future" do 
    event = Event.create(event_attributes(starts_at: 1.month.from_now)) #needs to be Event.create!!!

    expect(Event.upcoming).to include(event) #result of the method includes...
  end

  it "if they took place in the past" do
    event = Event.create(event_attributes(starts_at: 1.month.ago))
    
    expect(Event.upcoming).not_to include(event)
  end

  it "in ascending order as of when they are taking place" do 
    event1 = Event.create(event_attributes(starts_at: 1.month.from_now))
    event2 = Event.create(event_attributes(starts_at: 2.month.from_now))
    event3 = Event.create(event_attributes(starts_at: 3.month.from_now))

    expect(Event.upcoming).to eq([event1, event2, event3])
  end
end