require 'test_helper'

class ReportPolicyTest < ActiveSupport::TestCase

  def user
    @user ||= users(:exist)
  end

  def report
    @report ||= reports(:tod)
  end

  test "visitor can't do anything" do
    policy = ReportPolicy.new( nil, report )
    assert policy.show?
    assert_not policy.edit?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "user can't do anything" do
    policy = ReportPolicy.new( user, report )
    assert policy.show?
    assert_not policy.edit?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

  test "owner can't do anything" do
    skip "no ownership possible"
    report.user = user
    policy = ReportPolicy.new( user, report )
    assert policy.show?
    assert_not policy.edit?
    assert_not policy.create?
    assert_not policy.update?
    assert_not policy.destroy?
  end

end
