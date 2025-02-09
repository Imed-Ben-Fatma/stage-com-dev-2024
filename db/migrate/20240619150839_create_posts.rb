class CreatePosts < ActiveRecord::Migration[7.0]
  def change
    create_table :posts do |t|
      t.string :titre ,null: false
      t.string :description ,null: false
      t.integer :nbrChambres ,default: 0
      t.integer :nbrLits ,default: 0
      t.integer :prix ,null: false
      t.string :type ,null: false
      t.text :regles ,default: ""

      t.timestamps
    end
  end
end
