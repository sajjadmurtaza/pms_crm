require 'render_anywhere'

class CreateProjectAction
  include RenderAnywhere

  def initialize(params = nil)
    if params.present?
      @lead = params[:lead]
      @action_name = params[:action_name]
      @target_state = params[:target_state]
    end
  end

  def perform
    @contact = Directory::Contact.new
    @contact.first_name = @lead.first_name
    @contact.last_name = @lead.last_name
    @contact.email = @lead.email
    @contact.phone = @lead.phone
    @project = Pms::Project.new
    @project.title = @lead.invoices.present? ? @lead.invoices.pluck(:invoice_project).first : "#{@lead.first_name} #{@lead.last_name}'s Project"
    @project.description = @lead.description
    @project.projects_contacts.build(contact: @contact)

    render partial: '/create_project_action', layout: nil, locals: {lead: @lead, contact: @contact, project: @project, action_name: @action_name, target_state: @target_state}
  end

  def after_frontend(params)
    @project = Pms::Project.new
    @project.title = params[:pms_project][:title]
    @project.description = params[:pms_project][:description]
    @project.user = params[:user]
    @project.lead = params[:source]
    default_status = Core::Status.find_by_name('In Progress')
    @project.status = default_status.nil? ? Core::Status.first : default_status

    @lead = params[:source]
    if @lead.assigned_contacts.empty?
      contact_params = params[:pms_project][:directory_contact]
      @contact =  Directory::Contact.find_or_initialize_by(first_name: contact_params[:first_name], last_name: contact_params[:last_name], email: contact_params[:email])
      if @contact.new_record?
        @contact.username = @contact.email
        @contact.phone =  contact_params[:phone]
        @contact.build_contact_detail
        @contact.set_default_picture
      end
      @project.assigned_contacts << @contact
    else
      @project.assigned_contacts << @lead.assigned_contacts
    end
    
    @project.save
    @note = Core::Note.new(notable: @lead, note_type_id: Core::NoteType.find_or_create_by(name: 'System Activity').id)
    @note.build_for_editing
    @note.user = params[:user]
    @note.content = "Status Changed From <b>#{@lead.send(@lead.state_column).capitalize}</b> To <b> #{params[:target_state].capitalize}</b> And a Project Is Created.".html_safe
    @note.save
  end

end