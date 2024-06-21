class TestController < ApplicationController
    include RackSessionsFix  
    respond_to :json
    def index
        @users = User.select(:id, :name, :email, :role) # Ajoutez tous les attributs que vous souhaitez sélectionner, excepté :avatar
        render json: @users
      end

    
end