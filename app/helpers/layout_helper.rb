module LayoutHelper
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(:file => "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end

  def listing_layout_switch(&block)
    list_active = params[:listing_layout] == 'list' ? 'active' : ''
    table_active = params[:listing_layout] == 'table' ? 'active' : ''
    content_tag :div, class: 'ui buttons' do
      link_to(semantic_icon('list layout'), '?listing_layout=list', class: "ui button #{list_active}", data: {layout_type: 'list'}) +
      link_to(semantic_icon('grid layout'), '?listing_layout=table', class: "ui button #{table_active}", data: {layout_type: 'table'}) +
      (yield(block) if block_given?)
    end
  end

  # Renders tabs and their content
  def render_tabs(tabs)
    render :partial => 'shared/tabs', locals: {tabs: tabs}
  end
end