require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def user
    @user ||= users(:exist)
  end

  test "valid" do
    assert user.valid?
  end

  test "requires an email" do
    user.email = nil
    assert_not user.valid?
  end

  test "requires a unique email" do
    u = User.new(email: user.email, password: "alegitpassword")
    assert_not u.valid?
  end

  test "requires a password" do
    u = User.new(email: "valid@email.net")
    assert_not u.valid?
  end

  test "doesn't need a token" do
    user.token = nil
    assert user.valid?
  end
end
