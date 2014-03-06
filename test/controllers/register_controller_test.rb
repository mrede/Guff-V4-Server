require 'test_helper'

class RegisterControllerTest < ActionController::TestCase
  test "should get android" do
    get :android
    assert_response :success
  end

  test "should get ios" do
    get :ios
    assert_response :success
  end

end
