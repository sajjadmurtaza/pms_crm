module DataList
  class DataListBuilder
    attr_reader :items
    attr_reader :default_action
    attr_reader :actions

    def initialize
      @items = {}
      @actions = []
    end

    def image(attribute, options={})
      @items[:image] = options.merge({value: attribute})
      ''
    end

    def heading(attribute, options={})
      @items[:heading] = options.merge({value: attribute})
      ''
    end

    def subheading(attribute, options={})
      @items[:sub_heading] = options.merge({value: attribute})
      ''
    end

    def text(attribute, options={})
      @items[:text] = options.merge({value: attribute})
      ''
    end

    def action(label, path, options={})
      options[:class] = '' unless options[:class]
      if options[:default]
        @default_action = {label: label, path: path, options: options}
      else
        @actions << {label: label, path: path, options: options}
      end
      ''
    end
  end
end