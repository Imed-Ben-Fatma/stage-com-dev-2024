class UserSerializer < ActiveModel::Serializer
  attributes :name,:telephone

  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(object.avatar, only_path: true) if object.avatar.attached?
  end
end