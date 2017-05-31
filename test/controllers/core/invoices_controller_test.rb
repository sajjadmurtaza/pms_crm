require 'test_helper'

class Core::InvoicesControllerTest < ActionController::TestCase
  setup do
    @core_invoice = core_invoices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:core_invoices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create core_invoice" do
    assert_difference('Core::Invoice.count') do
      post :create, core_invoice: { cost: @core_invoice.cost, due_date: @core_invoice.due_date, organization_unit_id: @core_invoice.organization_unit_id, project: @core_invoice.project, split_type_id: @core_invoice.split_type_id, task: @core_invoice.task }
    end

    assert_redirected_to core_invoice_path(assigns(:core_invoice))
  end

  test "should show core_invoice" do
    get :show, id: @core_invoice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @core_invoice
    assert_response :success
  end

  test "should update core_invoice" do
    patch :update, id: @core_invoice, core_invoice: { cost: @core_invoice.cost, due_date: @core_invoice.due_date, organization_unit_id: @core_invoice.organization_unit_id, project: @core_invoice.project, split_type_id: @core_invoice.split_type_id, task: @core_invoice.task }
    assert_redirected_to core_invoice_path(assigns(:core_invoice))
  end

  test "should destroy core_invoice" do
    assert_difference('Core::Invoice.count', -1) do
      delete :destroy, id: @core_invoice
    end

    assert_redirected_to core_invoices_path
  end
end
