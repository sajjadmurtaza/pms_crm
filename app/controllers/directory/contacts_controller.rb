class Directory::ContactsController < ApplicationController
  menu_item :contacts
  before_filter :load_contact, only: [:edit, :update, :show, :destroy]

  def index
    @page_title = 'Contacts'
    add_breadcrumb 'Directory', contacts_path
    add_breadcrumb 'Contacts', contacts_path
    @search = ESSearch.new
    @search.klass = Directory::Contact
    @search.init_params params
    @search.load_records = false
    @contacts = @search.search.records
  end

  def new
    @page_title = 'Contacts'
    add_breadcrumb 'Directory', contacts_path
    add_breadcrumb 'Contacts', contacts_path
    add_breadcrumb 'New Contact'
    @contact = Directory::Contact.new
    @selected_field_id = params[:selected_field_id]
    load_association
  end

  def create
    @contact = Directory::Contact.new
    @contact.build_contact_detail unless @contact.contact_detail.present?
    @selected_field_id = params[:selected_field_id]
    @contact.assign_attributes(contact_params)
    if @contact.save
      @contact.set_default_picture unless @contact.picture.present?
      flash[:notice] = "Successfully created contact."
      redirect_to contact_path(@contact) unless request.xhr?
    else
      @page_title = 'Contacts'
      add_breadcrumb 'Directory', contacts_path
      add_breadcrumb 'Contacts', contacts_path
      add_breadcrumb 'New Contact'
      load_association
      render :action => 'new' unless request.xhr?
    end
  end

  def edit
    @page_title = @contact.name
    add_breadcrumb 'Directory', contacts_path
    add_breadcrumb 'Contacts', contacts_path
  end

  def update
    @contact.assign_attributes(contact_params)
    if @contact.first_name_changed? or @contact.last_name_changed?
      @contact.set_default_picture if @contact.picture.name.file.original_filename == Directory::Contact::DEFAULT_PICTURE_NAME
    end
    if @contact.save
      flash[:notice] = "Successfully updated contact."
      redirect_to contact_path(@contact)
    else
      @page_title = @contact.name
      add_breadcrumb 'Directory', contacts_path
      add_breadcrumb 'Contacts', contacts_path
      render :action => 'edit'
    end
  end

  def show
    @contact = Directory::Contact.find(params[:id]) rescue nil
    @page_title = @contact.name
    add_breadcrumb 'Directory', contacts_path
    add_breadcrumb 'Contacts', contacts_path
  end

  def destroy
    @contact.destroy
    redirect_to contacts_path
  end

  def load_contact
    @contact = Directory::Contact.find(params[:id]) rescue nil
    load_association
    redirect_to contacts_path if @contact.blank?
  end

  def load_association
    @contact.emails.build unless @contact.emails.present?
    @contact.phones.build unless @contact.phones.present?
    @contact.build_picture unless @contact.picture.present?
    @contact.addresses.build unless @contact.addresses.present?
    @contact.build_contact_detail unless @contact.contact_detail.present?
  end

  private

  def contact_params
    params.require(:directory_contact)
    .permit(
        :first_name, :last_name, :email, :phone, :skype, :timezone, :nick_name, :company_title, :company_email, :company_phone, :directory_list,
        picture_attributes: [:id, :name, :_destroy],
        emails_attributes: [:id, :email, :email_type, :_destroy],
        phones_attributes: [:id, :phone, :phone_type, :_destroy],
        addresses_attributes: [:id, :address1, :address2, :address_type, :city, :zip, :state, :country, :_destroy]
    )
  end

end
