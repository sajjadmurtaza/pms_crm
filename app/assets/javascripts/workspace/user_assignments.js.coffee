# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
#Heyday.on_pages '.workspace_user_assignments', ->
#$(document).on 'page:update', ->
    $(document).on "click", '.switch_status', (event) ->
      input = $(event.target)
      $.ajax
        dataType: "script"
        type: "GET"
        url: input.attr("data-load-task-url")