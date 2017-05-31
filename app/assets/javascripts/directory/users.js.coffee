#Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Heyday.on_pages 'all', ->
  $(".taggable-field").each ->
    $(this).select2
      multiple: true
      data: $(this).data('options')
      width: "252px"

  $('.multiple-add-taggable-field').each ->
    $(this).select2
      tags: $(this).data('options')
      width: "252px"

  $('.single-taggable-field').each ->
    $(this).select2
      data: $(this).data('options')
      width: "252px"
      multiple: false

  $('.select-create-field').each ->
    $('.select-create-field').select2
      data: $(this).data('options')
      width: "252px"
      multiple: false
      formatNoMatches: (term) ->
        # customize the no matches output
        "<a href='#' id='addNew' class='ui tiny button' >Add New</a>"
#
    .parent().find(".select2-with-searchbox").on "click", "#addNew", ->
      url = $('input.select-create-field').data('path')
      selected_field_id = $('.select-create-field.select2-container-active').next().attr 'id'
      $.ajax({
        dataType: 'script'
        data:
          selected_field_id: selected_field_id
        type: 'GET'
        url: url
      })
      $('.select-create-field').select2 "close" # close the dropdown
      return


  $(document).on 'cocoon:after-insert' , (e, insertedItem) ->
    insertedItem.find('.taggable-field').select2
      multiple: true
      data: insertedItem.find('.taggable-field').data('options')
      width: '252px'

    insertedItem.find('.single-taggable-field').select2
      data: insertedItem.find('.single-taggable-field').data('options')
      width: "252px"
      multiple: false

    insertedItem.find('.select-create-field').select2
      data: insertedItem.find('.select-create-field').data('options')
      width: "252px"
      multiple: false
      formatNoMatches: (term) ->
        # customize the no matches output
        "<a href='#' id='addNew' class='ui tiny button' >Add New</a>"
    .parent().find(".select2-with-searchbox").on "click", "#addNew", ->
      url = $('input.select-create-field').data('path')
      selected_field_id = $('.select-create-field.select2-container-active').next().attr 'id'
      $.ajax({
        dataType: 'script'
        type: 'GET'
        data:
          selected_field_id: selected_field_id
        url: url
      })
      $('.select-create-field').select2 "close" # close the dropdown
      return

    insertedItem.find('.multiple-add-taggable-field').select2
      tags: insertedItem.find('.multiple-add-taggable-field').data('options')
      width: "252px"
      multiple: true
