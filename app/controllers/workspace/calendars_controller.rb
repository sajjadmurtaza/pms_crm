class Workspace::CalendarsController < ApplicationController
  before_action :set_workspace_calendar, only: [:show, :edit, :update, :destroy,:share]

  # GET /workspace/calendars
  def index
    @page_title = 'Calendars'
    add_breadcrumb 'Calendar', calendars_path
    @calendars =[]
    user_calendars= Workspace::Calendar.all.where system_user_id: current_user.id
    shared_calendars= current_user.shared_calendars
    system_calendars = Workspace::Calendar.all.where system_user_id: Core::EmbeddedUser.find_by_username('system_user')
    user_calendars.each do |c|
      @calendars<<c
    end
    shared_calendars.each do |c|
      @calendars<<c
    end
    system_calendars.each do |c|
      @calendars<<c
    end

    respond_to do |format|
      format.html do
        @checked_calendar_ids = session[:checked_calendars] if session[:checked_calendars]
        @unChecked_calendar_ids = session[:unChecked_calendars] if session[:unChecked_calendars]
      end
      format.js do
        @checked_calendar_ids = session[:checked_calendars] = params[:checked_calendars]
        @unChecked_calendar_ids = session[:unChecked_calendars] = params[:unChecked_calendars]
      end
    end

  end

  # GET /workspace/calendars/1
  def show
  end

  # GET /workspace/calendars/new
  def new
    @page_title = 'Calendars'
    add_breadcrumb view_context.link_to('Calendar', calendars_path)
    add_breadcrumb 'New Calendar'
    @calendar = Workspace::Calendar.new
  end

  # GET /workspace/calendars/1/edit
  def edit
    @page_title = 'Calendars'
    add_breadcrumb view_context.link_to('Calendar', calendars_path)
    add_breadcrumb 'Edit Calendar', calendars_path
  end

  # POST /workspace/calendars
  def create
    @page_title = 'Calendars'
    @calendar = Workspace::Calendar.new(calendar_params)
    @calendar.save
  end

  # PATCH/PUT /workspace/calendars/1
  def update
    @calendar.update(calendar_params)
  end

  # DELETE /workspace/calendars/1
  def destroy
    if @calendar.reference_type?
      render js: "window.location('calendars_url')"
    else
      @calendar.destroy
    end
  end

  def share

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_workspace_calendar
      @calendar = Workspace::Calendar.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def calendar_params
      params.require(:workspace_calendar).permit(:system_user_id, :name, :color,calendars_users_attributes: [:id, :system_user_id, :_destroy])
    end
end
