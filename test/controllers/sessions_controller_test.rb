require "test_helper"

class SessionsControllerTest < ActionController::TestCase
  include Common

  def setup
    JSONAPI.configuration.raise_if_parameters_not_allowed = true
  end

  def user
    @user = users(:exist)
  end

  test "create" do
    set_content_type_header!
    post :create, { email: 'matt@cloyd.ly', password: 'password' }
    assert_response :success, response.body.inspect
    assert_includes response.body, 'matt@cloyd.ly'
    assert_includes response.body, 'user_id'
    assert_not_includes response.body, 'password'
  end
end
