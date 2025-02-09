class NotePolicy < ApplicationPolicy
  def create?
    user.present? &&  (user.admin? || user.user?)
  end

  def update?
    user.present? && (user.admin? || (user.user? && record.user_id == user.id))
  end

  def destroy?
    user.present? && user.admin?
  end

  def show?
    user.present? && user.admin?
  end

  def index?
    user.present? && user.admin?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
