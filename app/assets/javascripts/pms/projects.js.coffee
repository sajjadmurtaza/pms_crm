# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Heyday.on_pages '.crm_leads_show, .pms_projects_show', ->
  $('#description').hide();
  $('#show').html('More...');
  $SHOW = false
  $(document).on 'click', '#show', ->
    if $SHOW
      $('#show').html('More...')
      $('#description').hide('fade', 500);
      $SHOW = false
    else
      $('#show').html('Less...')
      $('#description').show('fade', 500);
      $SHOW = true



