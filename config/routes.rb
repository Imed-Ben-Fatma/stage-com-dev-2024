Rails.application.routes.draw do


  put '/users/update', to: 'users/update#update'
  get '/users/profile', to: 'users/user#profile'


  
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