class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :jwt_authenticatable, 
         jwt_revocation_strategy: self


#----------------------------------------------------------------    
  has_one_attached :avatar
#----------------------------------------------------------------
  enum role: { admin: 'admin', owner: 'owner', user: 'user' }

  # set a default role
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end
#----------------------------------------------------------------


end
