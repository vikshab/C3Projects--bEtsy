# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
products = [
  { name: "puppies", price: "300", seller_id: "2", stock: "3" },
  { name: "hats", price: "2000", seller_id: "4", stock: "7" },
  { name: "shoes", price: "3400", seller_id: "2", stock: "10" },
  { name: "books", price: "600", seller_id: "7", stock: "2" },
  { name: "sunglasses", price: "10000", seller_id: "1", stock: "9" },
  { name: "coffee", price: "1000", seller_id: "6", stock: "4" },
  { name: "t-shirts", price: "1300", seller_id: "9", stock: "15" },
  { name: "rings", price: "4000", seller_id: "8", stock: "34" },
  { name: "watches", price: "1600", seller_id: "3", stock: "7" },
  { name: "markers", price: "25", seller_id: "10", stock: "13" },
  { name: "sunscreen", price: "400", seller_id: "5", stock: "45" }
]

products.each do |product|
  Product.create(product)
end
