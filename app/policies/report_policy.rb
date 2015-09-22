class ReportPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope
    end
  end

  def create?
    false
  end

  def edit?
    false
  end

  def update?
    false
  end

end
