class Heyday.SortingDropdown

  @sortingClicked: (event, object)->
    Heyday.SortingBar.setSorting(object);

Heyday.once ->
  $(document).on 'click', 'a.sorting-attribute', (event)->
    Heyday.SortingDropdown.sortingClicked(event, this)