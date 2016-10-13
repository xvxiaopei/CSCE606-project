Rails.application.routes.draw do
  root 'sessions#new'

  # Diseases
  get 'diseases' => 'diseases#index'
  post 'diseases/import'
  # resources :diseases do
  #   collection {post :import}
  # end

  # Users
  get 'signup'  => 'users#new'
  get 'profile' => 'users#show'
  resources :users

  # Admin
  get   'admin' => 'admins#show'
  post  'admin', to: 'admins#show', as: "admins_show"
  get   'config' => 'admins#configuration'
  post  'config', to: 'admins#config_update', as: "config_update"
  get   'admin/histogram' => 'admins#histogram'
  get   'admin/allusers' => 'admins#allusers'
  post  'admin/allusers', to: 'admins#allusers', as: "admin_all"
  get   'admin/getcsv' => 'admins#getcsv'

  # Sessions
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # Dummies
  # get    'dummie'  => 'dummie#index'
end
