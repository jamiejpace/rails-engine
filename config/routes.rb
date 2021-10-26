Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/revenue/merchants', to: 'revenue/merchants#index'
      get '/revenue/merchants/:id', to: 'revenue/merchants#show'
      get '/merchants/find', to: 'merchants#find'
      get '/items/find_all', to: 'items#find_all'
      get '/merchants/most_items', to: 'merchants#merchant_most_items_sold'

      resources :merchants, only: [:index, :show]

      resources :merchants, only: [:show] do
        resources :items, only: [:index]
      end

      resources :items do
        get '/merchant', to: "items/merchant#show"
      end
    end
  end
end
