class OrderItem < ActiveRecord::Base
  belongs_to :order
  belongs_to :product
  belongs_to :user
  validates :quantity, presence: true, uniqueness: true, numericality: { only_integer: true, greater_than: 0 }
end
