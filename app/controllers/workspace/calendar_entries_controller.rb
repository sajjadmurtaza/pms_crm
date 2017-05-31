class Workspace::CalendarEntriesController < ApplicationController
  before_action :set_calendar_entry, only: [:show, :edit, :update, :destroy]

  # GET /workspace/calendar_entries
  def index
    add_breadcrumb 'Calendar Entry', calendar_entries_path
    @calendars = []
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
    @calendar_entries = []
    @calendars.each do |calendar|
      calendar.calendar_entries.each do |calendar_entry|
        @calendar_entries.push calendar_entry
      end
    end

    respond_to do |format|
      format.html
      format.json
    end
  end

  # GET /workspace/calendar_entries/1
  def show
  end

  # GET /workspace/calendar_entries/new
  def new
    add_breadcrumb view_context.link_to('Calendar Entry', calendar_entries_path)
    add_breadcrumb 'Add Calendar Entry'
    @calendar_entry = Workspace::CalendarEntry.new
  end

  # GET /workspace/calendar_entries/1/edit
  def edit
    add_breadcrumb view_context.link_to('Calendar Entry', calendar_entries_path)
    add_breadcrumb 'Edit Edit', calendar_entries_path
  end

  # POST /workspace/calendar_entries
  def create
    @calendar_entry = Workspace::CalendarEntry.new(calendar_entry_params)
    @calendar_entry.save
  end

  # PATCH/PUT /workspace/calendar_entries/1
  def update
    @calendar_entry.update_attributes(calendar_entry_params)
    if params[:workspace_calendar_entry][:reason].present?
      Core::Note.create(content: params[:workspace_calendar_entry][:reason], note_type_id: Core::NoteType.find_or_create_by(name: 'Reason').id, notable: @calendar_entry.reference, user: current_user)
    end
  end

  # DELETE /workspace/calendar_entries/1
  def destroy
    @calendar_entry.destroy
    render js: "window.location('calendar_entries_url')"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_calendar_entry
      @calendar_entry = Workspace::CalendarEntry.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def calendar_entry_params
      params.require(:workspace_calendar_entry).permit(:title, :description, :reference_id, :reference_type, :calendar_id, :start_date, :end_date)
    end
end
