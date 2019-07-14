require 'rails_helper'

describe UsersController do #--> no quotes around the name!!!
  before do
    @user = User.create!(user_attributes)
  end

  context "when not signed in" do
    before do
      session[:user_id] = nil
    end

    it "cannot acces index" do 
      get :index
      expect(response).to redirect_to(new_session_url)
    end

    it "cannot acces show" do 
      get :show, params: { id: @user } 
      expect(response).to redirect_to(new_session_url)
    end

    it "cannot acces edit" do 
      get :edit, params: { id: @user }
      expect(response).to redirect_to(new_session_url)
    end

    it "cannot acces update" do 
      patch :update, params: { id: @user }
      expect(response).to redirect_to(new_session_url)
    end

    it "cannot acces destroy" do 
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to(new_session_url)
    end
  end

  context "when signed in as the wrong user" do
    before do
      @wrong_user = User.create!(user_attributes(name: 'pepito', username: 'pepi', email: "dada@dada.com"))
      session[:user_id] = @wrong_user.id
    end

    it "cannot edit another user" do 
      get :edit, params: { id: @user }
      expect(response).to redirect_to(root_url)
    end

    it "cannot update another user" do
      patch :update, params: { id: @user }
      expect(response).to redirect_to(root_url)
    end

    it "cannot destroy another user" do
      delete :destroy, params: { id: @user }
      expect(response).to redirect_to(root_url)
    end
  end
end