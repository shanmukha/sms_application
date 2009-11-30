require 'test_helper'

class MessageTemplatesControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:message_templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create message_template" do
    assert_difference('MessageTemplate.count') do
      post :create, :message_template => { }
    end

    assert_redirected_to message_template_path(assigns(:message_template))
  end

  test "should show message_template" do
    get :show, :id => message_templates(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => message_templates(:one).to_param
    assert_response :success
  end

  test "should update message_template" do
    put :update, :id => message_templates(:one).to_param, :message_template => { }
    assert_redirected_to message_template_path(assigns(:message_template))
  end

  test "should destroy message_template" do
    assert_difference('MessageTemplate.count', -1) do
      delete :destroy, :id => message_templates(:one).to_param
    end

    assert_redirected_to message_templates_path
  end
end
