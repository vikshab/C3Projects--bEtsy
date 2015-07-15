require 'csv'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

CSV.foreach("db/products.csv", headers: true) do |row|

  Product.create(
    name: row[1],
    price: row[2],
    desc: row[3],
    stock: row[4],
    photo_url: row[5],
    category_id: row[6],
    user_id: row[7]
  )
 end
