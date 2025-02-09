class CreateReservations < ActiveRecord::Migration[7.0]
  def change
    create_table :reservations do |t|
      t.date :dateArrivee,null: false
      t.date :dateDepart,null: false
      t.integer :nbrVoyageurs,null: false
      t.integer :prixTotal,null: false
      t.string :statut,null: false
      t.references :post, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
