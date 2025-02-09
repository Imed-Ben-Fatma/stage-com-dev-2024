class CreateAdresses < ActiveRecord::Migration[7.0]
  def change
    create_table :adresses do |t|
      t.string :rue 
      t.string :ville ,null: false
      t.string :pays ,null: false
      t.string :localisationGPS ,null: false
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
