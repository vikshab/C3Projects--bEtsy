Rails.application.routes.draw do
  root "welcome#root"

  # adding an item to the cart
  post "/cart" => "cart/order_items#add"

  # viewing the cart
  get "/cart" => "orders#cart"

  # viewing the checkout form
  get "/cart/checkout" => "orders#checkout"

  # changing the status from pending to paid
  post "/cart/checkout" => "orders#verify"

  # displaying the receipt
  get "/cart/receipt" => "orders#receipt"

  delete "/cart/item/:id" => "cart/order_items#destroy", as: "kill_item"
  patch "/cart/item/:id/more" => "cart/order_items#more", as: "more_item"
  patch "/cart/item/:id/less" => "cart/order_items#less", as: "less_item"

  # namespace :cart do
  #   resources :order_items, only: [:create, :update, :destroy], as: "item", path: "item" do # actually neither does this
  #     member do
  #       patch :more # ;_; doesn't work as expected
  #       patch :less
  #     end
  #   end
  # end
end
