class CommentairesController < ApplicationController
 # before_action :authenticate_user!
  before_action :set_commentaire, only: [:show, :update, :destroy]
#-------------------------------------------------------------------------------------
  # GET /commentaires
  def index
    authorize :commentaire, :index?
    @commentaires = Commentaire.all
    render json: @commentaires
  end
#-------------------------------------------------------------------------------------
  # GET /commentaires/1
  def show
    authorize @commentaire
    render json: @commentaire ,  serializer:CommentaireDetailesSerializer
  end
#-------------------------------------------------------------------------------------

  # POST /commentaires
  def create
    authorize :commentaire, :create?
    @commentaire = Commentaire.new(commentaire_params)
    @commentaire.user_id = current_user.id
    @reservation = Reservation.find(@commentaire.reservation_id)
  
    if (@commentaire.user_id != @reservation.user_id)&&(@reservation.post_id != @commentaire.post_id)
      render json: "Erreur: vous n'êtes pas autorisé à commenter cette réservation.", status: :unprocessable_entity
    elsif @commentaire.save
      render json: @commentaire, status: :created, location: @commentaire
    else
      render json: @commentaire.errors, status: :unprocessable_entity
    end
  end
#-------------------------------------------------------------------------------------
  # PATCH/PUT /commentaires/1
  def update
    authorize @commentaire
    if (@commentaire.user_id == current_user.id) ||(current_user.role=='admin')
      if @commentaire.update(commentaire_update_params)
        render json: @commentaire
      else
        render json: @commentaire.errors, status: :unprocessable_entity
      end
    else
      render json: "Erreur: vous n'êtes pas autorisé à mettre à jour ce commentaire.", status: :unprocessable_entity

    end
  end
#-------------------------------------------------------------------------------------
  # DELETE /commentaires/1
  def destroy
    authorize @commentaire
    @commentaire.destroy
  end
#-------------------------------------------------------------------------------------
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_commentaire
      @commentaire = Commentaire.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def commentaire_params
      params.permit(:commentaire, :post_id, :reservation_id)
    end

    def commentaire_update_params
      params.permit(:commentaire)
    end
end
