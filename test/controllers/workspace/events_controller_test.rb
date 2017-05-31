require 'test_helper'

class Workspace::EventsControllerTest < ActionController::TestCase
  setup do
    @workspace_event = workspace_events(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workspace_events)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workspace_event" do
    assert_difference('Workspace::Event.count') do
      post :create, workspace_event: { title: @workspace_event.title, workspace_calendar_id: @workspace_event.workspace_calendar_id }
    end

    assert_redirected_to workspace_event_path(assigns(:workspace_event))
  end

  test "should show workspace_event" do
    get :show, id: @workspace_event
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workspace_event
    assert_response :success
  end

  test "should update workspace_event" do
    patch :update, id: @workspace_event, workspace_event: { title: @workspace_event.title, workspace_calendar_id: @workspace_event.workspace_calendar_id }
    assert_redirected_to workspace_event_path(assigns(:workspace_event))
  end

  test "should destroy workspace_event" do
    assert_difference('Workspace::Event.count', -1) do
      delete :destroy, id: @workspace_event
    end

    assert_redirected_to workspace_events_path
  end
end
