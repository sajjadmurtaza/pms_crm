require 'test_helper'

class Workspace::CalendarsControllerTest < ActionController::TestCase
  setup do
    @workspace_calendar = workspace_calendars(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workspace_calendars)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workspace_calendar" do
    assert_difference('Workspace::Calendar.count') do
      post :create, workspace_calendar: { color: @workspace_calendar.color, core_system_user_id: @workspace_calendar.core_system_user_id, name: @workspace_calendar.name }
    end

    assert_redirected_to workspace_calendar_path(assigns(:workspace_calendar))
  end

  test "should show workspace_calendar" do
    get :show, id: @workspace_calendar
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workspace_calendar
    assert_response :success
  end

  test "should update workspace_calendar" do
    patch :update, id: @workspace_calendar, workspace_calendar: { color: @workspace_calendar.color, core_system_user_id: @workspace_calendar.core_system_user_id, name: @workspace_calendar.name }
    assert_redirected_to workspace_calendar_path(assigns(:workspace_calendar))
  end

  test "should destroy workspace_calendar" do
    assert_difference('Workspace::Calendar.count', -1) do
      delete :destroy, id: @workspace_calendar
    end

    assert_redirected_to workspace_calendars_path
  end
end
