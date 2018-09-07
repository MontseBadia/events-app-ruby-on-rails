Rails.application.routes.draw do
  # get "events" => "events#index"
  # get "events/new" => "events#new"
  # get "events/:id" => "events#show", as: "event"
  # get "events/:id/edit" => "events#edit", as: "edit_event"
  # patch "events/:id" => "events#update"
  
  root "events#index"  
  resources :events do
    resources :registrations
  end
end
