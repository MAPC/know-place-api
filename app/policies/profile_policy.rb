class ProfilePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def edit?
    # Must be a non-nil user.

    # This captures the case when the record doesn't have an owner
    # and the owner is nil.
    return false if !user
    record.user == user   # Owner can edit
  end

  def update?
    # Owner can update
    edit?
  end
end
