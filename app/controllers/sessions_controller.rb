class SessionsController < ApplicationController
  def new #--> no need to add anything, as there is no model
  end
  def create
    if user = User.authenticate(params[:email_or_username], params[:password]) #--> method in user model
      session[:user_id] = user.id
      flash[:notice] = "Welcome back, #{user.name}!"
      redirect_to(session[:intended_url] || user)
      session[:intended_url] = nil #--> redirect is done last, so this line will happen
    else 
      flash.now[:alert] = "Invalid email/password combination"
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Now you're signed out!"
  end
end
