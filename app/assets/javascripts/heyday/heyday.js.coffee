class Heyday
  @on_pages: (pages, func)->
    if pages == 'all'
      $(document).on "page:change", func
    else
      $(document).on "page:change", ->
        if $('body').is pages
          console.log "Executing events for pages #{pages}"
          func()

  @once: (func)->
    $(document).ready(func)

  @redirect: (path)->
    window.location.href = path

  @reload: ->
    window.location.href = window.location.href

(global ? window).Heyday = Heyday