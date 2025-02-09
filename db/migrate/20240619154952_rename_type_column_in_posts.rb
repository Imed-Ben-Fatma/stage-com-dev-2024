class RenameTypeColumnInPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :type, :logement_type
  end
end
