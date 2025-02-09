class CreateEquipements < ActiveRecord::Migration[7.0]
  def change
    create_table :equipements do |t|
      t.string :nom
      t.text :description
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
