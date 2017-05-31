class Admin::CustomFieldsController < ApplicationController

  def new
    @custom_field = "Core::#{params[:field_source]}CustomField".constantize.new
    @custom_field.meta = params[:field_meta] if params[:field_meta]
  end

  def create
    @custom_field = Core::CustomField.new
    @custom_field.assign_attributes custom_field_params
    if @custom_field.save
      @success = true
    else
      puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      puts @custom_field.errors.full_messages
      puts "%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%"
      @success = false
    end
  end

  def edit
    @custom_field = Core::CustomField.find(params[:id])
    @custom_field.possible_values = @custom_field.possible_values.join(',') if @custom_field.possible_values.is_a? Array
  end

  def update
    @custom_field = Core::CustomField.find(params[:id])
    if @custom_field.update_attributes custom_field_params
      @success = true
    else
      @success = false
    end
  end

  def destroy
    @custom_field = Core::CustomField.find(params[:id])
    if @custom_field.destroy
      @success = true
    else
      @success = false
    end
  end

  private
  def custom_field_params
    field_params = params.require(:custom_field).permit [:name, :field_format, :regexp, :default_value, :min_length, :max_length, :required, :editable, :searchable, :scheduleable, :possible_values, :meta, :type]
    field_params[:possible_values] = field_params[:possible_values].split(',')
    field_params
  end
end
