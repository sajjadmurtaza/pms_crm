class Heyday.UI
  @bootstrap: ->
    Heyday.UI.AjaxLoader.bootstrap()
    $(document).on 'click', "a[href='#']", (event)->
      event.stopPropagation()
    $(document).on 'click', '.ui.button[data-behavior="submit-form"]', (event)->
      $($(this).data('form')).submit()
    Turbolinks.enableProgressBar()

  @alert: (msg)->
    Heyday.UI.showModal("", msg, "<a href='#' class='ui blue button'>OK</a>", null, "small")

  @confirm: (title, msg, success, failure, success_label='Ok', failure_lable='Cancel')->
    modal = Heyday.UI.showModal(title, msg, "<a href='#' class='ui blue ok button'>#{success_label}</a><a href='#' class='ui negative button'>#{failure_lable}</a>", null, "small")
    modal.modal('setting', 'closable', false)
    modal.modal('setting', 'onApprove', success)
    modal.modal('setting', 'onDeny', failure)
    $(modal).find('.close').remove()
    modal.modal('refresh')

#    $(document).on 'page:fetch', ->
#      Heyday.UI.AjaxLoader.start()
#    $(document).on 'page:receive', ->
#      Heyday.UI.AjaxLoader.stop()
    #$(document).ajaxComplete Heyday.UI.initJSElements

  @showModal: (header, content, actions = null, modal = null, mode="basic")->
    modal = @buildModal(mode) unless modal

    if (header? and header != "")
      $(modal).find('.header').html(header)
    else
      $(modal).find('.header').remove()

    if actions? and actions != ""
      $(modal).find('.actions').html(actions)
    else
      $(modal).find('.actions').remove()

    $(modal).find('.content').html(content)
    $(modal).modal 'show'
#    $(modal).modal 'setting', 'onHide', ->
#      $('.page.dimmer').remove()
    modal

  @buildModal: (mode="basic")->
    div = $('<div />').addClass("ui #{mode} modal")
    $('<i />').addClass('close icon').appendTo div
    $('<div />').addClass('header').appendTo div
    $('<div />').addClass('content').appendTo div
    $('<div />').addClass('actions').appendTo div
    div.appendTo('body')
    div

  @initJSElements: (scope)->
    if typeof(scope) == 'object'
      scope = 'body'
    $('select', scope).dropdown()
    $('.ui.dropdown', scope).dropdown()
    $('.ui.tabular.menu .item', scope).tab({history: false})
    $('.ui.checkbox', scope).checkbox()
    $('.ui.accordion', scope).accordion()

    $('.hd-filter-box', scope).each ->
      new Heyday.FilterBox($(this))

    $('.datetimepicker', scope).datetimepicker
      scrollInput: false
      timepicker: false
      format: 'Y-m-d'
      closeOnDateSelect: true
      onGenerate: () ->
        $('.datetimepicker').each ->
          $(this).val($.datepicker.formatDate('yy-mm-dd', new Date())) if $(this).val() is ''


    $('.colorpicker', scope).minicolors()
    $.minicolors = defaults:
      defaultValue: ""
      opacity: false
      position: "bottom right"
      theme: "default"

    $('.field.wysi', scope).each ->
      new wysihtml5.Editor $(this).find('textarea')[0],
        toolbar: $(this).find('.wysi-toolbar')[0]
        parserRules:  wysihtml5ParserRules

class Heyday.UI.AjaxLoader
  @bootstrap: ->
    $.fn.spin.presets.heyday = {
      lines: 13
      length: 20
      width: 10
      radius: 30
      corners: 1
      rotate: 0
      direction: 1
      color: '#000'
      speed: 1
      trail: 60
      shadow: true
      hwaccel: false
      className: 'hd-spinner'
      zIndex: 5000
      top: '50%'
      left: '50%'
    }

  @start: ->
    @spinner = $('#spinner').spin('heyday')

  @stop: ->
    @spinner.data('spinner').stop() if @spinner

Heyday.on_pages 'all', Heyday.UI.initJSElements

Heyday.once Heyday.UI.bootstrap
