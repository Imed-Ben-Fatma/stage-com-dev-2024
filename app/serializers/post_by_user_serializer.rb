class PostByUserSerializer < ActiveModel::Serializer
    attributes :id, :titre, :prix, :moyenneNote ,:user_id
    has_one :adresse
    has_one :type_logement
    has_many :reservations

    attribute :images do
      object.images.map do |image|
        { id: image.id, url: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) }
      end
    end
  end
  