Rails.application.routes.draw do
  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
  root 'static_pages#home'
  get 'static_pages/help', as: "help"

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(new create)

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users do
    member do
      get :following, :followers
    end
  end
end
