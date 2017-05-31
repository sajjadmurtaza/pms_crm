class TagsInput < SimpleForm::Inputs::CollectionInput
  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods
    input_html_options[:class] << 'selectize'
    merged_input_options = input_html_options.merge(wrapper_options || {})
    merged_input_options['data-selectize-options'] = collection.collect { |item| {value: item.send(value_method), label: item.send(label_method)} }.to_json
    @builder.text_field(attribute_name, merged_input_options)
  end
end