require 'csv'

CSV.foreach("db/categories.csv", headers: true) do |row|

  Category.create(
    name: row[0]
  )
 end

CSV.foreach("db/products.csv", headers: true) do |row|

  Product.create(
    name: row[0],
    price: row[1],
    desc: row[2],
    stock: row[3],
    photo_url: row[4],
    user_id: row[5]
  )
 end

category_products = { 1 => 1, 1 => 2, 1 => 4, 1 => 5, 1 => 9, 1 => 12, 2 => 1, 2 => 3, 2 => 12, 3 => 7, 3 => 13, 3 => 14, 3 => 15, 3 => 16, 3 => 17, 3 => 18, 4 => 6, 4 => 7, 4 => 8, 4 => 10, 4 => 11, 4 => 15, 4 => 18, 4 => 14 }
# fix this to be a hash of key/value pairs

category_products.each do |k, v|
category = Category.find(k)
category.products << Product.find(v)
end
