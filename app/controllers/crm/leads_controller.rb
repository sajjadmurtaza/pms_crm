class Crm::LeadsController < ApplicationController
  menu_item :leads
  before_filter :load_lead, only: [:edit, :update, :show, :destroy]
  before_action :set_sort_params, only: [:index]

  def index
    add_breadcrumb 'CRM', leads_path
    add_breadcrumb 'Leads'
    @page_title = 'Leads'
    @search = ESSearch.new
    @search.klass = Crm::Lead
    @search.init_params params
    @search.load_records = false
    @leads = @search.search.records
  end

  def new
    @page_title = 'Leads'
    add_breadcrumb 'CRM', leads_path
    add_breadcrumb 'Leads', leads_path
    add_breadcrumb 'New Lead'
    @lead = Crm::Lead.new
    load_association
  end

  def create
    @lead = Crm::Lead.new
    @lead.assign_attributes(lead_attributes)
    @lead.user = current_user
    if @lead.save
      flash[:notice] = "Successfully created Lead."
      redirect_to lead_path(@lead)
    else
      @page_title = 'Leads'
      add_breadcrumb 'CRM', leads_path
      add_breadcrumb 'Leads', leads_path
      load_association
      render :action => 'new'
    end
  end

  def edit
    @page_title = "#{@lead.first_name} #{@lead.last_name}"
    add_breadcrumb 'CRM', leads_path
    add_breadcrumb 'Leads', leads_path
    load_association
  end

  def update
    if @lead.update_attributes(lead_attributes)
      flash[:notice] = "Successfully updated Lead."
      redirect_to lead_path(@lead)
    else
      @page_title = "#{@lead.first_name} #{@lead.last_name}"
      add_breadcrumb 'CRM', leads_path
      add_breadcrumb 'Leads', leads_path
      render :action => 'edit'
    end
  end

  def show
    @page_title = "#{@lead.first_name} #{@lead.last_name}"
    add_breadcrumb 'CRM', leads_path
    add_breadcrumb 'Leads', leads_path
    @metadata = @lead.send(@lead.state_column)
    @lead.build_source unless @lead.source.present?
    @lead.build_organization_unit unless @lead.organization_unit.present?
    @invoices = Core::Invoice.where("lead_id = ? or project_id = ?", @lead.id, @lead.try(:project).try(:id))
    @quotes = Core::Quote.where("lead_id = ? or project_id = ?", @lead.id, @lead.try(:project).try(:id))

  end

  def destroy
    @lead.destroy
    redirect_to leads_path
  end

  def quick_note
    puts params[:note_type_id].to_i.class
    @note = Core::Note.new(note_type_id: params[:note_type_id], notable_id: params[:notable_id].to_i, notable_type: params[:notable_type])
    @note.build_for_editing
  end

  def create_quick_note
    @note = Core::Note.new(quick_note_params)
    @note.user = current_user
    @note.save
  end

  def load_lead
    @lead = Crm::Lead.find(params[:id]) rescue nil
    redirect_to leads_path if @lead.blank?
  end

  def load_association
    @lead.taggings.build unless @lead.taggings.present?
    @lead.leads_contacts.build unless @lead.leads_contacts.present?
    #@lead.source.build unless @lead.source.present?
  end

  def self.default_view
    'categorized'
  end

  private

  def lead_attributes
    params.require(:crm_lead).permit(:first_name, :last_name, :email, :phone, :skype, :technology, :source, :description,:source_id,:technology_list, :state, :organization_unit_id,
    taggings_attributes: [:id, :tag_id, :taggable_id, :taggable_type, :tagger_id, :tagger_type, :rating, :context, :_destroy],
    leads_contacts_attributes: [:id, :contact_id, :_destroy],
    attachments_attributes: [:id, :name, :_destroy]
    )
  end

  def quick_note_params
    all_options = params.require(:core_note).fetch(:note_fields, nil).try(:permit!)
    params.require(:core_note)
    .permit(
        :id, :user_id, :notable_id, :notable_type, :content,
        :note_attachment, :note_type_id,
        attachments_attributes: [:id, :name, :_destroy],
        custom_values_attributes: [:id, :value, :custom_field_id, :customized_id, :customized_type]
    ).merge(:note_fields => all_options)
  end

  def set_sort_params
    params["q"] ||= {}
    params["q"]["sort_params"] ||= {}
    params["q"]["sort_params"]['id'] = 'desc'
  end

end
