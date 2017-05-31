class NotesListWidget < Apotomo::Widget
  include ApplicationHelper
  include SemanticIconHelper
  helper_method :semantic_icon
  include FiltersHelper
  helper_method :filter_box_for
  require 'kaminari'

  responds_to_event :new
  responds_to_event :create
  responds_to_event :edit
  responds_to_event :update
  responds_to_event :search
  responds_to_event :destroy
  responds_to_event :cancel
  responds_to_event :show

  def display(args)
    @object = args[:noteable]
    initialize_search

    render
  end

  def show(args)
    @note = Core::Note.find args[:note_id]
    render
  end

  def new(event)
    @object = fetch_object
    @note_type = Core::NoteType.find(params[:note_type_id])
    @note = Core::Note.new(notable: @object, note_type: @note_type, note_id: params[:note_id])
    @note.build_for_editing
    @elem = (@note.note_id ? '[data-comment='+@note.note_id.to_s+']' : '#note_form')
    render
  end

  def create(event)
    @note = Core::Note.new(note_params)
    @note.user = current_user
    @note.save
    @object = @note.notable_type.constantize.find(@note.notable_id)
    sleep(0.76)
    initialize_search
    render
  end

  def edit(event)
    @note = Core::Note.find(params[:id])
    @note.build_for_editing
    render
  end

  def update(event)
    @note = Core::Note.find(params[:core_note][:id])
    @note.update_attributes(note_params)
    @object = @note.notable_type.constantize.find(@note.notable_id)
    initialize_search

    replace(:view => :display) + 'Heyday.UI.initJSElements(".notes-list-widget");'
  end


  def destroy(event)
    @note = Core::Note.find(params[:id])
    @object = @note.notable_type.constantize.find(@note.notable_id)
    @note.destroy
    initialize_search

    replace(:view => :display) + 'Heyday.UI.initJSElements(".notes-list-widget");'
  end

  def cancel
    @note = Core::Note.find(params[:id])
    @object = @note.notable_type.constantize.find(@note.notable_id)
    initialize_search

    replace(:view => :display) + 'Heyday.UI.initJSElements(".notes-list-widget")'
  end


  def search(event)
    @object = fetch_object
    initialize_search

    replace(:view => :display) + 'Heyday.UI.initJSElements(".notes-list-widget")'
  end

  private
  def note_params
    all_options = params.require(:core_note).fetch(:note_fields, nil).try(:permit!)
    params.require(:core_note)
        .permit(
            :id, :user_id, :notable_id, :notable_type, :note_id, :content,
            :note_attachment, :note_type_id,
            attachments_attributes: [:id, :name, :_destroy],
            custom_values_attributes: [:id, :value, :custom_field_id, :customized_id, :customized_type]
        ).merge(:note_fields => all_options)
  end

  def fetch_object
    params[:noteable_type].constantize.find(params[:noteable_id])
  end

  def initialize_search
    params[:notable_id] = @object.id
    params[:notable_type] = @object.class.to_s.split('::').last.downcase
    @search = ESSearch.new
    @search.klass = Core::Note
    # sort on id
    params["q"] ||= {}
    params["q"]["sort_params"] ||= {}
    params["q"]["sort_params"]['id'] = 'desc'
    @search.init_params params
    @search.load_records = false
    @notes = @search.search.records
  end

end
