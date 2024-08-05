class ReservationUserDetailesSerializer < ActiveModel::Serializer
  attributes :id,:user_id, :prixTotal, :statut, :dateArrivee, :dateDepart, :owner,:post,:user_id



  def post
    {
      id: object.post.id,
      titre: object.post.titre,
      image: Rails.application.routes.url_helpers.rails_blob_url(object.post.images[0], only_path: true),
      note: object.post.moyenneNote,
      type_logements: object.post.type_logement,
      adresse: {
        ville: object.post.adresse&.ville,
        pays: object.post.adresse&.pays
      }
    }
    
  end

  def owner
    UserSerializer.new(object.post.user, root: false).attributes
  end
end
