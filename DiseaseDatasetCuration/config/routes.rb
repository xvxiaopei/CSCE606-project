Rails.application.routes.draw do
  
  get 'auth/:provider/callback', to: 'sessions#create'
  get 'auth/failure', to: redirect('/')
  get 'signout', to: 'sessions#destroy', as: 'signout'

  resources :sessions, only: [:create, :destroy]
  
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
  get   'admin/search' => 'admins#search'
  post  'admin/search', to: 'admins#search'
  get   'admin/confirm_search' => 'admins#confirm_search'
  post  'admin/confirm_search', to: 'admins#confirm_search'
  
  get   'admin/promote' => 'admins#promote'
  post  'admin/promote', to: 'admins#promote', as: "admin_pro"

  # Admin Group Operations
  #get   '/admin/showgroups' => 'admins#showgroups'
  resources :groups, path: '/admin/groups'
  
  get   'groups/adduser/:id' => 'groups#adduser'
  post  'groups/adduser/:id', to: 'groups#adduser', as: "group_add"
  get   'groups/:id/quickadduser' => 'groups#quickadduser'
  post  'groups/:id/quickadduser', to: 'groups#quickadduser', as: "quick_group_add"  
  
  
  # Sessions
  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'logout'  => 'sessions#destroy'

  # Dummies
  # get    'dummie'  => 'dummie#index'
  #get 'auth/google_oauth2/callback' =>'sessions#create'
  get    'download_help'  => 'sessions#download_help'
  get    'tutorial' => 'sessions#tutorial'
end
