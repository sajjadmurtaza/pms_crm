class EnumerationsController < ApplicationController
  before_action :set_enumeration, only: [:show, :edit, :update, :destroy]

  # GET /enumerations
  def index
    add_breadcrumb 'Enumerations', enumerations_path
    @enumerations=Core::Enumeration.all
    @page_title = 'Enumerations'

    Core::SkillType
    Core::EmailType
    Core::PhoneType
    Core::JobTitle
    Core::Location
    Core::Source
    Core::Status
    Core::InvoiceSplitType
    Core::InvoiceSplit
    Core::InvoiceStatus
    Core::NoteTypeAssociation
    Core::QuoteStatus
  end

  # GET /enumerations/1
  def show
  end

  # GET /enumerations/new
  def new
    add_breadcrumb view_context.link_to('Enumeration', enumerations_path)
    add_breadcrumb 'Add Enumeration'
    @enumeration = Core::Enumeration.new(type: params[:type])
    existing_values = @enumeration.type.constantize.pluck(:value)
    @value = existing_values.blank? ? 1 : existing_values.map(&:to_i).max + 1
  end

  # GET /enumerations/1/edit
  def edit
    add_breadcrumb view_context.link_to('Enumeration', enumerations_path)
    add_breadcrumb 'Edit Enumeration'
  end

  # POST /enumerations
  def create
    add_breadcrumb view_context.link_to('Enumeration', enumerations_path)
    add_breadcrumb 'Add Enumeration'
    @enumeration = Core::Enumeration.new(enum_params)
    @enumeration.save
  end

  # PATCH/PUT /enumerations/1
  def update
    @enumeration.update_attributes(enum_params)
  end

  # DELETE /enumerations/1
  def destroy
    @enumeration.destroy
    #redirect_to enumerations_url, notice: 'Enumeration was successfully destroyed.'
  end

  def sort
    params[:draggable].reject{ |i| i.blank? }.each_with_index do |id, index|
      Core::Enumeration.update(id, position: index+1)
    end
    # @enumeration = Core::Enumeration.all
    # @enumeration.each do |enum|
    #   enum.position = params['dragable'].index(enum.id.to_s) + 1
    #   enum.save
    # end
    render nothing: true
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_enumeration
      @enumeration = Core::Enumeration.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def enum_params
      params.require(params[:type]).permit(:name, :value, :type, :position)
    end
end
