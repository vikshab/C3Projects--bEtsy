require 'csv'

CSV.foreach("db/categories.csv", headers: true) do |row|

  Category.create(
    name: row[0]
  )
 end

 CSV.foreach("db/users.csv", headers: true) do |row|

   User.create(
     name: row[0],
     email: row[1],
     password: row[2],
     password_confirmation: row[3]
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

 CSV.foreach("db/reviews.csv", headers: true) do |row|

   Review.create(
     body: row[0],
     rating: row[1],
     product_id: row[2]
   )
  end

category_products = { 1 => [1, 2, 4, 5, 9, 12, 19, 21, 25, 27, 29, 34, 35], 2 => [1, 3, 12, 19, 24, 29, 33, 34, 35], 3 => [7, 13, 14, 15, 16, 17, 18], 4 => [6, 7, 8, 10, 11, 15, 18, 14, 19, 29, 34, 35], 5 => [20, 21, 22, 23, 24, 25, 26, 27, 28, 30, 31, 32]}

category_products.each do |k, v|
  category = Category.find(k)
  v.each do |p|
    category.products << Product.find(p)
  end
end
