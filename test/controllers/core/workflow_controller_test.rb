require 'test_helper'

class Core::WorkflowControllerTest < ActionController::TestCase
  test "should get transit" do
    get :transit
    assert_response :success
  end

end
