require 'test_helper'

class OrganizationUnitsControllerTest < ActionController::TestCase
  setup do
    @organization_unit = organization_units(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:organization_units)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create organization_unit" do
    assert_difference('OrganizationUnit.count') do
      post :create, organization_unit: {  }
    end

    assert_redirected_to organization_unit_path(assigns(:organization_unit))
  end

  test "should show organization_unit" do
    get :show, id: @organization_unit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @organization_unit
    assert_response :success
  end

  test "should update organization_unit" do
    patch :update, id: @organization_unit, organization_unit: {  }
    assert_redirected_to organization_unit_path(assigns(:organization_unit))
  end

  test "should destroy organization_unit" do
    assert_difference('OrganizationUnit.count', -1) do
      delete :destroy, id: @organization_unit
    end

    assert_redirected_to organization_units_path
  end
end
