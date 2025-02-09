class CreateTypeLogements < ActiveRecord::Migration[7.0]
  def change
    create_table :type_logements do |t|
      t.string :type
      t.string :typePlace
      t.references :post, null: false, foreign_key: true

      t.timestamps
    end
  end
end
