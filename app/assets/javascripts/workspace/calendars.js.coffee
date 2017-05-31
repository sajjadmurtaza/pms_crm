Heyday.on_pages '.workspace_calendars_index, .workspace_calendars_new, .workspace_events_index',  ->

  getCheckedCalendars = ->
    checkedCalendars = []
    $('.calendars-list input[type="checkbox"]').each ->
      if $(this).is ':checked'
        checkedCalendars.push $(this).data('calendar-id')
    return checkedCalendars

  getUnCheckedCalendars = ->
    unCheckedCalendars = []
    $('.calendars-list input[type="checkbox"]').each ->
      unless $(this).is ':checked'
        unCheckedCalendars.push $(this).data('calendar-id')
    return unCheckedCalendars

  hideUnCheckedCalendarEvents = ->
    unCheckedCalendars = getUnCheckedCalendars()
    $.each unCheckedCalendars, (index, value)->
      $(".calendar-#{value}").hide()

  $(document).on 'page:update' , ->
    hideUnCheckedCalendarEvents()

  $(document).on 'click', '.calendars-list input[type="checkbox"]', ->
    $.ajax({
      dataType: "script"
      type:"GET",
      url: "/calendars",
      data:
        checked_calendars: getCheckedCalendars()
        unChecked_calendars: getUnCheckedCalendars()
    });

  calendar=$('#calendar').fullCalendar({
    editable: true,
    droppable: true,
    draggable: true,
    durationEditable: true,
    eventStartEditable: true,
    eventDurationEditable: true,

    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,basicWeek,basicDay'
    }

    eventSources: [
      {
        url: '/calendar_entries.json',
        type: 'GET',
      #color: '#CBE2FA',
        allDay: false,
        borderColor: '#bccee0',
        textColor: 'black'
        error: ->
          alert('there was an error while fetching events!')
      }
#      {
#        url: 'https://www.google.com/calendar/feeds/od305bghpa8fvhjoksdg31glro%40group.calendar.google.com/public/basic'
#        color: '#166BEC'
#        textColor: '#FFB504'
#      },
#      {
#        url: '/events.json',
#        type: 'GET',
#      #color: '#CBE2FA',
#        allDay: false,
#        borderColor: '#bccee0',
#        textColor: 'black'
#        error: ->
#          alert('there was an error while fetching events!')
#      }
##      {
##        url: 'https://www.google.com/calendar/feeds/od305bghpa8fvhjoksdg31glro%40group.calendar.google.com/public/basic'
##        color: '#166BEC'
##        textColor: '#FFB504'
##
##      },
##      {
##        url: 'https://www.google.com/calendar/feeds/sajjadmurtaza.nxb%40gmail.com/public/basic'
##        textColor: 'white'
##      }
    ]

    defaultView: 'month',
    height: 563,
    timeFormat: '',
    slotMinutes: 30,
    droppable: true,
    selectable: true
    selectHelper: true
    eventDrop: (event, delta, revertFunc) ->
      if event.type == 'Core::Invoice'
        textarea = $("<textarea cols='47' rows='3' class='description' style='resize:none'></textarea>")
        Heyday.UI.confirm 'Reason',
          textarea,
          ->
            $.ajax({
              dataType: 'script'
              type:"PUT",
              url: "/calendar_entries/"+event.id,
              data:
                workspace_calendar_entry:
                  title: event.title,
                  calendar_id: event.calendar_id,
                  start_date: event.start.format(),
                  end_date: event.end.format()
                  reason: textarea.val()
            });
        ,
          ->
            revertFunc()
            hideUnCheckedCalendarEvents()
      else
        $.ajax({
          dataType: 'script'
          type:"PUT",
          url: "/calendar_entries/"+event.id,
          data:
            workspace_calendar_entry:
              title: event.title,
              calendar_id: event.calendar_id,
              start_date: event.start.format(),
              end_date: event.end.format()
        });

#
#    eventResize: (event) ->
#      $.ajax({
#        dataType: 'script',
#        type:"PUT",
#        url: "/calendar_entries/"+event.id,
#        data:
#          workspace_calendar_entry:
#            title: event.title,
#            calendar_id: event.calendar_id,
#            start_date: event.start.format(),
#            end_date: event.end.format()
#      });

#    select: (start, end) ->
#      $.ajax({
#        dataType: 'script'
#        type: 'GET'
#        url: '/calendar_entries/new'
#      });

#    eventClick: (event, jsEvent, view) ->
##      edit_event = confirm( "Edit "+event.title)
##      if edit_event is true
#        $.ajax({
#          dataType: 'script'
#          type: 'GET'
#          url: "/calendar_entries/"+event.id+"/edit"
#        });
    eventClick: (event) ->
      window.open(event.showUrl)

    eventMouseover: (event, jsEvent, view) ->
      $(jsEvent.target).attr "title", event.showUrl
  });

