Rails.application.routes.draw do
  resources :posts


  put '/users/update', to: 'users/update#update'
  get '/users/profile', to: 'users/user#profile'
  get '/test', to: 'test#index'
 #resources :users, only: [:index]

  
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