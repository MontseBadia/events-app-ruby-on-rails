class RegistrationsController < ApplicationController
  before_action :require_signin
  before_action :set_event
  
  def index 
    # fail
    # @event = Event.find(params[:event_id])
    @registrations = @event.registrations
    # @registrations = Registration.all
  end

  def new 
    # @event = Event.find(params[:event_id])
    @registration = @event.registrations.new
  end

  def create 
    # @event = Event.find(params[:event_id])
    @registration = @event.registrations.new(registration_params)
    @registration.user = current_user
    if @registration.save
      redirect_to event_registrations_path(@event), notice: "Thanks, you are registered!"
    else
      render :new
    end
  end

  def edit 
    @registration = Registration.find(params[:id])
  end

  def update
    @registration = Registration.find(params[:id])
    if @registration.update(registration_params)
      redirect_to event_registrations_path(@event), notice: "Registration successfully updated!"
    else  
      render :edit
    end
  end

  def destroy
    @registration = Registration.find(params[:id])
    @registration.destroy
    redirect_to event_registrations_path(@event), alert: "Registration successfully deleted!"
  end

  private 

    def registration_params
      params.require(:registration).permit(:how_heard) #--> deleted name and email
    end

    def set_event
      @event = Event.find_by!(slug: params[:event_id])
    end
end
