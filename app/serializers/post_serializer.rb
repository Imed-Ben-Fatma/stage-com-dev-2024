class PostSerializer < ActiveModel::Serializer
  attributes :id, :titre, :prix, :moyenneNote 

  attribute :images do
    object.images.map do |image|
      { id: image.id, url: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) }
    end
  end

  belongs_to :user , key: :owner
  has_many :notes
  has_one :type_logement
end
