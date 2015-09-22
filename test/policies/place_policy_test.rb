require 'test_helper'

class PlacePolicyTest < ActiveSupport::TestCase

  def user
    @user ||= users(:exist)
  end

  def place
    @place ||= places(:saved)
  end

  def policy
    @policy ||= PlacePolicy.new(user, place)
  end

  test "visitor can view, create" do
    assert policy.show?
    assert policy.create?
    assert_not policy.edit?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "authenticated user can view, create" do
    assert policy.show?
    assert policy.create?
    assert_not policy.edit?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "owner can view, create, edit/update their own" do
    place.user = user
    policy = PlacePolicy.new( user, place )
    assert place.valid?, place.errors.full_messages
    assert policy.show?
    assert policy.create?
    assert policy.edit?
    assert policy.update?
    assert_not policy.destroy?
  end

end
