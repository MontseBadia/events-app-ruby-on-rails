class EventsController < ApplicationController
  before_action :require_signin, except: [:index, :show]
  before_action :require_admin, except: [:index, :show]
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    case params[:scope]
    when "past"
      @events = Event.past
    when "free"
      @events = Event.free
    when "recent"
      @events = Event.recent
    else
    # @events = Event.all
      @events = Event.upcoming #--> custom query in model
    end
    @categories = Category.all
  end

  # def index_free_events
  #   @category = Category.find_by(name: 'Free')
  #   @events = @category.events
  #   render :partial => 'events/free_events'
  # end

  def show
    # @event = Event.find_by!(slug: params[:id])
    @likers = @event.likers
    @categories = @event.categories
    
    if current_user
      @current_like = current_user.likes.find_by(event_id: @event.id)
    end
  end

  def edit
    # @event = Event.find_by!(slug: params[:id])
    session[:intended_url] = request.url
  end

  def update
    # @event = Event.find_by!(slug: params[:id])
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
    # @event = Event.find(params[:id])
    @event.destroy
    redirect_to events_path, alert: "Event successfully deleted!"
  end

  private 

    def set_event
      @event = Event.find_by!(slug: params[:id])
    end

    def event_params
      params.require(:event).
      permit(:name, :description, :location, :price, :starts_at, :capacity, :image_file_name, category_ids: [])
    end
end
