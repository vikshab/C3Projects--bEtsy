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

lorem_ipsum_description = <<END
Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus id ex massa.
Nam ornare sagittis efficitur. Aenean leo lectus, bibendum quis eleifend ut,
sodales eget justo. Quisque scelerisque in nisl eu ultricies. Morbi in tortor
nibh. Curabitur quis tristique metus. Pellentesque commodo, eros vitae auctor
pellentesque, leo est laoreet est, sit amet sodales diam mi eu nulla. Etiam at
tempor nibh. Nullam consequat vel ex sed euismod. In id suscipit turpis, eu
condimentum diam. Mauris neque ex, elementum ac velit a, suscipit tempus eros.
Suspendisse augue odio, tincidunt ac lobortis eu, sodales sed dolor. Proin
condimentum risus diam, sed laoreet sem iaculis sit amet.

Praesent sed sem faucibus, aliquet tellus eu, lacinia lorem. Ut est ex,
vestibulum vel est vitae, pulvinar rhoncus lorem. Praesent finibus diam id
iaculis egestas. Aliquam non posuere purus. Donec eu orci diam. Nulla lobortis
metus augue, nec faucibus lacus finibus ut. Vivamus non massa eleifend,
facilisis felis eget, blandit neque. Curabitur non justo suscipit, suscipit erat
ut, pharetra nulla. Nulla dapibus sed elit blandit interdum.
END

products = [
  { name: "Puppy", price: 300, seller_id: 2, stock: 3,
    photo_url: "http://upload.wikimedia.org/wikipedia/commons/9/9c/Tibetan_Terrier_Puppy.jpg",
    description: lorem_ipsum_description },
  { name: "Hat", price: 2000, seller_id: 4, stock: 7,
    photo_url: "https://c1.staticflickr.com/3/2778/4364279708_c5eee8c341.jpg",
    description: lorem_ipsum_description },
  { name: "Shoes", price: 3400, seller_id: 2, stock: 10,
    photo_url: "https://c2.staticflickr.com/6/5538/9642545922_0755b4efaf.jpg",
    description: lorem_ipsum_description },
  { name: "Book", price: 600, seller_id: 7, stock: 2,
    photo_url: "https://c1.staticflickr.com/9/8339/8201700717_0209fcac39_b.jpg",
    description: lorem_ipsum_description },
  { name: "Sunglasses", price: 10000, seller_id: 1, stock: 9,
    photo_url: "https://farm4.staticflickr.com/3429/5758809338_c8d524870d_o_d.jpg",
    description: lorem_ipsum_description },
  { name: "Coffee", price: 1000, seller_id: 6, stock: 4,
    photo_url: "http://www.texample.net/media/tikz/examples/PNG/coffee-cup.png",
    description: lorem_ipsum_description },
  { name: "T-shirt", price: 1300, seller_id: 9, stock: 15,
    photo_url: "https://upload.wikimedia.org/wikipedia/commons/2/24/Blue_Tshirt.jpg",
    description: lorem_ipsum_description },
  { name: "Ring", price: 4000, seller_id: 8, stock: 34,
    photo_url: "https://farm8.staticflickr.com/7242/7162009815_0e0f462ba8_o_d.jpg",
    description: lorem_ipsum_description },
  { name: "Watch", price: 1600, seller_id: 3, stock: 7,
    photo_url: "https://farm4.staticflickr.com/3251/3008469318_2b4844975f_o_d.gif",
    description: lorem_ipsum_description },
  { name: "Markers", price: 25, seller_id: 10, stock: 13,
    photo_url: "https://farm3.staticflickr.com/2749/4355765412_d1bf39be7f_o_d.jpg",
    description: lorem_ipsum_description },
  { name: "Sunscreen", price: 400, seller_id: 5, stock: 45,
    photo_url: "https://farm8.staticflickr.com/7135/7504697726_cc4c931dc7_o.jpg",
    description: lorem_ipsum_description }
]

products.each do |product|
  product = Product.create(product)
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

buyer_names = [
  "Johnathan NoLastName", "Satan McHandsomeDevil", "Dr. Potato Head",
  "Ada Lovelace", "Betty McAwesomePants", "Tallis GenericLastName", "Tux"
]

product_limit = Product.all.count

20.times do
  current_name = buyer_names.sample
  order = Order.create(status: "paid", buyer_name: current_name,
    buyer_email: current_name.split(" ").sample + "@email.net",
    buyer_address: "1234 fake st", buyer_card_short: "4567",
    buyer_card_expiration: Date.parse("June 5 2086"))

  10.times do
    OrderItem.create(product_id: (1..product_limit).to_a.sample,
      order_id: order.id, quantity_ordered: 2)
  end
end

all_categories = Category.all
all_products = Product.all

all_products.each do |product|
  product.categories << all_categories.sample(rand(0..4))
end

reviews = [
  { rating: 3, description: "Praesent sed sem faucibus, aliquet tellus eu, lacinia lorem. Ut est ex, vestibulum vel est vitae, pulvinar rhoncus lorem. Praesent finibus diam id iaculis egestas. Aliquam non posuere purus. Donec eu orci diam. Nulla lobortis metus augue, nec faucibus lacus finibus ut.", product_id: 3},
  { rating: 5, description: "Very cute :)", product_id: 1},
  { rating: 2, description: "Does not block the sun", product_id: 5}
]

reviews.each do |review|
  Review.create(review)
end
