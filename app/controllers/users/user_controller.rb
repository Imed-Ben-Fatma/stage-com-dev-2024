class Users::UserController < ApplicationController
    include RackSessionsFix  
    respond_to :json
    before_action :set_active_storage_url_options
    before_action :authenticate_user!  # Ensure user is authenticated before update
  
    def profile
      user = current_user  
  
      if user
        render json: {
          status: { code: 200, message: 'Get user profile' },
          data: UserSerializer.new(user).serializable_hash[:data][:attributes]
        }
      else
        render json: {
          status: { message: "User profile couldn't be updated. #{user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end

    private

    def set_active_storage_url_options
      ActiveStorage::Current.url_options = { host: 'http://localhost:3000' }  
    end
  

  end