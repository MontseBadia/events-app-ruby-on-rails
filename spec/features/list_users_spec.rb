require 'rails_helper'

describe "Viewing the list of users" do
  it "shows the users" do 
    user1 = User.create!(user_attributes(name: 'Larry', username: '12', email: 'larry@w.com'))
    user2 = User.create!(user_attributes(name: 'Moe', username: 'Maria', email: 'moe@w.com'))
    user3 = User.create!(user_attributes(name: 'Lucy', username: 'Hell123', email: 'lucy@w.com'))
    
    sign_in(user1)
    
    visit users_url

    expect(page).to have_link(user1.name)
    expect(page).to have_link(user2.name)
    expect(page).to have_link(user3.name)
  end
end