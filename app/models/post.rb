class Post < ApplicationRecord
  belongs_to :user

  has_many :reservations , dependent: :destroy
  has_many :commentaires , dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many_attached :images


  has_one :adresse, dependent: :destroy
  accepts_nested_attributes_for :adresse

  has_many :equipements, dependent: :destroy
  accepts_nested_attributes_for :equipements, allow_destroy: true

  has_one :type_logement, dependent: :destroy

  def self.with_type_logement(type)
    joins(:type_logements).where(type_logements: { type: type })
  end

  def self.with_type_place(typePlace)
    joins(:type_logements).where(type_logements: { typePlace: typePlace })
  end

  def image_urls
    images.map do |image|
        {
          id: image.id,
          url: Rails.application.routes.url_helpers.rails_blob_url(image, only_path: true)
        }  
    end
    end


    def moyenneNote
      notes.average(:note).to_f.round(2) || 0
    end

    def comment_count
      commentaires.count
    end


    def self.with_active_reservations
      joins(:reservations).where(reservations: { statut: 'en cours de traitement' }).distinct
    end
    
end
