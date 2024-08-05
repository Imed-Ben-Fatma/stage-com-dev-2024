class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :jwt_authenticatable, 
         jwt_revocation_strategy: self

#----------------------------------------------------------------    
  validates :telephone, presence: true, uniqueness: true
#----------------------------------------------------------------    
  has_one_attached :avatar, dependent: :purge_later
#----------------------------------------------------------------
  enum role: { admin: 'admin', owner: 'owner', user: 'user' }

  # set a default role
  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= :user
  end
#----------------------------------------------------------------

enum status: { active: 'active', blocked: 'blocked'}

# set a default active
after_initialize :set_default_status, if: :new_record?

def set_default_status
  self.status ||= :active
end
#----------------------------------------------------------------
def average_note
  posts.joins(:notes).average(:note).to_f.round(2)

end
#----------------------------------------------------------------
def posts_count
  posts.count
end
#----------------------------------------------------------------
def total_reservations_count
  posts.joins(:reservations).count
end

def total_reservations_role_user
  reservations.count
end
#----------------------------------------------------------------
def blocked?
  status == 'blocked'
end
has_many :posts, dependent: :destroy

has_many :reservations, dependent: :destroy
end
