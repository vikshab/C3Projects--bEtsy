require 'rails_helper'

RSpec.describe OrderItem, type: :model do

  describe "model validation" do
    it "requires an integer quantity, product and order" do
      orderitem = OrderItem.new(quantity: 23, product_id: 1, order_id: 1)

      expect(orderitem).to be_valid
    end

    it "requires a product id" do
      orderitem = OrderItem.new(quantity: 5, order_id: 1)

      expect(orderitem).to_not be_valid
      expect(orderitem.errors.keys).to include(:product_id)
    end

    it "requires an order id" do
      orderitem = OrderItem.new(quantity: 5, product_id: 2)

      expect(orderitem).to_not be_valid
      expect(orderitem.errors.keys).to include(:order_id)
    end

    it "requires a quantity" do
      orderitem = OrderItem.new(product_id: 1, order_id: 1)

      expect(orderitem).to_not be_valid
      expect(orderitem.errors.keys).to include(:quantity)
    end

    it "must be an integer quantity" do
      orderitem = OrderItem.new(quantity: "lots")

      expect(orderitem).to_not be_valid
      expect(orderitem.errors.keys).to include(:quantity)
    end

    it "must be an integer greater than 0" do
      orderitem = OrderItem.new(quantity: -2)

      expect(orderitem).to_not be_valid
      expect(orderitem.errors.keys).to include(:quantity)
    end

  end
end
