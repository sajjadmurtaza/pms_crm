Heyday.on_pages 'all', ->

  $('#sub-action-bar').sticky({topSpacing:65, responsiveWidth: true, getWidthFrom: '#content'})
  $('#side-bar').sticky({topSpacing:70, responsiveWidth: true, getWidthFrom: '.three.wide.column'})
  console.log 'initializing sticky'

  $(".addChild").click ->
    $.ajax
      dataType: 'script'
      type: 'GET'
      url: '/organization_units/new'
      data:
        parent_id: @id

  $(".editNode").click ->
    $.ajax
      dataType: 'script'
      type: 'GET'
      url: '/organization_units/'+@id+'/edit'

  $(".destroy").click ->
    $.ajax
      dataType: 'script'
      type: 'DELETE'
      url: '/organization_units/'+@id
      data:
        node_id: @id
    document.location.href="/organization_units";

Heyday.once ->
  $(document).on "submit", ".turboform", (e) ->
    Turbolinks.visit @action + ((if @action.indexOf("?") is -1 then "?" else "&")) + $(this).serialize()
    false