require 'rails_helper'

describe EventsController do
  before do
    @event = Event.create!(event_attributes)
  end

  context "when not admin user" do
    before do
      user = User.create!(user_attributes)
      session[:user_id] = user.id #--> controller cannot do sign_in(user)
    end

    it "cannot acces new event" do  
      get :new
      expect(response).to redirect_to(root_url) #--> root_url cause require_admin redirects to root_url
    end

    it "cannot acces create event" do  
      post :create
      expect(response).to redirect_to(root_url)
    end

    it "cannot acces edit event" do  
      get :edit, params: { id: @event }
      expect(response).to redirect_to(root_url)
    end

    it "cannot acces update event" do  
      patch :update, params: { id: @event }
      expect(response).to redirect_to(root_url)
    end

    it "cannot acces destroy event" do  
      delete :destroy, params: { id: @event }
      expect(response).to redirect_to(root_url)
    end
  end
end