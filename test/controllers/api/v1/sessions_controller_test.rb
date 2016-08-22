require "test_helper"

class API::V1::SessionsControllerTest < ActionController::TestCase
  include Common

  # Not a JSONAPI controller.
  # def setup
  #   JSONAPI.configuration.raise_if_parameters_not_allowed = true
  # end

  def user
    @user = users(:exist)
  end

  test 'authorized' do
    post :create, { email: 'matt@cloyd.ly', password: 'password' }
    assert_response :success, response.body.inspect
    assert_includes response.body, 'matt@cloyd.ly'
    assert_includes response.body, 'user_id'
    assert_includes response.body, 'y7Uf-EwudUiI8zpsfdsYaQ'
    assert_not_includes response.body, 'password'
  end

  test 'unauthorized' do
    post :create, { email: 'matt@cloyd.ly', password: 'wrong_password' }
    assert_response :unauthorized, response.body.inspect
  end
end
