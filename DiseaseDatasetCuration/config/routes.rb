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
  get   'admin/statistics' => 'admins#statistics'
  get   'admin/allusers' => 'admins#allusers'
  post  'admin/allusers', to: 'admins#allusers', as: "admin_all"
  get   'admin/getcsv' => 'admins#getcsv'
  get   'admin/search' => 'admins#search'
  post  'admin/search', to: 'admins#search'
  get   'admin/confirm_search' => 'admins#confirm_search'
  post  'admin/confirm_search', to: 'admins#confirm_search'
  get   'admin/delete_dataset' => 'admins#delete_dataset'
  post  'admin/delete_dataset', to: 'admins#delete_dataset'
  
  get   'admin/promote' => 'admins#promote'
  post  'admin/promote', to: 'admins#promote', as: "admin_pro"
  get   'admin/promotewithgroup' => 'admins#promotewithgroup'
  post  'admin/assign_admins_to_group/:id', to: 'admins#performassigngroup', as:"assign_group"  
  get   'admin/manage_group_admins_groups' => 'admins#managegrps'
  post  'admin/manage_group_admins_groups/:id', to: 'admins#rearrange', as: "rearrange_grpadmin"

  # Admin Group Operations
  #get   '/admin/showgroups' => 'admins#showgroups'
  resources :groups, path: '/admin/groups'
  
  get   'groups/adduser/:id' => 'groups#adduser'
  post  'groups/adduser/:id', to: 'groups#adduser', as: "group_add"
  get   '/admin/groups/:id/quickadduser' => 'groups#quickadduser'
  post  '/admin/groups/:id/quickadduser', to: 'groups#performadd', as: "quick_group_add"  
  
  
  # Addquestion
  resources :addquestions, path: '/admin/addquestions'
  
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