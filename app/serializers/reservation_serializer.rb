class ReservationSerializer < ActiveModel::Serializer
  attributes :dateArrivee,:dateDepart,:nbrVoyageurs,:prixTotal, :statut


end
