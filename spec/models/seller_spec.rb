require 'rails_helper'

RSpec.describe Seller, type: :model do
  describe "database relationships" do
    before :each do
      @seller = Seller.new(username: "bob", email: "bob@bob.bob")
      @seller.password = @seller.password_confirmation = "bobspassword"
      @seller.save

      Product.create(name: "a", price: 1, stock: 10, seller_id: @seller.id)
      Product.create(name: "b", price: 1, stock: 10, seller_id: @seller.id)
      Product.create(name: "c", price: 1, stock: 10, seller_id: @seller.id)
      Product.create(name: "d", price: 1, stock: 10, seller_id: @seller.id)

      @order1 = Order.create
      @order2 = Order.create

      OrderItem.create(order_id: @order1.id, product_id: 1, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 1, quantity_ordered: 1)
      OrderItem.create(order_id: @order1.id, product_id: 2, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 2, quantity_ordered: 1)
      OrderItem.create(order_id: @order1.id, product_id: 3, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 3, quantity_ordered: 1)
      OrderItem.create(order_id: @order1.id, product_id: 4, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 4, quantity_ordered: 1)
    end

    it "has many products" do
      expect(@seller.products.count).to eq(4)
    end

    it "has many order_items through products" do
      expect(@seller.order_items.count).to eq(8)
    end

    it "has many orders through order_items" do
      expect(@seller.orders.count).to eq(2)
    end

    it "and those orders are unique" do
      expect(@seller.orders.count).to_not eq(8)
    end
  end

  describe "model validations" do
    let(:seller_w_o_username) { Seller.new(email: "email") }
    let(:seller_w_o_email) { Seller.new(username: "name") }
    let(:seller_w_o_password) { Seller.new(username: "name", email: "email") }

    it "doesn't save a seller without a name" do
      seller_w_o_username.password = "hi"
      seller_w_o_username.password_confirmation = "hi"

      expect(seller_w_o_username).to_not be_valid
      expect(seller_w_o_username.errors.keys).to include(:username)
    end

    it "doesn't save a seller without an email" do
      seller_w_o_email.password = "hi"
      seller_w_o_email.password_confirmation = "hi"

      expect(seller_w_o_email).to_not be_valid
      expect(seller_w_o_email.errors.keys).to include(:email)
    end

    it "doesn't save a seller without a password" do
      expect(seller_w_o_password).to_not be_valid
      expect(seller_w_o_password.errors.keys).to include(:password)
    end
  end

  describe "intsance methods" do
    before :each do
      @seller = Seller.new(username: "bob", email: "bob@bob.bob")
      @seller.password = @seller.password_confirmation = "bobspassword"
      @seller.save

      Product.create(name: "a", price: 1, stock: 10, seller_id: @seller.id)
      Product.create(name: "b", price: 1, stock: 10, seller_id: @seller.id)
      Product.create(name: "c", price: 1, stock: 10, seller_id: @seller.id)
      Product.create(name: "d", price: 1, stock: 10, seller_id: @seller.id)

      @order1 = Order.create
      @order2 = Order.create

      OrderItem.create(order_id: @order1.id, product_id: 1, quantity_ordered: 1)
      OrderItem.create(order_id: @order1.id, product_id: 2, quantity_ordered: 1)
      OrderItem.create(order_id: @order1.id, product_id: 3, quantity_ordered: 1)
      OrderItem.create(order_id: @order1.id, product_id: 4, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 1, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 2, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 3, quantity_ordered: 1)
      OrderItem.create(order_id: @order2.id, product_id: 4, quantity_ordered: 2)

      @order2.update(status: "complete", buyer_name: "cthulhu",
        buyer_email: "cthulhu@rlyeh.net", buyer_address: "1234 fake st",
        buyer_card_short: "4567", buyer_card_expiration: Date.parse("June 5 2086"))
      @order2.order_items.each do |item|
        item.update(status: "shipped")
      end
    end

    context "#total_revenue" do
      it "returns the total revenue based on order items & price" do
        expect(@seller.total_revenue).to eq(9)
      end
    end

    context "#revenue" do
      it "returns the total revenue only for whichever status is passed in" do
        expect(@seller.revenue("shipped")).to eq(5)
      end
    end

    context "#count_orders" do
      it "counts up how many order items exist for whichever status is passed in" do
        expect(@seller.count_orders("pending")).to eq(4)
      end
    end

    context "#fetch_orders" do
      it "fetches the orders with statuses that match the passed in status" do
        expect(@seller.fetch_orders("pending")).to include(@order1)
        expect(@seller.fetch_orders("pending")).not_to include(@order2)
      end

      it "or fetches all of them when no status is passed in" do
        expect(@seller.fetch_orders).to include(@order1)
        expect(@seller.fetch_orders).to include(@order2)
      end
    end
  end
end
