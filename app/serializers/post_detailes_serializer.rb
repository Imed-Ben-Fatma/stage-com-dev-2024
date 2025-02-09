class PostDetailesSerializer < ActiveModel::Serializer
    attributes :id, :titre, :description, :nbrChambres, :nbrLits, :prix, :regles, :nbrSalleDeBain, :moyenneNote ,:comment_count,:adresse,:archived,:blocked
  
    attribute :images do
      object.images.map do |image|
        { id: image.id, url: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true) }
      end
    end
  
    belongs_to :user , key: :owner
    has_many :reservations
    has_many :equipements
    has_one :type_logement


    attribute :commentaires do
      object.commentaires.map do |commentaire|
        {
          id: commentaire.id,
          commentaire: commentaire.commentaire,
          user_name: commentaire.user.name,
          user_image: avatar_url(commentaire.user),
          create: commentaire.created_at,
          note: commentaire.reservation&.note&.note  # Utilisation du safe navigation operator
        }
      end
    end

    def avatar_url(user)
      Rails.application.routes.url_helpers.rails_blob_url(user.avatar, only_path: true) if user.avatar.attached?
    end
  end
  