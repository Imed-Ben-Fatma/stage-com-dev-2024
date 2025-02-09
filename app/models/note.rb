class Note < ApplicationRecord
  belongs_to :reservation
  belongs_to :post
  belongs_to :user

  validates :reservation_id, uniqueness: { message: "Vous avez déjà laissé un note pour cette réservation" }
  validates :note, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 5, message: "La note doit être comprise entre 0 et 5" }


end
