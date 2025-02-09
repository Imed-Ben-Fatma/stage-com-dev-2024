class ReservationsController < ApplicationController
    before_action :authenticate_user! , only: %i[reservations_by_post]
    before_action :set_reservation, only: %i[show update destroy]
#-------------------------------------------------------------------------------------
    # GET /reservations
    def index
      @reservations = Reservation.includes(:post).all
      authorize @reservations
      render json: @reservations
    end
#-------------------------------------------------------------------------------------
    # GET /reservations_by_post
    def reservations_by_post
      authorize :reservation, :reservations_by_post?
      post_id = params[:post_id]

      if post_id
        @reservations = Reservation.includes(:post).where(post_id: post_id).order(created_at: :desc)

        if current_user.role == 'owner'
          @reservations = @reservations.where(posts: { user_id: current_user.id })
          render json: @reservations, each_serializer: ReservationDetailesSerializer

        elsif current_user.role == 'admin'
          render json: @reservations, each_serializer: ReservationDetailesSerializer

        else
          render json: @reservations, each_serializer: ReservationDateSerializer
        end
      else
        render json: { message: "Post ID is missing" }, status: :bad_request
      end
    end
#-------------------------------------------------------------------------------------

    def reservations_by_current_user

      if current_user
        @reservations = Reservation.includes(:post).where(user_id: current_user).order(dateArrivee: :desc)
        authorize @reservations 
        render json: @reservations, each_serializer: ReservationUserDetailesSerializer
      else
        render json: { message: "Reservation is missing" }, status: :bad_request
      end
    end
#-------------------------------------------------------------------------------------

    def reservations_by_user
      authorize :reservation, :reservations_by_user?

      if params[:user_id]
        @reservations = Reservation.includes(:post).where(user_id: params[:user_id])
        render json: @reservations, each_serializer: ReservationUserDetailesSerializer
      else
        render json: { message: "Reservation is missing" }, status: :bad_request
      end
    end
#-------------------------------------------------------------------------------------
  
    # GET /reservations/1
    def show
      authorize :reservation, :show?

      render json: @reservation
    end
#-------------------------------------------------------------------------------------  
    # POST /reservations
    def create
      authorize :reservation, :create?

      @reservation = Reservation.new(reservation_params)
      @reservation.user = current_user
      @reservation.statut = 'en cours de traitement'

      post = Post.find(reservation_params[:post_id])
      days = (@reservation.dateDepart.to_date - @reservation.dateArrivee.to_date).to_i
      @reservation.prixTotal = days * post.prix

      if @reservation.valid? && @reservation.save && ( days > 0)
        render json: @reservation.to_json(include: [:post]), status: :created, location: @reservation
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
    end
#-------------------------------------------------------------------------------------

    # PATCH/PUT /reservations/1
    def update
      authorize :reservation, :update?

      if @reservation.update(reservation_params)
        render json: @reservation.to_json(include: [:post, :user])
      else
        render json: @reservation.errors, status: :unprocessable_entity
      end
    end
#-------------------------------------------------------------------------------------
    # DELETE /reservations/1
    def destroy
      authorize @reservation

      if @reservation.destroy
        render json: { message: 'Reservation and associated notes and comments successfully deleted.' }, status: :ok
      else
        render json: { error: 'Failed to delete the reservation.' }, status: :unprocessable_entity
      end
    end
#-------------------------------------------------------------------------------------
    # PATCH/PUT /reservations/reponse
    def update_status
      authorize :reservation, :update_status?

      @reservation = Reservation.find(status_params[:reservation_id])
      owner_post = Post.find(@reservation.post_id).user
    
      if owner_post == current_user || current_user.role =='admin'

        if @reservation.update(statut: status_params[:statut])
          render json: @reservation
        else
          render json: @reservation.errors, status: :unprocessable_entity
        end
      end
    end


    private
  
    # Use callbacks to share common setup or constraints between actions.
    def set_reservation
      @reservation = Reservation.find(params[:id])
    end
  
    # Only allow a list of trusted parameters through.
    def reservation_params
      params.require(:reservation).permit(:dateArrivee, :dateDepart, :nbrVoyageurs, :post_id)
    end


    def status_params
      params.permit(:statut, :reservation_id)
    end

    
end
  