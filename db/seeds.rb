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

category_products = { 1 => [1, 2, 4, 5, 9, 12], 2 => [1, 3, 12 ], 3 => [7, 13, 14, 15, 16, 17, 18], 4 => [6, 7, 8, 10, 11, 15, 18, 14] }
# fixed this to be a hash of key/value pairs

category_products.each do |k, v|
  category = Category.find(k)
  v.each do |p|
    category.products << Product.find(p)
  end
end
