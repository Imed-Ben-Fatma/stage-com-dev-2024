class Commentaire < ApplicationRecord
  belongs_to :user
  belongs_to :post
  belongs_to :reservation
  #has_one :note, class_name: "Note", foreign_key: "id"
end
