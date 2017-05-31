class Heyday::OrganizationChart
  constructor: ->
    @init_chart()

  init_chart: ->
    json_data = $.rails.ajax
      url: "#{window.location.pathname}.json"
      async: false
      dataType: "json"

    $("#organization").getOrgChart
      gridView: false
      zoomable: true
      printable: true
      editable: true
      color: "neutralgrey"
      primaryColumns: ["Title", "Role","Members"]
      dataSource: json_data.responseJSON.tree_data

    $('a').removeClass('get-disabled')

Heyday.on_pages '.admin_organization_units', ->
  org = new Heyday::OrganizationChart
  $("#organization").on "removeEvent", (event, sender, args) ->
    $.ajax
      dataType: 'script'
      type: 'DELETE'
      url: "#{window.location.pathname}/#{args.id}"
      data:
        node_id: args.id
      success: =>
        org.init_chart()

  $("#organization").on "updateEvent", (event, sender, args) ->
    $.ajax
      dataType: 'script'
      type: (if args.id == '' then 'POST' else 'PATCH')
      url: (if args.id == '' then window.location.pathname else ("#{window.location.pathname}/#{args.id}"))
      data:
        id: args.id
        parent_id: args.parentId
        title: args.data.Title
        role: args.data.Role
      success: =>
        org.init_chart()