class AddBedroomsAndBathroomsToPosts < ActiveRecord::Migration[7.0]
  def change
    add_column :posts, :nbrBedroom, :integer
    add_column :posts, :nbrBathroom, :integer
  end
end
