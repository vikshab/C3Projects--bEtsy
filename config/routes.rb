Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # home page with top items
  root 'home#index'

  # products-- no new (done through the merchant page), no destroy (retire instead)
  ## do we need all the reviews routes?

  resources :products, except: [:new, :destroy] do
    resources :reviews
  end

  # custom product paths - by merchant, category, and to retire a product
  patch 'products/retire/:id' => 'products#retire', as: "retire"
  get "/categories/:category_name" => "categories#show", as: "category"
  get "/merchant/:id/products", to: "products#merchant_products", as: "merchant_products"

  # users/merchants path makes the url path display as merchants instead of users
  resources :users, path: "merchants", only: [:new, :create, :show] do
    resources :products, only: [:new]
    resources :orders, only: [:index, :show]
  end

  ## check to see if using all after more of the orders things are fleshed out
  resources :orders

  # RoR paths
  resources :order_items, only: [:create, :update, :destroy]

  # sessions paths
  get    "/login", to: "sessions#new"
  post   "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"


end
