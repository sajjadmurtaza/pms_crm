Heyday.on_pages '.directory_users_edit,.directory_users_update,.directory_users_show', ->
  $(".password_fields").hide() unless $(".password_fields .field.error").length

  $(".toggle").bind 'click', (e) ->
    $(".password_fields").slideToggle()








