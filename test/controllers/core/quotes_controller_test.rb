require 'test_helper'

class Core::QuotesControllerTest < ActionController::TestCase
  setup do
    @core_quote = core_quotes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:core_quotes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create core_quote" do
    assert_difference('Core::Quote.count') do
      post :create, core_quote: { description: @core_quote.description, lead_id: @core_quote.lead_id, price: @core_quote.price, project_id: @core_quote.project_id, quote_date: @core_quote.quote_date, reference_id: @core_quote.reference_id, reference_type: @core_quote.reference_type, split_type_id: @core_quote.split_type_id }
    end

    assert_redirected_to core_quote_path(assigns(:core_quote))
  end

  test "should show core_quote" do
    get :show, id: @core_quote
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @core_quote
    assert_response :success
  end

  test "should update core_quote" do
    patch :update, id: @core_quote, core_quote: { description: @core_quote.description, lead_id: @core_quote.lead_id, price: @core_quote.price, project_id: @core_quote.project_id, quote_date: @core_quote.quote_date, reference_id: @core_quote.reference_id, reference_type: @core_quote.reference_type, split_type_id: @core_quote.split_type_id }
    assert_redirected_to core_quote_path(assigns(:core_quote))
  end

  test "should destroy core_quote" do
    assert_difference('Core::Quote.count', -1) do
      delete :destroy, id: @core_quote
    end

    assert_redirected_to core_quotes_path
  end
end
