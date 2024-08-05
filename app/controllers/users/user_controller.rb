class Users::UserController < ApplicationController
    include RackSessionsFix  
    respond_to :json
    before_action :set_active_storage_url_options
    before_action :set_user, only: [:destroy]
    before_action :authenticate_user!
#-------------------------------------------------------------------------------------

    def index
      @users = User.all
      authorize :user, :index?
      render json: @users ,each_serializer: UserDetailesSerializer 
    end
#-------------------------------------------------------------------------------------

    def user_by_id
      
      user_id = params[:user_id]
      @user = User.find_by(id: user_id)
      authorize @user
      if @user
        render json: @user, serializer: UserDetailesSerializer
      else
        render json: { message: "User not found" }, status: :not_found
      end
    end
#------------------------------------------------------------------------------------- 

    def getOwner
      authorize :user, :getOwner?
      @users = User.where(role: :owner)
      render json: @users, each_serializer: UserDetailesSerializer
    end
#-------------------------------------------------------------------------------------
    def getUser
      authorize :user, :getUser?
      @users = User.all.where(role: :user)
      render json: @users ,each_serializer: UserDetailesSerializer 
    end
#-------------------------------------------------------------------------------------
    def search
      authorize :user, :search?
      query = params[:search]
      role_filter = params[:role]

      @users = User.all


      if role_filter.present? && role_filter == 'owner'
        @users = @users.where(role: 'owner')

      elsif role_filter.present? && role_filter == 'user'
        @users = @users.where(role: 'user')
      end


      if query.present?
        @users = @users.where(
          'name LIKE :query OR email LIKE :query OR status LIKE :query OR telephone LIKE :query',
          query: "%#{query}%"
        )
      end

      render json: @users ,each_serializer: UserDetailesSerializer 
    end
#-------------------------------------------------------------------------------------    
    def profile
      authorize :user, :profile?
      if current_user 
        render json: current_user ,serializer: UserDetailesSerializer 
        
      else
        render json: {
          status: { message: "User profile couldn't be updated. #{user.errors.full_messages.to_sentence}" }
        }, status: :unprocessable_entity
      end
    end
#-------------------------------------------------------------------------------------
    def destroy
      authorize @user
      @user.destroy
    end
#-------------------------------------------------------------------------------------
    private

    def set_active_storage_url_options
      ActiveStorage::Current.url_options = { host: 'http://localhost:3000' }  
    end
  
    def set_user
      @user = User.find(params[:id])
    end
  end