# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

if Event.all.empty?
  Event.create!([
    {
      name: "BugSmash",
      location: "Texas",
      price: 0.00,
      description: "Join us a sfkfdls jfkdsfsf djfei ffdsf ls fjsdkfj sjfjf dsjff",
      starts_at: 100.days.from_now
    },
    {
      name: "Kata Camp",
      location: "Texas",
      price: 10.00,
      description: "Join us a sfkfdls jfkdsfsf djfei ffdsf ls fjsdkfj sjfjf dsjff",
      starts_at: 100.days.from_now
    }, 
    {
      name: "Hackathon",
      location: "Texas",
      price: 76.00,
      description: "Join us a sfkfdls jfkdsfsf djfei ffdsf ls fjsdkfj sjfjf dsjff",
      starts_at: 100.days.from_now
    }, 
    {
      name: "TheCity",
      location: "Texas",
      price: 0.00,
      description: "Join us a sfkfdls jfkdsfsf djfei ffdsf ls fjsdkfj sjfjf dsjff",
      starts_at: 100.days.from_now
    }
  ])
end

event = Event.find_by(name: "Kata Camp")
event.registrations.create(name: 'Moe', email: 'moe@moe.com', how_heard: 'Newsletter')
event.registrations.create(name: 'Larry', email: 'larry@larry.com', how_heard: 'Twitter')
event.registrations.create(name: 'Curly', email: 'curly@curly.com', how_heard: 'Web Search')
event = Event.find_by(name: "TheCity")
event.registrations.create(name: 'Curly', email: 'curly@curly.com', how_heard: 'Web Search')