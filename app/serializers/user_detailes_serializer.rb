class UserDetailesSerializer < ActiveModel::Serializer
  attributes :id,:name,:email,:telephone, :avatar_url,:average_note,:created_at,:posts_count,:reservations_count,:status,:role

  def reservations_count
    case object.role
    when "user"
      object.total_reservations_role_user
    when "owner"
      object.total_reservations_count
    else
      nil
    end
  end


  def avatar_url
    Rails.application.routes.url_helpers.rails_blob_url(object.avatar, only_path: true) if object.avatar.attached?
  end
end