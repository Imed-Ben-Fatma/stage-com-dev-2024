class TypeLogement < ApplicationRecord
  self.inheritance_column = :_type_disabled

  belongs_to :post

  VALID_TYPES = [
    'Appartement', 'Maison', 'Chambre privée', 'Chambre partagée', 'Studio', 'Villa', 'Bungalow',
    'Chalet', 'Cabane', 'Maison de ville', 'Gîte', 'Hôtel', 'Auberge', 'Péniche', 'Tente', 'Tipi',
    'Yourte', 'Roulotte', 'Igloo', 'Refuge', 'Tour', 'Ferme', 'Château', 'Résidence secondaire',
    'Complexe hôtelier', 'Bed and breakfast'
  ]
  validates :type, inclusion: { in: VALID_TYPES, message: "type invalide" }

  VALID_TYPES_PLACE = ['Logement entier', 'Chambre privée', 'Espace partage']
  validates :typePlace, inclusion: { in: VALID_TYPES_PLACE, message: "type de place invalide" }


  def self.with_type_logement(type)
    joins(:type_logements).where(type_logements: { type: type })
  end

end
