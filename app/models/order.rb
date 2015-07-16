class Order < ActiveRecord::Base
  has_many :order_items

  def total_price
    array_of_totals = order_items.map { |item| item.quantity_ordered * item.product.price }
    total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
  end
end
