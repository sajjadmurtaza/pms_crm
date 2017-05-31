require 'test_helper'

class Core::RolesControllerTest < ActionController::TestCase
  setup do
    @core_role = core_roles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:core_roles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create core_role" do
    assert_difference('Core::Role.count') do
      post :create, core_role: { description: @core_role.description, name: @core_role.name }
    end

    assert_redirected_to core_role_path(assigns(:core_role))
  end

  test "should show core_role" do
    get :show, id: @core_role
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @core_role
    assert_response :success
  end

  test "should update core_role" do
    patch :update, id: @core_role, core_role: { description: @core_role.description, name: @core_role.name }
    assert_redirected_to core_role_path(assigns(:core_role))
  end

  test "should destroy core_role" do
    assert_difference('Core::Role.count', -1) do
      delete :destroy, id: @core_role
    end

    assert_redirected_to core_roles_path
  end
end
