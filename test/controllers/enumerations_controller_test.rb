require 'test_helper'

class EnumerationsControllerTest < ActionController::TestCase
  setup do
    @enumeration = enumerations(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:enumerations)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create enumeration" do
    assert_difference('Enumeration.count') do
      post :create, enumeration: {  }
    end

    assert_redirected_to enumeration_path(assigns(:enumeration))
  end

  test "should show enumeration" do
    get :show, id: @enumeration
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @enumeration
    assert_response :success
  end

  test "should update enumeration" do
    patch :update, id: @enumeration, enumeration: {  }
    assert_redirected_to enumeration_path(assigns(:enumeration))
  end

  test "should destroy enumeration" do
    assert_difference('Enumeration.count', -1) do
      delete :destroy, id: @enumeration
    end

    assert_redirected_to enumerations_path
  end
end
