class CommentaireDetailesSerializer < ActiveModel::Serializer

    attributes :commentaire ,:created_at
    belongs_to :user
    has_one :note
  end
  