class SemanticCollectionInput < SimpleForm::Inputs::CollectionSelectInput
  def input(wrapper_options = nil)
    label_method, value_method = detect_collection_methods

    inputs = []
    collection.each do |col|
      inputs << "<div class='item' data-value='#{col.send(value_method)}'>#{col.send(label_method)}</div>"
    end
    # @builder.collection_select(
    #     attribute_name, collection, value_method, label_method,
    #     input_options, merged_input_options
    # )
    result = <<-EDO
      <div class="ui selection dropdown">
      #{@builder.hidden_field attribute_name, input_html_options}
      <div class="default text">--</div>
      <i class="dropdown icon"></i>
      <div class="menu">
        #{inputs.join('').html_safe}
      </div>
    </div>
    EDO
    result.html_safe
  end
end