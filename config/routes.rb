Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/revenue/merchants', to: 'revenue/merchants#ranked_by_revenue'
      get '/revenue/merchants/:id', to: 'revenue/merchants#total_revenue'
      get '/revenue/items', to: 'revenue/items#ranked_by_revenue'
      get '/merchants/most_items', to: 'merchants#merchant_most_items_sold'

      get '/merchants/find', to: 'merchants#find'
      get '/items/find_all', to: 'items#find_all'

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
