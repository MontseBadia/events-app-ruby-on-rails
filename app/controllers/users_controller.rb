class UsersController < ApplicationController
  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.all
  end

  def show 
    # @user = User.find(params[:id])
    @registrations = @user.registrations
    @liked_events = @user.liked_events
  end

  def new
    @user = User.new
  end

  def create 
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else 
      render :new
    end
  end

  def edit 
    # @user = User.find(params[:id]) --> taken from require_correct_user
  end

  def update
    # @user = User.find(params[:id]) --> taken from require_correct_user
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit
    end
  end

  def destroy #--> only admin will be able to delete an account
    # @user = User.find(params[:id]) --> taken from require_correct_user
    # @user = User.find(params[:id])
    @user.destroy
    # session[:user_id] = nil
    redirect_to root_url, alert: "Account successfully deleted!"
  end

  private 

  def require_correct_user
    @user = User.find_by!(slug: params[:id])
    redirect_to root_url unless current_user?(@user)
  end

  def user_params
    params.require(:user).permit(:name, :username, :email, :password, :password_confirmation, :slug)
  end

  def set_user
    @user = User.find_by!(slug: params[:id])
  end
end
