# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

class WofkflowExecutionController
  @active_executions: []
  constructor: (@source_type, @source_id, @current_state, @target_state) ->
    Heyday.UI.AjaxLoader.start()
    $.rails.ajax
      url: "/core/workflow/#{@source_type}/#{@source_id}/validate_transition/#{@target_state}"
      type: 'GET'
      dataType: 'json'
      success: (data)=>
        Heyday.UI.AjaxLoader.stop()
        @actions = data
        @process_actions()
      error: (jqXHR, textStatus, errorThrown)=>
        Heyday.UI.AjaxLoader.stop()
        $(".state-column[data-state='#{@current_state}']").sortable('cancel')
        setTimeout ->
          Heyday.UI.alert jqXHR.responseJSON.msg
        , 550
        @remove()

  process_actions: ->
    if @actions.before.length == 0 and @actions.after.length == 0
      @remove()
      return
    if @actions.before.length
      @perform_action(@actions.before[0])
    else
      @make_transition()

  make_transition: ->
    $.getScript "/core/workflow/#{@source_type}/#{@source_id}/make_transition/#{@current_state}/#{@target_state}"

  perform_action: (action)->
    console.log "Inititating action #{action}"
    $.getScript("/core/workflow/#{@source_type}/#{@source_id}/perform_action/#{@current_state}/#{@target_state}/#{action}")

  action_completed: (action)->
    console.log "Completed action #{action}"
    action_mode = if (action in @actions.before)
                    'before'
                  else
                    'after'

    console.log action_mode
    if action_mode == 'before'
      if @actions.before.length > (@actions.before.indexOf action) + 1
        @perform_action(@actions.before[@actions.before.indexOf(action) + 1])
      else
        @make_transition()
    else if action_mode == 'after' and @actions.after.length > (@actions.after.indexOf action) + 1
      @perform_action(@actions.after[@actions.after.indexOf(action) + 1])
    else
      @remove()

  transition_completed: ->
    if @actions.after.length
      @perform_action @actions.after[0]
    else
      @remove()

  remove: ->
    WofkflowExecutionController.active_executions.splice WofkflowExecutionController.active_executions.indexOf(@), 1

  @fetch_workflow: (source_type, source_id)->
    console.log((obj for obj in @active_executions when obj.source_type == source_type and obj.source_id == source_id)[0])
    (obj for obj in @active_executions when obj.source_type == source_type and obj.source_id == source_id)[0]

(global ? window).WofkflowExecutionController = WofkflowExecutionController

$(document).on 'page:update', ->
  return unless $('#action-bar a.ui.button[data-layout-type="categorized"]').hasClass('active')
  if $('body').hasClass('crm_leads')
    $('.state-column').sortable
      connectWith: ".state-column"
      placeholder: "ui segment"
      items: "> div"
      forcePlaceholderSize: true
      revert: 200
      delay: 100
      cursor: 'move'
      receive: (event, ui)->
        target_state = $(this).data 'state'
        from_state = ui.sender.data 'state'
        item = ui.item
#        Heyday.UI.confirm 'Lead transition',
#          "Are you sure to convert <strong>#{item.find('.lead-heading').html()}</strong> from <strong>#{from_state}</strong> to <strong>#{target_state}</strong> ?",
#          ->
        WofkflowExecutionController.active_executions.push(new WofkflowExecutionController('Crm::Lead',
          item.data('id'), from_state, target_state))
#        ,
#          ->
#            ui.sender.sortable 'cancel'