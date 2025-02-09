class Reservation < ApplicationRecord
  belongs_to :post
  belongs_to :user
  
 
  has_one :note, dependent: :destroy  
  
  validates :dateArrivee, :dateDepart, presence: true
  validate :no_overlapping_reservations

  validates :statut, inclusion: { in: ['accepter', 'refuser', 'en cours de traitement'], message: "Statut invalide" }
  
  
  
  def dates_between
    (dateArrivee..dateDepart).to_a
  end

  private

  def no_overlapping_reservations
    #overlaps? :une méthode personnalisée qui vérifie si deux plages de dates se chevauchent.
    if post.reservations.any? { |r| (r.dateArrivee..r.dateDepart).overlaps?(dateArrivee..dateDepart) && r != self }
      errors.add(:base, "Impossible de créer une réservation. Il y a déjà une réservation pour la période souhaitée.")
    end
  end
end
