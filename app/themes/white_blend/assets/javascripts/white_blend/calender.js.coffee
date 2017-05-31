Heyday.on_pages '.workspace_calendars_index, .workspace_calendars_new, .workspace_events_index',  ->
  $('.ui.header').click ->
    $.ajax({
      dataType: 'script'
      type: 'GET'
      url: '/calendars/new'
    });
  calendar=$('#calendar').fullCalendar({
    editable: true,
    droppable: true,
    draggable: true,
    durationEditable: true,
#    events: '/events.json',
    eventStartEditable: true,
    eventDurationEditable: true,

    header: {
      left: 'prev,next today',
      center: 'title',
      right: 'month,agendaWeek,agendaDay'
    }

    eventSources: [
      {
        url: '/events.json',
        type: 'GET',
        #color: '#CBE2FA',
        allDay: false,
        borderColor: '#bccee0',
        textColor: 'black',
        error: ->
          alert('there was an error while fetching events!')
      }
      ]
    defaultView: 'month',
    height: 563,
    timeFormat: '',
    slotMinutes: 30,
    droppable: true,
    selectable: true
    selectHelper: true
    eventDrop: (event) ->
      $.ajax({
        dataType: 'script'
        type:"PUT",
        url: "/events/"+event.id,
        data:
          workspace_event:
            title: event.title,
            workspace_calendar_id: event.workspace_calendar_id,
            start: event.start.format(),
            end: event.end.format()
      });
    eventResize: (event) ->
      $.ajax({
        dataType: 'script',
        type:"PUT",
        url: "/events/"+event.id,
        data:
          workspace_event:
            title: event.title,
            workspace_calendar_id: event.workspace_calendar_id,
            start: event.start.format(),
            end: event.end.format()
      });

    select: (start, end) ->
      $.ajax({
        dataType: 'script'
        type: 'GET'
        url: '/events/new'
      });

  });

