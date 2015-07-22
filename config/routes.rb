Rails.application.routes.draw do
  root "welcome#index"

  get "/login", to: "sessions#new", as: "login"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy", as: "logout"

  resources :categories, except: :destroy
  resources :sellers, only: [:index, :show, :new, :create] do
    resources :products, only: [:new, :create]
  end
  resources :products, except: [:new, :create, :destroy]

  get '/products/:id/reviews/new', to: 'reviews#new', as: "new_review"
  post '/products/:id/reviews/new', to: 'reviews#create'


  scope :cart do
    get "/", to: "orders#cart", as: "cart"
    get "checkout", to: "orders#checkout"
    patch "checkout", to: "orders#update"
    get "receipt", to: "orders#receipt"
  end

  # adding an item to the cart
  post "/products/:id/add", to: "orders#add_to_cart", as: "add_item"

  # adjusting the quantity of an item in the cart
  patch "/cart/item/:id/more" => "order_items#more", as: "more_item"
  patch "/cart/item/:id/less" => "order_items#less", as: "less_item"

  # removing an item from the cart
  delete "/cart/item/:id" => "order_items#destroy", as: "kill_item"
end
