Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # resources :managers
  
  # get '/displayleaves', to: 'leaves#display_leaves'
  
  devise_for :users
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :users
  scope module: :products do
    resources :products

    # Cart
    post   "/cart/add",    to: "cart#add"
    post   "/cart/remove", to: "cart#remove"
    get    "/cart/show",   to: "cart#show"
    delete "/cart/clear",  to: "cart#clear"

    # Orders
    post "/orders/place_order", to: "orders#place_order"
    post  "/orders/buy_now", to: "orders#buy_now"
    get  "/orders/user_orders", to: "orders#user_orders"
  end

  # Orders
  post "/orders/place",        to: "orders#place"
  get  "/orders/user_orders",  to: "orders#user_orders"
  
  namespace :api do
    post 'login', to: 'sessions#create'
    post 'verify_email', to: 'sessions#verify_email'
    post 'verify_mobile', to: 'sessions#verify_mobile'
    post 'login_with_email', to: 'sessions#login_with_email'
    post 'login_with_mobile', to: 'sessions#login_with_mobile'
    delete 'logout', to: 'sessions#destroy'
    post 'signup', to: 'registrations#create'
    post 'forgot_password', to: 'passwords#create'
    put 'reset_password', to: 'passwords#update'
  end
end
