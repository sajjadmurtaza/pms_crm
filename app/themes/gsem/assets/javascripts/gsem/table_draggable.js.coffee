Heyday.on_pages '.enumerations', ->
  $("table .draggable").sortable
    placeholder: "ui-state-highlight"
    axis: "y"
    scrollSensitivity: 10
    containment: "parent"
    handle: ".handle"
    helper: (e, tr) ->
      $originals = tr.children()
      $helper = tr.clone()
      $helper.children().each (index) ->
        $(this).width $originals.eq(index).width()
        return
      $helper
    update: (event, ui) ->
      $.ajax
        type: 'GET',
        url: "/enumerations/sort",
        data: draggable: $(ui.item).parents('.draggable:first').sortable("toArray"),
        processData: false
      return