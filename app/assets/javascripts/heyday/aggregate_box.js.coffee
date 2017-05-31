class Heyday.AggregateBox
  @aggregateClicked: (event)->
    Heyday.FilterBar.setAggregates()

Heyday.once ->
  $(document).on 'change', 'input[type="checkbox"].filter-aggregate', (event)->
    Heyday.AggregateBox.aggregateClicked(event)