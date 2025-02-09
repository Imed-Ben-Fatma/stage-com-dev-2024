
class UserPolicy < ApplicationPolicy

    def index?
        user.present? && user.admin?
    end
  
    def user_by_id?
        user.present? && user.admin?
    end
      
  
    def getOwner?
        user.present? && user.admin?
    end
  
    def getUser?
        user.present? && user.admin?
    end
  
    def search?
        user.present? && user.admin?
    end
      
    def profile?
        user.present?
    end
  
    def destroy?
        user.present? && user.admin?
    end

  
    class Scope < Scope
      def resolve
        scope.all 
      end
    end
  end
  