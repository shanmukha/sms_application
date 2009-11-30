require 'test_helper'

class LettersControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:letters)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create letter" do
    assert_difference('Letter.count') do
      post :create, :letter => { }
    end

    assert_redirected_to letter_path(assigns(:letter))
  end

  test "should show letter" do
    get :show, :id => letters(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => letters(:one).to_param
    assert_response :success
  end

  test "should update letter" do
    put :update, :id => letters(:one).to_param, :letter => { }
    assert_redirected_to letter_path(assigns(:letter))
  end

  test "should destroy letter" do
    assert_difference('Letter.count', -1) do
      delete :destroy, :id => letters(:one).to_param
    end

    assert_redirected_to letters_path
  end
end
