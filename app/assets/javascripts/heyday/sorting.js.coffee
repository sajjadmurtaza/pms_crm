class Heyday.SortingBar
  @setSorting: (object)->
    @sorting=$(object).data('sorting-value')
    @updateSortingPage()
  @updateSortingPage: ->
    Heyday.UI.AjaxLoader.start()
    params = {
      q:
        sort_params: {}
    }
    params['q']['sort_params'][@sorting] = 'asc'
    query_params = $.getQueryParameters()
    for i of query_params
      if i.indexOf('q%5Bsort_params') != -1 and query_params.hasOwnProperty(i)
        delete query_params[i]
    console.log query_params
    console.log($.param(query_params))
    $.rails.ajax
      url: window.location.href.split('?')[0]+'?'+$.param(query_params)
      dataType: 'html'
      data: params
      success: (data)->
        $('.ajax-reload').each ->
          $(this).html($(data).find("##{$(this).attr('id')}").html())
        Heyday.UI.AjaxLoader.stop()
        Heyday.UI.initJSElements()