require 'render_anywhere'

class CreateReasonAction
  include RenderAnywhere

  def initialize(params = nil)
    if params.present?
      @lead = params[:lead]
      @action_name = params[:action_name]
      @target_state = params[:target_state]
    end
  end

  def perform
    @note = Core::Note.new(notable: @lead, note_type_id: Core::NoteType.find_or_create_by(name: 'System Activity').id)
    @note.build_for_editing
    render partial: '/create_reason_action', layout: nil, locals: {lead: @lead, note: @note, action_name: @action_name, target_state: @target_state}
  end

  def after_frontend(params)
    @note = Core::Note.new(note_params(params))
    @note.user = params[:user]
    @note.content = "Status Changed From <b>#{(params[:source].send params[:source].state_column).capitalize}</b> To <b> #{params[:target_state].capitalize} </b> because <br> #{@note.content}".html_safe
    @note.save
  end

  protected
  def note_params(params)
    all_options = params.require(:core_note).fetch(:note_fields, nil).try(:permit!)
    params.require(:core_note)
        .permit(
            :id, :user_id, :notable_id, :notable_type, :content,
            :note_attachment, :note_type_id,
            attachments_attributes: [:id, :name, :_destroy],
            custom_values_attributes: [:id, :value, :custom_field_id, :customized_id, :customized_type]
        ).merge(:note_fields => all_options)
  end

end