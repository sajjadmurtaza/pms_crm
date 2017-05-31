require 'test_helper'

class NotesWidgetTest < Apotomo::TestCase
  has_widgets do |root|
    root << widget(:notes_list)
  end
  
  test "display" do
    render_widget :notes_list
    assert_select "h1"
  end
end
