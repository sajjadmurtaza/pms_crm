require 'test_helper'

class TaskListWidgetTest < Apotomo::TestCase
  has_widgets do |root|
    root << widget(:task_list)
  end
  
  test "display" do
    render_widget :task_list
    assert_select "h1"
  end
end
