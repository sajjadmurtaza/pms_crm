$(document).on('click', '.task_complete', function (event) {
  var input = $(event.target);
  $.ajax({
    dataType: 'script',
    type: 'GET',
    url: input.attr('data-load-event-url')
  });
});

$(document).on({
  mouseenter: function () {
    $(this).find('span:last').removeClass('hide-display');
  },
  mouseleave: function () {
    $(this).find('span:last').addClass('hide-display');
  }
}, ".action-hover");