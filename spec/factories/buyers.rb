FactoryGirl.define do
  factory :buyer do
    name "new buyer"
    email "buyer@email.com"
    address "address"
    zip 96108
    state "WA"
    city "Seattle"
    exp "exp"
    credit_card 12345678901234
  end
end
