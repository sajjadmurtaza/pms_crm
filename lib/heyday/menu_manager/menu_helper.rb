module Heyday
  module MenuManager
    module MenuHelper
      include AccessibilityHelper

      # Returns the current menu item name
      def current_menu_item
        controller.current_menu_item
      end

      def render_menu(menu, options={})
        return MenuRenderer.new(menu, current_menu_item, options).render
      end
    end
  end
end