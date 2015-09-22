require "test_helper"

class UsersControllerTest < ActionController::TestCase
  include Common

  def user
    @user ||= users(:exist)
  end

  test "show" do
    get :show, id: user.id
  end

  test "create" do
    set_content_type_header!
    post :create,
    {
      data: {
       type: 'users',
       attributes: {
         email:    'email',
         password: 'password'
       }
      }
    }
    assert_response :created
    token = JSON.parse(response.body)['data']['attributes']['token']
    assert token.length > 20, token
  end
end
