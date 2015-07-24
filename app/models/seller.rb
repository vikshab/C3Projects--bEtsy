class Seller < ActiveRecord::Base
  has_secure_password
  has_many :products
  has_many :order_items, through: :products
  has_many :orders, -> { uniq }, through: :order_items

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
end
