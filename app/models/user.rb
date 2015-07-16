class User < ActiveRecord::Base
  before_save { self.email = email.downcase }
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  has_secure_password
  has_many :products
  has_many :order_items
end
