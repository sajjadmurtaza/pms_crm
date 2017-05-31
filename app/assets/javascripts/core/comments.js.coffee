# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
Heyday.on_pages 'all', ->
  $(".comment_form").hide()
  $(".comment_box").click ->
    $(this).hide()
    $(this).next().show().hide().fadeIn(1200)
    setTimeout("$('.wysihtml5-sandbox').contents().find('body').focus()",100)
    return

  $(".comment_cancel").click ->
    $(this).parent().parent().hide()
    $(this).parent().parent().prev().show()
#    $("#comment_form").show().hide().fadeIn(1000)
    return
  return
