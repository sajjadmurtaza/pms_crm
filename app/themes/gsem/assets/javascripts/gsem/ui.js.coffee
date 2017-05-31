Heyday.on_pages 'all', ->
  $('select').dropdown()
  $('.ui.dropdown').dropdown()
  $('.ui.tabluar.menu .item').tab()
  $('.ui.checkbox').checkbox()

  json_data = $.ajax
    url: "/organization_units.json"
    async: false
    dataType: "json"

  $("#organization").getOrgChart
    zoomable: true
    editable: true
    color: "neutralgrey"
    dataSource: json_data.responseJSON

  $('a').removeClass('get-disabled')

  $("#organization").on "removeEvent", (event, sender, args) ->
    $.ajax
      dataType: 'script'
      type: 'DELETE'
      url: '/organization_units/'+args.id,
      data:
        node_id: args.id
    document.location.href="/organization_units";


  $("#organization").on "updateEvent", (event, sender, args) ->
    $.ajax
      dataType: 'script'
      type: (if args.id == '' then 'POST' else 'PATCH')
      url: (if args.id == '' then '/organization_units' else ('/organization_units/'+args.id))
      data:
        id: args.id
        parent_id: args.parentId
        title: args.data.Name
    document.location.href="/organization_units";

  $('.hd-filter-box').each ->
    new Heyday.FilterBox($(this))


Heyday.once ->
  $(document).on "submit", ".turboform", (e) ->
    Turbolinks.visit @action + ((if @action.indexOf("?") is -1 then "?" else "&")) + $(this).serialize()
    false