class Workspace::EventsController < ApplicationController
  before_action :set_workspace_event, only: [:show, :edit, :update, :destroy]

  # GET /workspace/events
  def index
    add_breadcrumb 'Events', events_path
    @calendars = Workspace::Calendar.all.where system_user_id: current_user.id
    @events = []
    @calendars.each do |calendar|
       calendar.calendar_entries.each do |event|
         @events.push event
       end
    end

    respond_to do |format|
      format.html
      format.json  { render json: @events.to_json }
    end
  end

  # GET /workspace/events/1
  def show
  end

  # GET /workspace/events/new
  def new
    add_breadcrumb view_context.link_to('Event', events_path)
    add_breadcrumb 'New Event'
    @event = Workspace::Event.new
  end

  # GET /workspace/events/1/edit
  def edit
    add_breadcrumb view_context.link_to('Event', events_path)
    add_breadcrumb 'Edit Edit', events_path
  end

  # POST /workspace/events
  def create
    @event = Workspace::Event.new(workspace_event_params)

    if @event.save
      redirect_to calendars_path, notice: 'Event was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /workspace/events/1
  def update
    if @event.update_attributes(workspace_event_params)
      redirect_to events_url, notice: 'Event was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /workspace/events/1
  def destroy
    @event.destroy
    redirect_to events_url, notice: 'Event was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workspace_event
      @event = Workspace::Event.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def workspace_event_params
      params.require(:workspace_event).permit(:title, :calendar_id, :start, :end)
    end
end
