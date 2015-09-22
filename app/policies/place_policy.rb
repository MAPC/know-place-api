class PlacePolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    true
  end

  def edit?
    # Owner can edit
    record.user == user
  end

  def update?
    # Owner can update
    edit?
  end
end
