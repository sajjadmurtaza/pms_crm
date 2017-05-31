module Heyday
  class ComponentError < StandardError
    attr_reader :component_id

    def initialize(component_id=nil)
      super
      @component_id = component_id
    end
  end
  class ComponentNotFound < ComponentError
    def to_s
      "Missing the component #{@component_id}"
    end
  end

  #   Heyday::Component.register :example do
  #     name 'Example component'
  #     author 'John Smith'
  #     description 'This is an example component for Redmine'
  #     version '0.0.1'
  #     -- NOT IMPLEMENTED NOW --
  #     settings :default => {'foo'=>'bar'}, :partial => 'settings/settings'
  #   end
  #
  class Component
    @registered_components = ActiveSupport::OrderedHash.new
    @deferred_components = {}
    attr_reader :registered_components, :deferred_components
    attr_accessor :name, :description, :url, :author, :author_url, :version, :settings

    cattr_accessor :component_directory
    self.component_directory = File.join(Rails.root, 'public', 'component_assets')

    # Component constructor
    def self.register(id, &block)
      id = id.to_sym
      p = new(id)
      p.instance_eval(&block)
      # Set a default name if it was not provided during registration
      p.name(id.to_s.humanize) if p.name.nil?

      registered_components[id] = p

      # if p.settings
      #   Setting.create_setting("component_#{id}", {'default' => p.settings[:default], 'serialized' => true})
      #   Setting.create_setting_accessors("component_#{id}")
      # end

      # If there are components waiting for us to be loaded, we try loading those, again
      if deferred_components[id]
        deferred_components[id].each do |ary|
          component_id, block = ary
          register(component_id, &block)
        end
        deferred_components.delete(id)
      end

      return p
    end

    # Returns an array of all registered components
    def self.all
      registered_components.values
    end

    # Finds a component by its id
    # Returns a componentNotFound exception if the component doesn't exist
    def self.find(id)
      registered_components[id.to_sym] || raise(ComponentNotFound.new(id.to_sym))
    end

    # Clears the registered components hash
    # It doesn't unload installed components
    def self.clear
      @registered_components = {}
    end

    # Checks if a component is installed
    #
    # @param [String] id name of the component
    def self.installed?(id)
      registered_components[id.to_sym].present?
    end

    def <=>(component)
      self.id.to_s <=> component.id.to_s
    end

    # Adds an item to the given +menu+.
    # The +id+ parameter (equals to the project id) is automatically added to the url.
    #   menu :project_menu, :component_example, { :controller => '/example', :action => 'say_hello' }, :caption => 'Sample'
    #
    # +name+ parameter can be: :top_menu, :account_menu, :application_menu or :project_menu
    #
    def menu(menu_name, item, url, options={})
      Heyday::MenuManager.map(menu_name) do |menu|
        menu.push(item, url, options)
      end
    end

    alias :add_menu_item :menu

    # Removes +item+ from the given +menu+.
    def delete_menu_item(menu_name, item)
      Heyday::MenuManager.map(menu_name) do |menu|
        menu.delete(item)
      end
    end

    # Returns +true+ if the component can be configured.
    def configurable?
      settings && settings.is_a?(Hash) && !settings[:partial].blank?
    end
  end
end