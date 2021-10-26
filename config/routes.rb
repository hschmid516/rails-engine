Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      get 'merchants/find', to: 'merchants#find'
      get 'items/find_all', to: 'items#find_all'
      resources :items do
        get 'merchant', to: 'items_merchant#show'
      end
      namespace :revenue do
        resources :merchants, only: :index
      end
      resources :merchants, only: [:index, :show] do
        get 'items', to: 'merchant_items#index'
      end
    end
  end
end
