Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  get "api/v1/items/find", to: "api/v1/items#find"
  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] #do
        #resources :items, only: [:index], controller: "merchants/items"
      #end
      resources :items, only: [:index, :show, :create, :update, :destroy] #do
        #resources :merchant, only: [:index], controller: "items/merchant"
      #end
    end
  end

  get '/api/v1/items/:id/merchant', to: 'api/v1/items/merchant#index'
  get '/api/v1/merchants/:id/items', to: 'api/v1/merchants/items#index'
end
