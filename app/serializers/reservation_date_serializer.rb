class ReservationDateSerializer < ActiveModel::Serializer
  attributes :dateArrivee,:dateDepart, :dates_between
  
  
    def dates_between
      object.dates_between
    end
  end