class CurrencyInput < SimpleForm::Inputs::Base
  def input
    template.content_tag :div, "#{@builder.text_field(attribute_name, input_html_options)} <i class='icon'>#{object.send(attribute_name).currency.html_entity}</i>".html_safe, class: 'ui left labeled icon currency input'
  end
end