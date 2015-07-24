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
  seller = Seller.create(username: username, email: email, password: password, password_confirmation: password)
end

def rando_seller_id
  rand(1..Seller.count)
end

def rando_price
  return (rand * 25_000).to_i
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
    description: lorem_ipsum_description },
  {
    name: "Glass Display Case", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8810/16913195458_ea0f01f4bc_n.jpg",
    description: "Great glass display case suitable for showing off a bunch of junk you want to display!"
  },
  {
    name: "Extremely Large Flower", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8792/17358849611_12a343100f_n.jpg",
    description: "Suitable for use as an art piece. Recommended serving: with a side of baby carriage."
  },
  {
    name: "Sketchbook", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7691/17183018995_8077d2ff0a_n.jpg",
    description: "Good for watercolor and pen. " + lorem_ipsum_description
  },
  {
    name: "A Breath Of Fresh Air", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7415/9409479133_76c94e3c17_n.jpg",
    description: "Product may come in a tank. Product not guaranteed to be fresh. Product may not be air."
  },
  {
    name: "Martial Arts Lessons", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/4/3669/12071636106_1bdfccfe02_n.jpg",
    description: "Price per class hour per student. :) " + lorem_ipsum_description
  },
  {
    name: "Windows 95", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/4/3713/10625167306_6494b153b5_n.jpg",
    description: "Trees not included. " + lorem_ipsum_description
  },
  {
    name: "Totally Legit Ferris Wheel!", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7402/9355599294_3850cc787f_n.jpg",
    description: "Some assembly and parts required. " + lorem_ipsum_description
  },
  {
    name: "Spider Masterpiece", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/4/3765/9876909854_79cae50ef2_n.jpg",
    description: "Check outside your door, especially during the summer. " + lorem_ipsum_description
  },
  {
    name: "Tamarin", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7430/9347930402_c9d6942cb4_n.jpg",
    description: "What more do we need to say? This is a great deal! " + lorem_ipsum_description
  },
  {
    name: "Classic Rolling Umbrella Gun", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/533/19373446499_13dc23b655_n.jpg",
    description: "Vintage! " + lorem_ipsum_description
  },
  {
    name: "Lifelike Butterfly Model", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7487/15843003128_ceeb32c53c_n.jpg",
    description: "Passion Butterfly. " + lorem_ipsum_description
  },
  {
    name: "Devastating Optical Illusion", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7754/17248418448_2c40ac8f11_n.jpg",
    description: "Don't stare at it too long. " + lorem_ipsum_description
  },
  {
    name: "The Bluest Flower", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7513/15040739534_1dbb27f28b_n.jpg",
    description: "Italian Alkanet Anchusa azurea. Produces edible, brilliant-blue flowers from spring to fall."
  },
  {
    name: "Stickphast's Office Paste", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/6/5542/11307158676_46fbc8549d_n.jpg",
    description: "Image taken from page 284 of 'Monsieur At Home. (From notes made ... in France.)'"
  },
  {
    name: "Carrots", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8580/16793854021_2fbe4322e9_n.jpg",
    description: "Great source of Vitamin A! Good for night vision. " + lorem_ipsum_description
  },
  {
    name: "Another Spider Masterpiece", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7348/11139073614_cb39e5fed1_n.jpg",
    description: "From a very large spider who occasionally eats human young -- but only the winged ones."
  },
  {
    name: "Bicycle", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/3/2826/11300055394_516668bf5b_n.jpg",
    description: "Stick out your tongue at pedestrians as you zoom by. " + lorem_ipsum_description
  },
  {
    name: "Lego Convict", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/5/4124/5171519883_e3d15416a9_n.jpg",
    description: "Comes with two extra faces & a Lego Jail Cell kit. " + lorem_ipsum_description
  },
  {
    name: "Better Bicycle", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/3/2867/10761009376_4c06c3b3e3_n.jpg",
    description: "Seats two. " + lorem_ipsum_description
  },
  {
    name: "Deluxe Beach Chair", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/324/19172562542_dbbbd367ee_n.jpg",
    description: "No assembly required. Ships whole. " + lorem_ipsum_description
  },
  {
    name: "Portrait Lessons", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/524/19074818999_c67d25a5ea_n.jpg",
    description: "Learn how to take portraits of the finest vehicular people around."
  },
  {
    name: "Storm's a-Brewing", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7554/15972027988_f09692c52b_n.jpg",
    description: "5lb bag of coffee. Picture not related."
  },
  {
    name: "Fabric", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/4/3814/10958310435_6a0962eecd_n.jpg",
    description: "Tell us your favorite color. " + lorem_ipsum_description
  },
  {
    name: "Tie Dye Dress", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/3/2856/10515623584_a1a1371b85_n.jpg",
    description: lorem_ipsum_description
  },
  {
    name: "Theater Chairs", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/3/2856/10515623584_a1a1371b85_n.jpg",
    description: "We have a lot. Overstock special pricing! " + lorem_ipsum_description
  },
  {
    name: "Custom Door", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7558/15984529072_f178f30a07_n.jpg",
    description: "Normally retails for over $500! " + lorem_ipsum_description
  },
  {
    name: "Red Paint", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8646/16063952844_27d7f7bbdc_n.jpg",
    description: "Good for tables & walls. " + lorem_ipsum_description
  },
  {
    name: "Red Book", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8645/16246370380_b1bee00207_n.jpg",
    description: "Good for tables & walls. " + lorem_ipsum_description
  },
  {
    name: "Schrödinger's Cat", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7531/15986149702_a2e5c9ee8c_n.jpg",
    description: "We opened the box. " + lorem_ipsum_description
  },
  {
    name: "Cool Shoes", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/7/6106/6239465912_8fe97b7d4a_n.jpg",
    description: "I'm at the Pizza Hut. I'm at the Taco Bell. I'm at the Combination Shoes and Sunglasses."
  },
  {
    name: "Put a bird on it.", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/8/7188/6913369027_6377470920_n.jpg",
    description: "Watch out for the beak. " + lorem_ipsum_description
  },
  {
    name: "Protractor", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/7/6051/6235417834_4c42ef739c_n.jpg",
    description: "Good for measuring triangles like this. " + lorem_ipsum_description
  },
  {
    name: "Graffiti Lessons", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/7/6119/6222983964_5cf796d1fc_n.jpg",
    description: "Come this way if you want to live. " + lorem_ipsum_description
  },
  {
    name: "Apartment Building", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/420/18092271704_a2693009c9_n.jpg",
    description: "Only one broken window on the north side of the building! " + lorem_ipsum_description
  },
  {
    name: "Cement Bricks", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/439/19869955531_350b3bea50_n.jpg",
    description: "Price per cubic meter."
  },
  {
    name: "Different Blue Shirt", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/4/3758/11015593463_356fb08414_n.jpg",
    description: lorem_ipsum_description
  },
  {
    name: "Rapid Onset Destructive Climate Change", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8716/16799622787_729282630a_n.jpg",
    description: "Does what it says on the tin. " + lorem_ipsum_description
  },
  {
    name: "Velodrome Flower Pot Holder", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/378/19085942430_3228ce689a_n.jpg",
    description: "So relaxing you'll have to take a nap every time you see it."
  },
  {
    name: "Duckling", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/6/5446/8927994868_1434fc6506_n.jpg",
    description: "So soft. " + lorem_ipsum_description
  },
  {
    name: "Canon 40mm Lens", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/9/8892/17319765834_5debfd038c_n.jpg",
    description: lorem_ipsum_description
  },
  {
    name: "Golden Sphere", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c2.staticflickr.com/6/5470/17578533596_3cc0f5258d_n.jpg",
    description: "Not the one from the movie. Does not have ability to manifest your subconsious thoughts."
  },
  {
    name: "Tattoo", price: rando_price, seller_id: rando_seller_id, stock: rando_price/100,
    photo_url: "https://c1.staticflickr.com/1/290/19051370620_2ab88e4382_n.jpg",
    description: "Aperture Science? We do what we must because we can. " + lorem_ipsum_description
  }
]

def rando_rating
  return rand(1..5)
end

def review_text(rating, product)
  ones = ["Poor quality.", "Not as many bees as I expected.", "Broke when I tried to feed it to my kid.", "Hated it."]
  twos = ["Meh.", "Didn't taste like described.", "Not sharp enough.", "#{ product.name } was slightly damaged."]
  threes = ["Pretty okay!", "#{ product.name } could have been worse.", "Good for the price but not great."]
  fours = ["The best thing since sliced bread!", "Slight defect in the packaging but otherwise amazing.", "Loved it."]
  fives = ["EXCELLENT!", "Would buy #{ product.name } again!", "My #{ product.name } came with a free quarter inside!"]

  return ones.sample if rating == 1
  return twos.sample if rating == 2
  return threes.sample if rating == 3
  return fours.sample if rating == 4
  return fives.sample if rating == 5
end

products.each do |product|
  product = Product.create(product)

  rando_rating.times do
    current_rating = rando_rating
    Review.create({ rating: current_rating, description: review_text(current_rating, product), product_id: product.id })
  end
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

product_limit = Product.count

20.times do
  current_name = buyer_names.sample
  order = Order.create(status: "paid", buyer_name: current_name,
    buyer_email: current_name.split(" ").sample + "@email.net",
    buyer_address: "1234 fake st", buyer_card_short: "4567",
    buyer_card_expiration: Date.parse("June 5 2086"))

  10.times do
    OrderItem.create(product_id: rand(1..product_limit),
      order_id: order.id, quantity_ordered: 2, status: "paid")
  end
end

Product.all.each do |product|
  product.categories << Category.all.sample(rand(0..4))
end

reviews = [
  { rating: 3, description: "Praesent sed sem faucibus, aliquet tellus eu, lacinia lorem. Ut est ex, vestibulum vel est vitae, pulvinar rhoncus lorem. Praesent finibus diam id iaculis egestas. Aliquam non posuere purus. Donec eu orci diam. Nulla lobortis metus augue, nec faucibus lacus finibus ut.", product_id: 3},
  { rating: 5, description: "Very cute :)", product_id: 1},
  { rating: 2, description: "Does not block the sun", product_id: 5}
]

reviews.each do |review|
  Review.create(review)
end
