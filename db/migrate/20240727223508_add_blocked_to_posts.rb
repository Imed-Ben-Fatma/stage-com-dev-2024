class AddBlockedToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :blocked, :boolean, default: false
  end
end
