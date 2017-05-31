class Heyday.FilterBar
  @initSearch: (filters)->
    @search_params = {}
    for f in filters
      fp = f.split(":")
      @search_params[fp[0]] = fp[1]

  @setSearch: (filters)->
    @search_params = {}
    for f in filters
      fp = f.split(":")
      @search_params[fp[0]] = fp[1]
    @updatePage()
  @setAggregates: ()->
    @aggregate_params = {}
    for element in $('input[type="checkbox"].filter-aggregate:checked')
      console.log element
      @aggregate_params[$(element).data('aggregate-name')] = [] unless @aggregate_params[$(element).data('aggregate-name')]
      @aggregate_params[$(element).data('aggregate-name')].push $(element).data('aggregate-value')
    @updatePage()

  @updatePage: ->
    Heyday.UI.AjaxLoader.start()
    params = {
      q:
        search_params: @search_params,
        aggregate_params: @aggregate_params
    }
    $.rails.ajax
      url: window.location.href
      dataType: 'html'
      data: params
      success: (data)->
        $('.ajax-reload').each ->
          $(this).html($(data).find("##{$(this).attr('id')}").html())
        Heyday.UI.AjaxLoader.stop()
        Heyday.UI.initJSElements()

