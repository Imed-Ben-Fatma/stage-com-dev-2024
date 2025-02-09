class RemoveLogementTypeFromPosts < ActiveRecord::Migration[7.0]
  def change
    remove_column :posts, :logement_type, :string
  end
end
