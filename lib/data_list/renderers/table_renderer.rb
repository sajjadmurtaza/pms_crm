module DataList
  module Renderers
    class TableRenderer < BaseRenderer
      def render
        view = ActionView::Base.new(ActionController::Base.view_paths, {collection: @collection, builder: @builder})
        view.extend ApplicationHelper
        view.render partial: 'shared/data_list_table'
      end
    end
  end
end