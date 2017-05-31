module FiltersHelper
  def filter_box_for(search,filter_options={})
    id = "#{search.klass.model_name.plural}_filter_box"
    style = "width: 100%"
    data = {}
    data[:filter_fields] = filter_options.length == 0 ? search.klass.filter_options[:filter_box] : filter_options[:filter_box]
    data[:filter_pre_populate] = search.search_params
    content_tag(:h3, 'Filter') +
    content_tag(:input, '', type: 'hidden', id: id, class: 'hd-filter-box', style: style, data: data)
  end

  def filter_aggregates_for(search)
    result = []
    aggregates = search.klass.filter_options[:filter_aggregates]
    aggregates.each do |aggr|
      result << render(partial: 'shared/aggregate_box',
                       locals: {
                           aggregate: aggr,
                           search: search})
    end
    "<div id='aggregates-bar'>#{result.join('<br>')}</div>".html_safe
  end

  def sorting_for(search)
    result = []
    search.klass.filter_options[:sorting].each do |item|
      result << render(partial: 'shared/sort_dropdown',
                       locals: {
                           aggregate: item,
                           search: search})
    end
    "<div id='sort-bar'>#{result.join(' ')}</div>".html_safe
  end
end