# Use this setup block to configure all options available in SimpleForm.
SimpleForm.setup do |config|
  config.wrappers :semantic, tag: 'div', class: 'inline field', error_class: 'error', hint_class: 'with_hint' do |b|
    b.use :html5
    b.use :placeholder
    b.use :label_input
    b.optional :maxlength
    b.optional :pattern
    b.optional :min_max
    b.use :hint, wrap_with: {tag: 'div', class: 'hint'}
    b.use :error, wrap_with: {tag: 'div', class: 'ui red pointing left label error'}

  end

  config.wrappers :semantic_checkbox, tag: 'div', class: 'inline field', error_class: 'error', hint_class: 'with_hint' do |b|
    b.use :html5
    b.wrapper tag: 'div', class: 'ui checkbox' do |input|
      input.use :label
      input.use :input
    end
  end

  config.wrappers :semantic_checkbox_slider, tag: 'div', class: 'inline field', error_class: 'error', hint_class: 'with_hint' do |b|
    b.use :html5
    b.use :label
    b.wrapper tag: 'div', class: 'ui slider checkbox' do |input|
      input.use :input
      input.wrapper tag: 'label' do |slide|
      end
    end
  end

  config.wrappers :semantic_checkbox_toggle, tag: 'div', class: 'inline field', error_class: 'error', hint_class: 'with_hint' do |b|
    b.use :html5
    b.use :label
    b.wrapper tag: 'div', class: 'ui toggle checkbox' do |input|
      input.use :input
      input.wrapper tag: 'label' do |slide|
      end
    end
  end

  # Wrappers for forms and inputs using the Twitter Bootstrap toolkit.
  # Check the Bootstrap docs (http://twitter.github.com/bootstrap)
  # to learn about the different styles for forms and inputs,
  # buttons and other elements.
  config.default_wrapper = :semantic

  # Define the way to render check boxes / radio buttons with labels.
  # Defaults to :nested for bootstrap config.
  #   inline: input + label
  #   nested: label > input
  config.boolean_style = :inline

  # Default class for buttons
  config.button_class = 'ui blue submit button'

  # Method used to tidy up errors. Specify any Rails Array method.
  # :first lists the first message for each field.
  # Use :to_sentence to list all errors for each field.
  config.error_method = :first

  # Default tag used for error notification helper.
  config.error_notification_tag = :div

  # CSS class to add for error notification helper.
  config.error_notification_class = 'alert alert-error'

  # ID to add for error notification helper.
  # config.error_notification_id = nil

  # Series of attempts to detect a default label method for collection.
  # config.collection_label_methods = [ :to_label, :name, :title, :to_s ]

  # Series of attempts to detect a default value method for collection.
  # config.collection_value_methods = [ :id, :to_s ]

  # You can wrap a collection of radio/check boxes in a pre-defined tag, defaulting to none.
  # config.collection_wrapper_tag = nil

  # You can define the class to use on all collection wrappers. Defaulting to none.
  # config.collection_wrapper_class = nil

  # You can wrap each item in a collection of radio/check boxes with a tag,
  # defaulting to :span. Please note that when using :boolean_style = :nested,
  # SimpleForm will force this option to be a label.
  # config.item_wrapper_tag = :span

  # You can define a class to use in all item wrappers. Defaulting to none.
  # config.item_wrapper_class = nil

  # How the label text should be generated altogether with the required text.
  # config.label_text = lambda { |label, required| "#{required} #{label}" }

  # You can define the class to use on all labels. Default is nil.
  #config.label_class = 'control-label'

  # You can define the class to use on all forms. Default is simple_form.
  config.form_class = 'ui form hd-theme'

  # You can define which elements should obtain additional classes
  # config.generate_additional_classes_for = [:wrapper, :label, :input]

  # Whether attributes are required by default (or not). Default is true.
  # config.required_by_default = true

  # Tell browsers whether to use the native HTML5 validations (novalidate form option).
  # These validations are enabled in SimpleForm's internal config but disabled by default
  # in this configuration, which is recommended due to some quirks from different browsers.
  # To stop SimpleForm from generating the novalidate option, enabling the HTML5 validations,
  # change this configuration to true.
  config.browser_validations = false

  # Collection of methods to detect if a file type was given.
  # config.file_methods = [ :mounted_as, :file?, :public_filename ]

  # Custom mappings for input types. This should be a hash containing a regexp
  # to match as key, and the input type that will be used when the field name
  # matches the regexp as value.
  # config.input_mappings = { /count/ => :integer }
  config.input_mappings = { /price/ => :currency, /date/ => :date_time_picker }

  # Custom wrappers for input types. This should be a hash containing an input
  # type as key and the wrapper that will be used for all inputs with specified type.
  config.wrapper_mappings = { boolean: :semantic_checkbox_toggle }

  # Default priority for time_zone inputs.
  # config.time_zone_priority = nil

  # Default priority for country inputs.
  # config.country_priority = nil

  # When false, do not use translations for labels.
  # config.translate_labels = true

  # Automatically discover new inputs in Rails' autoload path.
  # config.inputs_discovery = true

  # Cache SimpleForm inputs discovery
  # config.cache_discovery = !Rails.env.development?

  # Default class for inputs
  # config.input_class = nil
end
