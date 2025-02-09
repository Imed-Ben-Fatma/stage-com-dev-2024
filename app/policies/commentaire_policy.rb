class CommentairePolicy < ApplicationPolicy
  def create?
    user.present? && user.user?
  end

  def index?
    user.present? && user.admin?
  end

  def show?
    user.present? && (user.admin? || (user.user? && record.user_id == user.id))
  end

  def update?
    user.present? &&  (user.admin? || (user.user? &&( record.user_id == user.id)))
  end

  def destroy?
    user.admin? || (user.user? && record.user_id == user.id)
  end

  class Scope < Scope
    def resolve
      scope.all 
    end
  end
end
