class NoteSerializer < ActiveModel::Serializer
  attributes :note ,:post_id ,:user_id
end
