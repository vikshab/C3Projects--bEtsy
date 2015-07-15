# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

order_statuses = ["pending", "paid", "completed", "cancelled"]
buyer_names = [
  "Johnathan NoLastName", "Satan McHandsomeDevil", "Dr. Potato Head",
  "Ada Lovelace", "Betty McAwesomePants", "Tallis GenericLastName", "Tux"
]

50.times do
  current_status = order_statuses.sample

  if current_status == "pending"
    Order.create(status: current_status)
  else
    current_name = buyer_names.sample

    Order.create(
      status: current_status,
      buyer_name: buyer_names.sample,
      buyer_email: current_name.split(" ").sample + "@email.net",
      buyer_address: "1234 fake st",
      buyer_card_short: "4567",
      buyer_card_expiration: Date.parse("June 5 2016")
    )
  end
end
