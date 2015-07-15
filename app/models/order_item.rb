class OrderItem < ActiveRecord::Base
  belongs_to :products
  belongs_to :orders
end
