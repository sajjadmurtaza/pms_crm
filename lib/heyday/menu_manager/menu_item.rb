module Heyday
  module MenuManager
    # Tree::TreeNode -> gem 'rubytree'
    class MenuItem < Heyday::MenuManager::TreeNode
      include Heyday::I18n
      attr_reader :name, :url, :param, :condition, :parent, :child_menus, :last, :icon

      def initialize(name, url, options)
        raise ArgumentError, "Invalid option :if for menu item '#{name}'" if options[:if] && !options[:if].respond_to?(:call)
        raise ArgumentError, "Invalid option :html for menu item '#{name}'" if options[:html] && !options[:html].is_a?(Hash)
        raise ArgumentError, "Cannot set the :parent to be the same as this item" if options[:parent] == name.to_sym
        raise ArgumentError, "Invalid option :children for menu item '#{name}'" if options[:children] && !options[:children].respond_to?(:call)
        @name = name
        @url = url
        @condition = options[:if]
        @param = options[:param] || :id
        @caption = options[:caption]
        @html_options = options[:html] || {}
        # Adds a unique class to each menu item based on its name
        @html_options[:class] = [@html_options[:class], @name.to_s.dasherize, 'ellipsis'].compact.join(' ')
        @parent = options[:parent]
        @child_menus = options[:children]
        @last = options[:last] || false
        @icon = options[:icon]

        super @name.to_sym
      end

      def caption
        if @caption.is_a?(Proc)
          c = @caption.call().to_s
          c = @name.to_s.humanize if c.blank?
          c
        else
          if @caption.nil?
            l_or_humanize(name, :prefix => 'label_')
          else
            @caption.is_a?(Symbol) ? l(@caption) : @caption
          end
        end
      end

      def html_options(options={})
        @html_options[:class] += " #{options[:class]}"
        if options[:selected]
          o = @html_options.dup
          o[:class] += ' active'
          o
        else
          @html_options
        end
      end
    end
  end
end