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
  post 'profile', to: 'users#show'
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
  
  get   'admin/promote' => 'admins#promote'
  post  'admin/promote', to: 'admins#promote', as: "admin_pro"
  get   'admin/promotewithgroup' => 'admins#promotewithgroup'
  post  'admin/assign_admins_to_group/:id', to: 'admins#performassigngroup', as:"assign_group"  
  get   'admin/manage_group_admins_groups' => 'admins#managegrps'
  post  'admin/manage_group_admins_groups/:id', to: 'admins#rearrange', as: "rearrange_grpadmin"
  get   'admin/statistics' => 'admins#statistics'
  post  'admin/statistics', to: 'admins#statistics'
  # Admin Group Operations
  #get   '/admin/showgroups' => 'admins#showgroups'
  resources :groups, path: '/admin/groups'
  
  get   'groups/adduser/:id' => 'groups#adduser'
  post  'groups/adduser/:id', to: 'groups#adduser', as: "group_add"
  get   '/admin/groups/:id/quickadduser' => 'groups#quickadduser'
  post  '/admin/groups/:id/quickadduser', to: 'groups#performadd', as: "quick_group_add"  
  
  get   'addquestion/search' => 'addquestions#search'
  post  'addquestion/search', to: 'addquestions#search'
#  get   'addquestion/confirm_search' => 'addquestions#confirm_search'
#  post  'addquestion/confirm_search', to: 'addquestions#confirm_search'
  get   'addquestion/delete_dataset' => 'addquestions#delete_dataset'
  post  'addquestion/delete_dataset', to: 'addquestions#delete_dataset'
  get   'addquestion/delete_group' => 'addquestions#delete_group'
  post  'addquestion/delete_group', to: 'addquestions#delete_group'
  get   'addquestion/destroy' => 'addquestions#destroy'
  post  'addquestion/destroy', to: 'addquestions#destroy'
  get   'addquestion/submit_result' => 'addquestions#submit_result'
  post  'addquestion/submit_result', to: 'addquestions#submit_result'
  get   'addquestion/show' => 'addquestions#show'
  post  'addquestion/show', to: 'addquestions#show'
  get   'addquestion/delete_in_show' => 'addquestions#delete_in_show'
  post  'addquestion/delete_in_show', to: 'addquestions#delete_in_show'
  get 'index' => 'addquestions#index'
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
  
  
  
  
  #New Stuff
  #Integrated questions
  resources :fullquestions, path: '/admin/fullquestions'
  #Integrated submissions
  resources :submissions, path: '/admin/submissions'
  
  #Search
  get   'admin/fullquestion_addquestion_s' => 'fullquestions#search'
  post  'admin/fullquestion_addquestion_s', to: 'fullquestions#performsearch', as: 'full_search'  
  
  
  
  
  
  
end