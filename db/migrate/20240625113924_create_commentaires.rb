class CreateCommentaires < ActiveRecord::Migration[7.0]
  def change
    create_table :commentaires do |t|
      t.text :commentaire, null: false
      t.references :user, null: false, foreign_key: true
      t.references :post, null: false, foreign_key: true
      t.references :reservation, null: false, foreign_key: true

      t.timestamps
    end
  end
end
