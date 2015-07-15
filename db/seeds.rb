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
