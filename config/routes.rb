Rails.application.routes.draw do
  root "welcome#root"

  # viewing the checkout form
  get "/cart/checkout" => "orders#checkout"

  # changing the status from pending to paid
  post "/cart/checkout" => "orders#verify"

  # displaying the receipt
  get "/cart/receipt" => "orders#receipt", as: "receipt"

  # viewing the cart
  get "/cart" => "orders#cart"

  # adding an item to the cart
  post "/cart" => "cart/order_items#add", as: "add_item" # can also use cart_path

  # adjusting the quantity of an item in the cart
  patch "/cart/item/:id/more" => "cart/order_items#more", as: "more_item"
  patch "/cart/item/:id/less" => "cart/order_items#less", as: "less_item"

  # removing an item from the cart
  delete "/cart/item/:id" => "cart/order_items#destroy", as: "kill_item"
end
