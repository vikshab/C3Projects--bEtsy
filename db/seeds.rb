sellers = [
  ["user1",  "email1@email.com",  "password1"],
  ["user2",  "email2@email.com",  "password2"],
  ["user3",  "email3@email.com",  "password3"],
  ["user4",  "email4@email.com",  "password4"],
  ["user5",  "email5@email.com",  "password5"],
  ["user6",  "email6@email.com",  "password6"],
  ["user7",  "email7@email.com",  "password7"],
  ["user8",  "email8@email.com",  "password8"],
  ["user9",  "email9@email.com",  "password9"],
  ["user10", "email10@email.com", "password10"]
]

sellers.each do |username, email, password|
  seller = Seller.new(username: username, email: email)
  seller.password = password
  seller.password_confirmation = password
  seller.save
end

products = [
  { name: "Puppy", price: 300, seller_id: 2, stock: 3 },
  { name: "Hat", price: 2000, seller_id: 4, stock: 7 },
  { name: "Shoes", price: 3400, seller_id: 2, stock: 10 },
  { name: "Book", price: 600, seller_id: 7, stock: 2 },
  { name: "Sunglasses", price: 10000, seller_id: 1, stock: 9 },
  { name: "Coffee", price: 1000, seller_id: 6, stock: 4 },
  { name: "T-shirt", price: 1300, seller_id: 9, stock: 15 },
  { name: "Ring", price: 4000, seller_id: 8, stock: 34 },
  { name: "Watch", price: 1600, seller_id: 3, stock: 7 },
  { name: "Markers", price: 25, seller_id: 10, stock: 13 },
  { name: "Sunscreen", price: 400, seller_id: 5, stock: 45 }
]

products.each do |product|
  Product.create(product)
end

categories = [
  { name: "Grocery" },
  { name: "Animals" },
  { name: "Home and Garden" },
  { name: "Toys" },
  { name: "Clothing" },
  { name: "Health and Beauty" },
  { name: "Sports and Outdoors" },
  { name: "Automotive" },
  { name: "Books" },
  { name: "Movies" },
  { name: "Electronic" }
]

categories.each do |category|
  Category.create(category)
end

# order_statuses = ["pending", "paid", "completed", "cancelled"]
# buyer_names = [
#   "Johnathan NoLastName", "Satan McHandsomeDevil", "Dr. Potato Head",
#   "Ada Lovelace", "Betty McAwesomePants", "Tallis GenericLastName", "Tux"
# ]
#
# Order.create
# Product.create(name: "astronaut", price: 15_000, seller_id: 1, stock: 50)
#
# 5.times do
#   current_status = order_statuses.sample
#
#   if current_status == "pending"
#     Order.create(status: current_status)
#   else
#     current_name = buyer_names.sample
#
#     Order.create(
#       status: current_status,
#       buyer_name: buyer_names.sample,
#       buyer_email: current_name.split(" ").sample + "@email.net",
#       buyer_address: "1234 fake st",
#       buyer_card_short: "4567",
#       buyer_card_expiration: Date.parse("June 5 2016")
#     )
#   end
# end

all_categories = Category.all
all_products = Product.all

all_products.each do |product|
  product.categories << all_categories.sample(rand(0..4))
end


# product_limit = Product.all.count
#
# 20.times do
#   OrderItem.create(
#     product_id: (1..product_limit).to_a.sample,
#     order_id: (1..20).to_a.sample,
#     quantity_ordered: (1..5).to_a.sample
#   )
# end

reviews = [
  { rating: 3, description: "Comfortable", product_id: 3},
  { rating: 5, description: "Very cute :)", product_id: 1},
  { rating: 2, description: "Does not block the sun", product_id: 5}
]

reviews.each do |review|
  Review.create(review)
end
