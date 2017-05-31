Array.prototype.getObjectBy = (name, value)->
  for object in this
    return object if object[name] == value
  return null

class Heyday.FilterBox
  constructor: (@element) ->
    @filter_fields = $(@element).data('filter-fields')
    @setupSelect2()
    Heyday.FilterBar.initSearch($(@element).select2('val'))

  setupSelect2: ->
    $(@element).select2(
      placeholder: "Filter data..."
      minimumInputLength: 2
      containerCssClass: 'hd-filter-box-container'
      multiple: true
      formatResult: Heyday.FilterBox.filterBoxOptionsFormat
      formatSelection: Heyday.FilterBox.filterBoxTagFormat
      query: (query)=>
        data = {results: []}
        for filter in @filter_fields
          data.results.push {id: "#{filter.key}:#{query.term}", key: filter.key, label: filter.label, term: query.term}
        query.callback data
      initSelection: (element, callback)=>
        data = []
        for k,v of @element.data('filter-pre-populate')
          if @filter_fields.getObjectBy('key', k)
            data.push {id: "#{k}:#{v}", key: k, label: @filter_fields.getObjectBy('key', k).label, term: v}
        callback(data)
    ).on('change', (event)->
      Heyday.FilterBar.setSearch(event.val)
    ).select2('val', 'initValue')

  @filterBoxOptionsFormat: (object, container, query)->
    "#{object.label}: <strong>#{object.term}</strong>"

  @filterBoxTagFormat: (selection)->
    "<span class='label'>#{selection.label}</span> #{selection.term}"
