class Post < ApplicationRecord
    has_many_attached :images

    has_one :adresse, dependent: :destroy
    accepts_nested_attributes_for :adresse


    has_many :equipements, dependent: :destroy
    accepts_nested_attributes_for :equipements, allow_destroy: true

end
