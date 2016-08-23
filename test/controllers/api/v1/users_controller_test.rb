require "test_helper"

class API::V1::UsersControllerTest < ActionController::TestCase
  include Common

  def user
    @user ||= users(:exist)
  end

  test "show" do
    get :show, id: user.id
    assert_response :success
    assert_not_includes response.body, "token"
  end

  test "show current authenticated user" do
    @request.headers['Authorization'] = "Token token=#{user.token}, email=#{user.email}"
    get :show, id: user.id
    assert_response :success
    assert_includes response.body, "token"
  end

  focus
  test "create" do
    set_content_type_header!
    post :create, data: create_data
    assert_response :created, JSON.parse(response.body)
    token = JSON.parse(response.body)['data']['attributes']['token']
    assert token, 'No token.'
  end

  private

  def create_data
    {
      type: 'users',
      attributes: {
        email:    'email',
        password: 'password'
      }
    }
  end
end
