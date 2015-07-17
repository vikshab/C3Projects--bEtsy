Rails.application.routes.draw do
  root "welcome#index"

  resources :categories, except: :destroy
  resources :sellers, only: [:index, :show]
  resources :products, only: [:index, :show]

  get '/products/:id/reviews/new', to: 'reviews#new', as: "new_review"
  post '/products/:id/reviews/new', to: 'reviews#create'

  scope :cart do
    get "/", to: "orders#cart", as: "cart"
    get "checkout", to: "orders#checkout"
    patch "checkout", to: "orders#update"
    get "receipt", to: "orders#receipt"
  end

  # adding an item to the cart
  post "/products/:id/add", to: "products#add_to_cart", as: "add_item"

  # adjusting the quantity of an item in the cart
  patch "/cart/item/:id/more" => "order_items#more", as: "more_item"
  patch "/cart/item/:id/less" => "order_items#less", as: "less_item"

  # removing an item from the cart
  delete "/cart/item/:id" => "order_items#destroy", as: "kill_item"
end
