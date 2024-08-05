class NotesController < ApplicationController

    before_action :authenticate_user!
    before_action :set_note, only: %i[show update destroy ] 
#-------------------------------------------------------------------------------------
    # GET /notes
    def index
        authorize :note, :index?
        @notes = Note.all
        render json: @notes
    end
#-------------------------------------------------------------------------------------
    # GET /notes/1
    def show
        authorize :note, :show?
        render json: @note
    end
#-------------------------------------------------------------------------------------
    def noteByReservation
        if current_user
          if current_user.role == 'user'
            @note = Note.find_by(user_id: current_user.id , reservation_id: params[:reservation_id])
          elsif current_user.role == 'admin'
            @note = Note.find_by(user_id: params[:user_id] , reservation_id: params[:reservation_id])
          else
            render json: { error: 'You are not authorized to perform this action.' }, status: :unprocessable_entity
            return
          end
    
          if @note
            render json: @note
          else
            render json: nil, status: :not_found
          end
        else
          render json: { error: 'You are not authorized to perform this action.' }, status: :unprocessable_entity
        end
      end

#-------------------------------------------------------------------------------------
        # POST /notes
    def create
        authorize :note, :create?
        @note = Note.new(note_params)
        @note.user = current_user
        @reservation= Reservation.find(note_params[:reservation_id])
        if current_user.role == 'admin' || current_user.id == @reservation.user_id
            if @note.save
            render json: @note, status: :created, location: @note
            else
                render json: @note.errors, status: :unprocessable_entity
            end
        else
            render json: { error: 'You are not authorized to perform this action.' }, status: :unprocessable_entity
        end

    end
#-------------------------------------------------------------------------------------

    # PATCH/PUT /notes/1
    def update
        authorize @note

        if @note.user_id != current_user.id
            
            render json: { error: 'Unauthorized action' }, status: :unprocessable_entity

        else

            if @note.update(note_params)
                render json: @note, status: :ok
            else
                render json: @note.errors, status: :unprocessable_entity
            end
            
        end

        
    end
#-------------------------------------------------------------------------------------

    # DELETE /note/1
    def destroy
        authorize :note, :destroy?
        @note.destroy
    end
#-------------------------------------------------------------------------------------

    # Use callbacks to share common setup or constraints between actions.
    def set_note
        @note = Note.find(params[:id])
    end
    
    # Only allow a list of trusted parameters through.
    def note_params
        params.require(:note).permit(:note, :reservation_id, :post_id)
    end
  
end
