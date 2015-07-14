class OrderItem < ActiveRecord::Base
  belongs_to :order_id
  belongs_to :product_id
  belongs_to :user_id
end
