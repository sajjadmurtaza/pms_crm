Heyday.on_pages 'all', ->
  $("#profile-tabs").tabs().addClass "ui-tabs-vertical ui-helper-clearfix"
  $("#profile-tabs li").removeClass("ui-corner-top").addClass "ui-corner-left"
  return