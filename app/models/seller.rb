class Seller < ActiveRecord::Base
  has_secure_password
  has_many :products
  has_many :order_items, through: :products

end
