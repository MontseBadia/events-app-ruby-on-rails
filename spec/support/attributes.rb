def event_attributes(overrides = {})
  {
    name: "BugSmash",
    location: "Denver",
    price: 10.00,
    description: 'A fun evening of fdksaf fdksajf fjdsjfmlf ftueo j dsafdsf fdsafsa.',
    starts_at: 10.days.from_now,  
    capacity: 1,
    image_file_name: 'avatar.png'
  }.merge(overrides)
end

def registration_attributes(overrides = {})
  {
    # name: "Paquito",
    # email: "paquito@paquito.com",
    how_heard: 'Newsletter'
  }.merge(overrides)
end

def user_attributes(overrides = {})
  {
    name: 'Mark',
    username: 'markito2periquito',
    email: 'mark@mark.com',
    password: 'secret123456',
    password_confirmation: 'secret123456'
  }.merge(overrides)
end
