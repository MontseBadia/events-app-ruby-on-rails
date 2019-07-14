Rails.application.routes.draw do
  # get "free_events" => "events#index_free_events"

  resources :categories
  get "signin" => "sessions#new"
  resource :session #--> singular resource, controller is called sessions
  
  get "signup" => "users#new"
  resources :users
  # get "events" => "events#index"
  # get "events/new" => "events#new"
  # get "events/:id" => "events#show", as: "event"
  # get "events/:id/edit" => "events#edit", as: "edit_event"
  # patch "events/:id" => "events#update"
  
  # %w(past free).each do |scope|
  #   get "events/#{scope}" => "events#index", scope: scope
  # end
  
  # get "events/past" => "events#index", scope: "past" #--> needs to be before resources :events
  # get "events/free" => "events#index", scope: "free"

  # get "events/:scope" => "events#index", constraints: { scope: /past|free/ } 

  root "events#index"   
  get "events/filter/:scope" => "events#index", as: :filtered_events

  resources :events do
    resources :registrations
    resources :likes
  end
end
