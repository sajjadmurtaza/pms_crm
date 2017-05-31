require 'test_helper'

class Workspace::CalendarEntriesControllerTest < ActionController::TestCase
  setup do
    @workspace_calendar_entry = workspace_calendar_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:workspace_calendar_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create workspace_calendar_entry" do
    assert_difference('Workspace::CalendarEntry.count') do
      post :create, workspace_calendar_entry: { description: @workspace_calendar_entry.description, title,: @workspace_calendar_entry.title, }
    end

    assert_redirected_to workspace_calendar_entry_path(assigns(:workspace_calendar_entry))
  end

  test "should show workspace_calendar_entry" do
    get :show, id: @workspace_calendar_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @workspace_calendar_entry
    assert_response :success
  end

  test "should update workspace_calendar_entry" do
    patch :update, id: @workspace_calendar_entry, workspace_calendar_entry: { description: @workspace_calendar_entry.description, title,: @workspace_calendar_entry.title, }
    assert_redirected_to workspace_calendar_entry_path(assigns(:workspace_calendar_entry))
  end

  test "should destroy workspace_calendar_entry" do
    assert_difference('Workspace::CalendarEntry.count', -1) do
      delete :destroy, id: @workspace_calendar_entry
    end

    assert_redirected_to workspace_calendar_entries_path
  end
end
