# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

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
