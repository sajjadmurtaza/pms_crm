module Heyday
  module MenuManager
    class MenuRenderer
      include AccessibilityHelper
      include ActionView::Helpers::UrlHelper

      def initialize(menu, current_menu_item=nil, options)
        @menu = menu
        @options = default_options
        @current_menu_item = current_menu_item
        @options[:wrapper_tag] << options.delete(:wrapper_tag).to_s
        @options[:wrapper_class] << options.delete(:wrapper_class).to_s
        @options[:element_tag] << options.delete(:element_tag).to_s
        @options[:element_class] << options.delete(:element_class).to_s
        @options.merge! options
      end

      def render
        if @options[:only_root]
          return render_root_items
        elsif @options[:only_children]
          return render_child_items_of(@current_menu_item)
        end
      end

      private

      def render_child_items_of(current_menu_item)
        links = []
        root_item = menu_items.select { |node| node.name == current_menu_item }.first
        if root_item
          root_item.children.each do |node|
            caption, url, selected, icon = extract_node_details(node)
            links << render_single_menu_node(node, caption, url, icon, selected)
          end
        end
        links.empty? ? nil : content_tag(@options[:wrapper_tag], links.join("\n").html_safe, :class => @options[:wrapper_class])
      end

      def render_root_items
        links = []
        menu_items.each do |node|
          caption, url, selected, icon = extract_node_details(node)
          links << render_single_menu_node(node, caption, url, icon, selected)
        end
        links.empty? ? nil : content_tag(@options[:wrapper_tag], links.join("\n").html_safe, :class => @options[:wrapper_class])
      end

      def render_single_menu_node(item, caption, url, icon=nil, selected)
        if @options[:only_icons]
          link_text = "<i class='ui icon #{icon}'></i>" if icon.present?
        else
          link_text = caption
          link_text = "<i class='ui icon #{icon}'></i>" + link_text if icon.present?
        end
        html_options = item.html_options({selected: selected, class: @options[:element_class]})
        html_options[:title] = caption
        html_options[:lang] = menu_item_locale(item)
        link_to link_text.html_safe, url, html_options
      end

      def menu_items
        validate_nodes(Heyday::MenuManager.items(@menu).root.children)
      end

      def extract_node_details(item)
        url = case item.url
                when Hash
                  url_for(item.url)
                when Symbol
                  send(item.url)
                else
                  item.url
              end
        caption = item.caption
        selected = @current_menu_item == item.name
        return [caption, url, selected, item.icon]
      end

      def validate_nodes(nodes)
        nodes.select { |node| allowed_node?(node, Directory::User.current) }
      end

      # Checks if a user is allowed to access the menu item by:
      def allowed_node?(node, user)
        if node.condition && !node.condition.call(user)
          return false
        end
        user && user.allowed_to?(node.url)
      end

      def default_options
        {wrapper_tag: 'div ', wrapper_class: 'ui menu ', element_tag: 'a ', element_class: 'item '}
      end
    end
  end
end