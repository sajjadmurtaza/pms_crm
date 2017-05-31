require 'test_helper'

class Directory::AccountsControllerTest < ActionController::TestCase
  setup do
    @directory_account = directory_accounts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:directory_accounts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create directory_account" do
    assert_difference('Directory::Account.count') do
      post :create, directory_account: { account_number: @directory_account.account_number, email: @directory_account.email, title: @directory_account.title }
    end

    assert_redirected_to directory_account_path(assigns(:directory_account))
  end

  test "should show directory_account" do
    get :show, id: @directory_account
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @directory_account
    assert_response :success
  end

  test "should update directory_account" do
    patch :update, id: @directory_account, directory_account: { account_number: @directory_account.account_number, email: @directory_account.email, title: @directory_account.title }
    assert_redirected_to directory_account_path(assigns(:directory_account))
  end

  test "should destroy directory_account" do
    assert_difference('Directory::Account.count', -1) do
      delete :destroy, id: @directory_account
    end

    assert_redirected_to directory_accounts_path
  end
end
