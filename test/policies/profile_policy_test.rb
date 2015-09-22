require 'test_helper'

class ProfilePolicyTest < ActiveSupport::TestCase

  def user
    @user ||= users(:exist)
  end

  def profile
    @profile ||= profiles(:dtod)
  end

  test "visitor can view, create" do
    policy = ProfilePolicy.new(nil, profile)

    assert     policy.show?
    assert     policy.create?
    assert_not policy.edit?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "authenticated user can view, create" do
    policy = ProfilePolicy.new(user, profile)

    assert     policy.show?
    assert     policy.create?
    assert_not policy.edit?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "owner can view, create, edit/update their own" do
    profile.user = user
    policy = ProfilePolicy.new( user, profile )

    assert profile.valid?, profile.errors.full_messages
    assert policy.show?
    assert policy.create?
    assert policy.edit?
    assert policy.update?
    assert_not policy.destroy?
  end

end
