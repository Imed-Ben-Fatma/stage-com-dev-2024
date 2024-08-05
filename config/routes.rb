Rails.application.routes.draw do

  
  
  resources :posts do
    member do
      patch 'update_blocked'
      patch 'update_archived'
    end
  end
  get 'posts_by_user', to: 'posts#posts_by_user'



  
  resources :commentaires

  resources :notes
  get 'noteByReservation', to: 'notes#noteByReservation'


  patch '/users/update', to: 'users/update#update'
  patch '/users/updateForAdmin', to: 'users/update#update_user_for_admin'
  get '/users/profile', to: 'users/user#profile'
  get '/users/byId', to: 'users/user#user_by_id'
  get '/users/all', to: 'users/user#index'
  get '/users/allOwners', to: 'users/user#getOwner'
  get '/users/allUsers', to: 'users/user#getUser'
  get '/users/search', to: 'users/user#search'
  delete '/users/:id', to: 'users/user#destroy'

  resources :reservations 
  get '/reservations_by_post', to: 'reservations#reservations_by_post'
  get '/reservations_by_current_user', to: 'reservations#reservations_by_current_user'
  get '/reservations_by_user', to: 'reservations#reservations_by_user'
  patch '/reservations_update_statut', to: 'reservations#update_status'



  
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
end