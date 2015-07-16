class Seller < ActiveRecord::Base
  # Validations ----------------------
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  # Associations ----------------------
  has_secure_password
  has_many :products
  has_many :order_items, through: :products
end
