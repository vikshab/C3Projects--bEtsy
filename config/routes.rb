Rails.application.routes.draw do
  root "welcome#index"

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  get '/sellers/:id/dashboard', to: 'sellers#dashboard', as: "dashboard"

  resources :categories, only: [:index, :show, :new, :create]

  patch "/products/:id/retire", to: "products#retire", as: "retire_product"

  resources :sellers, only: [:index, :show, :new, :create] do
    get "products", to: "products#seller", as: "products"
    get "inventory", to: "products#inventory", as: "inventory" # OPTIMIZE: consider adding this content to the dashboard or seller products page?
    resources :products, only: [:new, :create]
    resources :orders, only: [:index, :show]

  end
  resources :products, except: [:new, :create, :destroy] do
    patch '/add_categories', to: 'products#add_categories', as: "add_categories"
  end

  get '/products/:id/reviews/new', to: 'reviews#new', as: "new_review"
  post '/products/:id/reviews/new', to: 'reviews#create'

  scope :cart do
    get "/", to: "orders#cart", as: "cart"
    get "/checkout", to: "orders#checkout", as: "checkout"
    patch "/checkout", to: "orders#update"
    get "/receipt", to: "orders#receipt", as: "receipt"
  end

  # adding an item to the cart
  post "/products/:id/add", to: "orders#add_to_cart", as: "add_item"

  # adjusting the quantity of an item in the cart
  patch "/cart/item/:id/more", to: "order_items#more", as: "more_item"
  patch "/cart/item/:id/less", to: "order_items#less", as: "less_item"

  # removing an item from the cart
  delete "/cart/item/:id", to: "order_items#destroy", as: "kill_item"

  resources :order_items, only: [:update]
end
