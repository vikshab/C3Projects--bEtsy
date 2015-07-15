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
    category_id: row[5],
    user_id: row[6]
  )
 end
