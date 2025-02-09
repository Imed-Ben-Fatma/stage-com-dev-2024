class Users::UpdateController < ApplicationController
    include RackSessionsFix  
    respond_to :json
  
    before_action :authenticate_user!  # Ensure user is authenticated before update
    before_action :set_active_storage_url_options

    def update
      @user = current_user  
  
      if @user.update(update_user_params)
        render json: {
          status: { code: 200, message: 'User profile updated successfully.' },
          
        }
      else
        render json: {
          status: { message: "User profile couldn't be updated. #{user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
  
    def update_user_for_admin
      user = User.find(params[:id])
  
      if user.update(update_user_params_for_admin)
        render json: {
           message: 'profile updated successfully.' 
        }
      else
        render json: {
          status: { message: "User profile couldn't be updated. #{user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
  
    private
  
    def update_user_params_for_admin
      params.permit(:id, :name, :email,:telephone, :status)
    end
    
    def update_user_params
      params.permit(:name, :avatar,:email,:telephone) 
    end



    def set_active_storage_url_options
      ActiveStorage::Current.url_options = { host: 'http://localhost:3000' }  
    end
  end