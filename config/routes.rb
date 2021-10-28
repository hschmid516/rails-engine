Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      # get 'merchants/find', to: 'merchants#find'
      # get 'items/find_all', to: 'items#find_all'
      get 'items/find', to: 'items/search#show'
      get 'merchants/find', to: 'merchants/search#show'
      get 'merchants/most_items', to: 'merchants#most_items'
      get 'revenue', to: 'revenue/merchants#date_range'
      namespace :merchants do
        resources :search, only: :index, path: :find_all
      end
      namespace :items do
        resources :search, only: :index, path: :find_all
      end
      namespace :revenue do
        resources :merchants, only: [:index, :show]
      end
      resources :items do
        get 'merchant', to: 'items_merchant#show'
      end
      resources :merchants, only: [:index, :show] do
        get 'items', to: 'merchant_items#index'
      end
    end
  end
end
