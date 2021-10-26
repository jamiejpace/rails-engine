Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/items/find_all', to: 'items#find_all'
      get '/merchants/most_items', to: 'merchants#most_items'
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
