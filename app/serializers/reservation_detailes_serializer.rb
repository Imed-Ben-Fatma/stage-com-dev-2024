class ReservationDetailesSerializer < ActiveModel::Serializer
  attributes :id,:prixTotal,:statut ,:dateArrivee,:dateDepart, :dates_between

  has_one :user
  
    def dates_between
      object.dates_between
    end
  end