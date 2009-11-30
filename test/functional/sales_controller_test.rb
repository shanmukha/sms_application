require 'test_helper'

class SalesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sale" do
    assert_difference('Sale.count') do
      post :create, :sale => { }
    end

    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should show sale" do
    get :show, :id => sales(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => sales(:one).to_param
    assert_response :success
  end

  test "should update sale" do
    put :update, :id => sales(:one).to_param, :sale => { }
    assert_redirected_to sale_path(assigns(:sale))
  end

  test "should destroy sale" do
    assert_difference('Sale.count', -1) do
      delete :destroy, :id => sales(:one).to_param
    end

    assert_redirected_to sales_path
  end
end
