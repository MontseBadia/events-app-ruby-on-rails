class EventsController < ApplicationController

  def index
    # @events = Event.all
    @events = Event.upcoming
  end

  def show
    @event = Event.find(params[:id])
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    # @event.update(params[:event]) --> too much info in event
    # redirect_to event_path(@event) --> same as following line
    if @event.update(event_params) #-> returns true/false
      # flash[:notice] = "Event successfully updated!"
      redirect_to @event, notice: "Event successfully updated!"
    else
      render :edit #-> refers to 'edit' view
    end
  end
  
  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: "Event successfully created!"
    else
      render :new #-> refers to 'new' view
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_url, alert: "Event successfully deleted!"
  end

  private 

    def event_params
      params.require(:event).
      permit(:name, :description, :location, :price, :starts_at, :capacity, :image_file_name)
    end

end
