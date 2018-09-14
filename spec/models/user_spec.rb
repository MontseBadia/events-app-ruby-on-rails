require 'rails_helper'

RSpec.describe User, type: :model do
  it "is valid with example attributes" do
    user = User.new(user_attributes)

    expect(user.valid?).to eq(true)  
  end

  it "requires a name" do
    user = User.new(name: '')

    user.valid?
    expect(user.errors[:name].any?).to eq(true)
  end

  it "requires an email" do 
    user = User.new(email: '')

    user.valid?
    expect(user.errors[:email].any?).to eq(true)
  end

  it "accepts properly formatted email addresses" do
    emails = %w[user@example.com first.last@example.com] #--> shortcut to create an array
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(false)
    end
  end

  it "rejects improperly formatted email addresses" do
    emails = %w[@ user@ @example.com]
    emails.each do |email|
      user = User.new(email: email)
      user.valid?
      expect(user.errors[:email].any?).to eq(true)
    end
  end

  it "requires a unique, case insensitive email address" do
    user1 = User.create!(user_attributes)

    user2 = User.new(email: user1.email.upcase)
    user2.valid?
    expect(user2.errors[:email].first).to eq("has already been taken")
  end

  it "requires a password" do
    user = User.new(password: '')

    user.valid?
    expect(user.errors[:password].any?).to eq(true) 
  end

  it "requires a password with 10 characters as minimum length" do
    user = User.new(password: '123gfd')

    user.valid?
    expect(user.errors[:password].any?).to eq(true) 
  end

  it "acceots a password with 10 or more characters" do
    user = User.new(password: '12345678910')

    user.valid?
    expect(user.errors[:password].any?).to eq(false) 
  end

  it "requires a password confirmation when a password is present" do
    user = User.new(password: 'secret', password_confirmation: '')

    user.valid?
    expect(user.errors[:password_confirmation].any?).to eq(true) 
  end

  it "requires a password to match the password confirmation" do
    user = User.new(password: 'secret', password_confirmation: 'anotherpass')

    user.valid?
    expect(user.errors[:password_confirmation].first).to eq("doesn't match Password") 
  end

  it "requires a password that matches the password confirmation" do
    user = User.new(password: 'secret', password_confirmation: 'secret')

    user.valid?
    expect(user.errors[:password_confirmation].any?).to eq(false)  
  end

  it "automatically encrypts the password into password_digest" do
    user = User.new(password: 'secret')

    expect(user.password_digest.present?).to eq(true)  
  end

  it "does not require a password when updating" do 
    user = User.create!(user_attributes)

    user.password = ''
    expect(user.valid?).to eq(true) 
  end
  
  it "has registrations" do
    user = User.create(user_attributes)
    event1 = Event.create(event_attributes(name: 'KC'))
    event2 = Event.create(event_attributes(name: 'LA', slug: 'l'))

    registration1 = event1.registrations.new(how_heard: 'Newsletter')
    registration1.user = user
    registration1.save

    registration2 = event2.registrations.new(how_heard: 'Newsletter')
    registration2.user = user
    registration2.save

    expect(user.registrations).to include(registration1)
    expect(user.registrations).to include(registration2)
  end
end

describe "authenticate" do
  before do
    @user = User.create!(user_attributes)
  end 

  it "returns non-true value if the email does not match" do 
    expect(User.authenticate('nomatch', @user.password)).not_to eq(true)
  end

  it "returns non-true value if the password does not match" do 
    expect(User.authenticate(@user.email, 'nomatch')).not_to eq(true)
  end

  it "returns the user if the email and password match" do 
    expect(User.authenticate(@user.email, @user.password)).to eq(@user)
  end

  it "has liked_events" do  
    event1 = Event.create!(event_attributes)
    event2 = Event.create!(event_attributes(name: 'A', slug: 'l'))

    # user.likes.create!(event: event1)
    # user.likes.create!(event: event2)

    event1.likes.create!(user: @user)
    event2.likes.create!(user: @user)

    expect(@user.liked_events).to include(event1)
    expect(@user.liked_events).to include(event2)
  end
end