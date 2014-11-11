require 'test_helper'

class YoolyoolyControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
