class Equipement < ApplicationRecord
    belongs_to :post

    VALID=['Wi-Fi','Télévision','Chauffage','Climatisation','Eau chaude','Réfrigérateur','Four',
    'Micro-ondes','Cuisinière','Ustensiles de cuisine','Bouilloire','Machine à café','Jacuzzi',
    'Grille-pain','Lave-vaisselle','Shampooing','Sèche-cheveux','Lave-linge','Fer à repasser',
    'Cintres','Draps supplémentaires','Oreillers et couvertures supplémentaires','Cheminée',
    'Détecteur de fumée','Trousse de premiers secours','Extincteur','Livres et magazines',
    'Parking','Chaise haute','Jeux de société','Piscine','Salle de sport']
    
    validates :nom, inclusion: { in: VALID, message: "Equipement invalide" }
end
