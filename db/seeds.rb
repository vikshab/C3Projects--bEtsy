require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CSV.foreach("db/categories.csv", headers: true) do |row|

  Category.create(
    name: row[0]
  )
 end

 CSV.foreach("db/users.csv", headers: true) do |row|

   User.create(
     name: row[0],
     email: row[1]
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
