Rails.application.routes.draw do
  root "welcome#root"

  # adding an item to the cart
  post "/cart" => "orders#add"

  # viewing the cart
  get "/cart" => "orders#cart"

  # viewing the checkout form
  get "/cart/checkout" => "orders#checkout"

  # changing the status from pending to paid
  post "/cart/checkout" => "orders#verify"

  # displaying the receipt
  get "/cart/receipt" => "orders#receipt"
end
