class PostPolicy < ApplicationPolicy
  def create?
    user.present? && (user.admin? || user.owner?)
  end

  def update?
    user.present? && (user.admin? || (user.owner? && user.id == record.user_id))
  end

  def destroy?
    user.present? && (user.admin? || (user.owner? && record.user_id == user.id))
  end

  def show?
    true
  end

  def index?
    
    true

  end

  def update_archived?
    
    user.present? && (user.admin? || (user.owner? && record.user_id == user.id))


  end

  def update_blocked?
    
    user.present? && user.admin?


  end

  def posts_by_user?
    user.present? && (user.admin? || user.owner?)
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
