Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get '/merchants/find', to: 'merchants#find'
      get '/items/find_all', to: 'items#find_all'
      resources :merchants, only: [:index, :show]
      resources :merchants, only: [:show] do
        resources :items, only: [:index]
      end
      resources :items do
        get '/merchant', controller: :items, action: :show
      end
    end
  end
end
