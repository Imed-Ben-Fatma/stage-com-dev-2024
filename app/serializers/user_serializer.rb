class UserSerializer
  include JSONAPI::Serializer
  attributes :id, :email, :name 
  # Include avatar attribute with a custom getter to return the URL
  attribute :avatar do |user|
    # Replace with your logic to retrieve the avatar URL based on user data
    user.avatar.attached? ? user.avatar.url : nil  # Example using attached avatars
  end
end
