class ReservationPolicy < ApplicationPolicy
  def create?
    user.present?&&( user.user? || user.admin?)
  end

  def update?
    user.present? && (user.admin? || record.user_id == user.id)
  end

  def destroy?
    user.present? && (user.admin? || record.user_id == user.id)
  end

  def show?
    user.present? && user.admin? 
  end

  def index?
    user.present? && user.admin?
  end

  def reservations_by_post?
    user.present?
  end
  def reservations_by_current_user?
    user.present? &&  user.user?

  end

  def reservations_by_user?
    user.present? && user.admin? 
  end

  def update_status?
    user.present? && (user.admin? || user.owner?)
  end

  class Scope < Scope
    def resolve
      if user.admin?
        scope.all
      else
        scope.where(user: user)
      end
    end
  end
end
