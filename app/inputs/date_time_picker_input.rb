class DateTimePickerInput < SimpleForm::Inputs::DateTimeInput
  def input
    @builder.text_field(attribute_name,input_html_options.merge(class: 'datetimepicker', readonly: false))
  end
end