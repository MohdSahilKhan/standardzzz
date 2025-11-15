Rails.application.routes.draw do
  resources :managers
  namespace :admin do
    root to: "users#index"
    resources :users
    resources :statuses
    resources :tasks
    resources :projects
    resources :roles
  end
  
  get '/displayleaves', to: 'leaves#display_leaves'
  
  devise_for :users
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  resources :statuses
  resources :leaves
  resources :salary_infos
  post '/users/new_user', to: 'users#create'
  
  get '/users/:id', to: 'users#show'

  post '/users/:user_id/assign_managers', to: 'users#assign_managers'
  
  namespace :api do
    post 'login', to: 'sessions#create'
    post 'verify_email', to: 'sessions#verify_email'
    post 'verify_mobile', to: 'sessions#verify_mobile'
    delete 'logout', to: 'sessions#destroy'
    post 'signup', to: 'registrations#create'
    post 'forgot_password', to: 'passwords#create'
    put 'reset_password', to: 'passwords#update'
  end

  resources :bank_details
  
  resources :documents
end
