class RenameNbrBathroomAndRemoveNbrBedroomInPosts < ActiveRecord::Migration[7.0]
  def change
    rename_column :posts, :nbrBathroom, :nbrSalleDeBain
    remove_column :posts, :nbrBedroom, :integer
  end
end