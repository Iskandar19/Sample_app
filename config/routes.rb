Rails.application.routes.draw do
  resources :users
  resources :account_activations, only: :edit
  root 'static_pages#home'
  get 'static_pages/help'

  get "/signup", to: "users#new"
  post "/signup", to: "users#create"
  resources :users, only: %i(new create)

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
end
