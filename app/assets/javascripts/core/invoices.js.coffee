# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Heyday.on_pages '.core_invoices_index', ->
  $(document).on 'click', '.clickAble', ->
    window.document.location = $(this).attr("href")
