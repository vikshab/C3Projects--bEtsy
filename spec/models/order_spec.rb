require 'rails_helper'

RSpec.describe Order, type: :model do

  describe "set_order_status and update_subtotal actions before create and save respectavely" do
    order = Order.new
    subtotal = order.order_items.collect { |oi| oi.valid? ? (oi.quantity * oi.unit_price) : 0 }.sum
    order.save

    it "sets the order status to pending by default" do
      expect(order.status).to eq("pending")
      expect(order.subtotal).to eq(subtotal)
    end
  end
end
