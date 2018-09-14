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
    
    registration1 = event.registrations.new(how_heard: 'Newsletter')
    user1 = User.create!(name: 'Mark1', username: 'markito2periquito1',
            email: 'mark@mark1.com', password: 'secret1234561',
            password_confirmation: 'secret1234561')
    registration1.user = user1
    registration1.save

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

  it "has likers" do  
    event = Event.new(event_attributes)

    user1 = User.new(user_attributes)
    user2 = User.new(user_attributes(name: 'paquito', username: 'paquito', email: 'paquito@paquito.com'))

    event.likes.new(user: user1)
    event.likes.new(user: user2)

    expect(event.likers).to include(user1)
    expect(event.likers).to include(user2)
  end

  context "upcoming query" do 
    before do
      @event1 = Event.create!(event_attributes(name: 'L', starts_at: 1.month.ago))
      @event2 = Event.create!(event_attributes(name: 'M', starts_at: 2.month.from_now))
    end

    it "returns events that will happen in the future" do
      expect(Event.upcoming).to include(@event2)
    end
  end

  context "past query" do 
    before do
      @event1 = Event.create!(event_attributes(name: 'M', starts_at: 1.month.ago))
      @event2 = Event.create!(event_attributes(name: 'L', starts_at: 2.month.from_now))
    end

    it "returns events that happened in the past" do
      expect(Event.past).to include(@event1)
    end
  end

  context "recent query" do 
    before do
      @event1 = Event.create!(event_attributes(name: 'M', starts_at: 1.month.ago))
      @event2 = Event.create!(event_attributes(name: 'L', starts_at: 2.month.from_now))
    end

    it "returns events that happened in the recent past" do
      expect(Event.recent).to include(@event1)
    end
  end

  context "free query" do 
    before do
      @event1 = Event.create!(event_attributes(name: 'L', starts_at: 1.month.ago, price: 10))
      @event2 = Event.create!(event_attributes(name: 'M', starts_at: 2.month.from_now, price: 0))
    end

    it "returns events that will come in the future and are free" do
      expect(Event.free).to include(@event2)
    end
  end

  it "generates a slug attribute when it is created" do
    event = Event.create!(event_attributes(name: 'Tomorrow Crazy'))

    expect(event.slug).to eq("tomorrow-crazy")
  end

  it "requires a unique name" do
    event1 = Event.create!(event_attributes(name: 'One'))
    event2 = Event.new(event_attributes(name: 'One'))

    event2.valid?
    expect(event2.errors[:name].first).to eq("has already been taken")
  end

  it "requires a unique slug" do
    event1 = Event.create!(event_attributes(slug: 'one'))
    event2 = Event.new(event_attributes(slug: 'one'))

    event2.valid?
    expect(event2.errors[:slug].first).to eq("has already been taken")
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
    event1 = Event.create(event_attributes(name: 'M', starts_at: 1.month.from_now))
    event2 = Event.create(event_attributes(name: 'G', starts_at: 2.month.from_now))
    event3 = Event.create(event_attributes(name: 'P', starts_at: 3.month.from_now))

    expect(Event.upcoming).to include(event1, event2, event3) #--> needs to be eq and not include
  end
end