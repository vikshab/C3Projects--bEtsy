require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "database relationships" do
    before :each do
      @order = Order.create

      product1 = Product.create(name: "asdkhjadsf", seller_id: 1, stock: 1, price: 1)
      OrderItem.create(order_id: @order.id, product_id: product1.id, quantity_ordered: 1)

      product2 = Product.create(name: "3948jmow3f43ou9kv", seller_id: 1, stock: 1, price: 1)
      OrderItem.create(order_id: @order.id, product_id: product2.id, quantity_ordered: 1)
    end

    it "has order items" do
      expect(@order.order_items.count).to eq(2)
    end

    it "has_many :products, through: :order_items" do
      expect(@order.products.count).to eq(2)
    end
  end

  describe "model validations" do
    context "requires a status" do
      it "has a default value: 'pending'" do
        order = Order.create
        expect(order.status).to eq("pending")
      end

      it "has only a few valid statuses" do
        valid_statuses = ["pending", "paid", "complete", "canceled"]
        invalid_statuses = ["", "shipped", "PAID", "cancelled", "done", "returned"]

        valid_statuses.each do |status|
          order = Order.create(status: status)
          expect(order.errors.keys).to_not include(:status)
        end

        invalid_statuses.each do |status|
          order = Order.create(status: status)
          expect(order.errors.keys).to include(:status)
        end
      end
    end

    context "buyer_info" do
      it "does not require any buyer info for pending orders" do
        order = Order.create

        buyer_fields = [:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration]

        buyer_fields.each do |field|
          expect(order.errors.keys).to_not include(field)
        end
      end

      context "buyer info is required on all non-pending orders" do
        before :each do
          @order1 = Order.create(status: "paid")
          @order2 = Order.create(status: "complete")
          @order3 = Order.create(status: "canceled")
        end

        it "requires buyer email address" do
          expect(@order1.errors.keys).to include(:buyer_email)
          expect(@order2.errors.keys).to include(:buyer_email)
          expect(@order3.errors.keys).to include(:buyer_email)

          @order1 = Order.create(status: "paid", buyer_email: "bob@bob.bob")
          @order2 = Order.create(status: "complete", buyer_email: "bob@bob.bob")
          @order3 = Order.create(status: "canceled", buyer_email: "bob@bob.bob")

          expect(@order1.errors.keys).to_not include(:buyer_email)
          expect(@order2.errors.keys).to_not include(:buyer_email)
          expect(@order3.errors.keys).to_not include(:buyer_email)
        end

        it "requires buyer name" do
          expect(@order1.errors.keys).to include(:buyer_name)
          expect(@order2.errors.keys).to include(:buyer_name)
          expect(@order3.errors.keys).to include(:buyer_name)

          @order1 = Order.create(status: "paid", buyer_name: "bob bobson")
          @order2 = Order.create(status: "complete", buyer_name: "bob bobson")
          @order3 = Order.create(status: "canceled", buyer_name: "bob bobson")

          expect(@order1.errors.keys).to_not include(:buyer_name)
          expect(@order2.errors.keys).to_not include(:buyer_name)
          expect(@order3.errors.keys).to_not include(:buyer_name)
        end

        it "requires buyer address" do
          expect(@order1.errors.keys).to include(:buyer_address)
          expect(@order2.errors.keys).to include(:buyer_address)
          expect(@order3.errors.keys).to include(:buyer_address)

          @order1 = Order.create(status: "paid", buyer_address: "1234 fake st")
          @order2 = Order.create(status: "complete", buyer_address: "1234 fake st")
          @order3 = Order.create(status: "canceled", buyer_address: "1234 fake st")

          expect(@order1.errors.keys).to_not include(:buyer_address)
          expect(@order2.errors.keys).to_not include(:buyer_address)
          expect(@order3.errors.keys).to_not include(:buyer_address)
        end

        it "requires buyer card short" do
          expect(@order1.errors.keys).to include(:buyer_card_short)
          expect(@order2.errors.keys).to include(:buyer_card_short)
          expect(@order3.errors.keys).to include(:buyer_card_short)

          @order1 = Order.create(status: "paid", buyer_card_short: "1234")
          @order2 = Order.create(status: "complete", buyer_card_short: "1234")
          @order3 = Order.create(status: "canceled", buyer_card_short: "1234")

          expect(@order1.errors.keys).to_not include(:buyer_card_short)
          expect(@order2.errors.keys).to_not include(:buyer_card_short)
          expect(@order3.errors.keys).to_not include(:buyer_card_short)
        end

        it "requires buyer card expiration" do
          expect(@order1.errors.keys).to include(:buyer_card_expiration)
          expect(@order2.errors.keys).to include(:buyer_card_expiration)
          expect(@order3.errors.keys).to include(:buyer_card_expiration)

          @order1 = Order.create(status: "paid", buyer_card_expiration: "6/2016")
          @order2 = Order.create(status: "complete", buyer_card_expiration: "6/2016")
          @order3 = Order.create(status: "canceled", buyer_card_expiration: "6/2016")

          expect(@order1.errors.keys).to_not include(:buyer_card_expiration)
          expect(@order2.errors.keys).to_not include(:buyer_card_expiration)
          expect(@order3.errors.keys).to_not include(:buyer_card_expiration)
        end
      end

      it "requires an email with a valid format" do
        valid_emails = ["bob@bob.bob.bob", "12345@bob.bob", "bob@bob.bob",
          "....@bob.bob", "1......2....3......4............5@bob.bob",
          "bob.bob@bob.bob", "bob-bob@bob.bob", "bob@bob-bob.bob"]

        valid_emails.each do |email|
          order = Order.create(status: "paid", buyer_email: email)
          expect(order.errors.keys).to_not include(:buyer_email)
        end

        invalid_emails = ["bob@@bob.bob", "bob@bob..bob", "bob@bob", "bob.bob",
          "bob", "@bob", "bob@12345", "bob@手紙.bob", "bob@bob.手紙", "",
          "bob bobson@bob.bob", "bob@bob bobson.bob", "bob-bob@bob-bob@bob.bob",
          "    bob@bob.bob", " bob@bob.bob", "bob@bob.bob "]

        invalid_emails.each do |email|
          order = Order.create(status: "paid", buyer_email: email)
          expect(order.errors.keys).to include(:buyer_email)
        end
      end

      it "buyer_card_short must be 4 digits" do
        valid_cards = ["1234", "8000", 5_000, 8_210, "0001", "0000", "0999"]

        valid_cards.each do |card|
          order = Order.create(status: "paid", buyer_card_short: card)
          expect(order.errors.keys).to_not include(:buyer_card_short)
        end

        invalid_cards = [1, 24, 5.123, 5.12, -500, -1234, "abcd", "1,000"]

        invalid_cards.each do |card|
          order = Order.create(status: "paid", buyer_card_short: card)
          expect(order.errors.keys).to include(:buyer_card_short)
        end
      end

      it "buyer_card_expiration must be on or after today's date" do
        valid_dates = [Date.today, Date.today + 100, Date.today + 365]

        valid_dates.each do |date|
          order = Order.create
          order.update(status: "paid", buyer_card_expiration: Date.parse(date.to_s))
          expect(order.errors.keys).to_not include(:buyer_card_expiration)
        end

        invalid_dates = ["1/1/1970", "16/7/1969", "28/1/1986", Date.today - 1]
        invalid_dates.each do |date|
          order = Order.create
          order.update(status: "paid", buyer_card_expiration: Date.parse(date.to_s))
          expect(order.errors.keys).to include(:buyer_card_expiration)
        end
      end
    end
  end

  describe "methods" do
    context "pending" do
      it "can test whether an order is pending" do
        passing_test = "pending"
        failing_tests = ["paid", "complete", "canceled"]

        expect(Order.create(status: passing_test).pending?).to be(true)

        failing_tests.each do |failure|
          expect(Order.create(status: failure).pending?).to be(false)
        end
      end
    end

    context "total_order_price" do
      before :each do
        @seller = Seller.new(username: "a", email: "bob@bob.bob")
        @seller.password = @seller.password_confirmation = "password"
        @seller.save

        @product = Product.create(name: "astronaut", price: 4_000, seller_id: 1, stock: 5)
        @product2 = Product.create(name: "dsafkhlaer", price: 125, seller_id: 2, stock: 25)
        @order = Order.create
        @item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 2)
      end

      it "has a price based on its order items" do

        expect(@order.total_order_price).to eq(@item.total_item_price)
        expect(@order.total_order_price).to eq(@item.quantity_ordered * @product.price)

        item2 = OrderItem.create(product_id: @product2.id, order_id: @order.id, quantity_ordered: 2)
        @order.reload

        expect(@order.total_order_price).to eq(@item.total_item_price + item2.total_item_price)
        expect(@order.total_order_price).to eq((@item.quantity_ordered * @product.price) + (item2.quantity_ordered * @product2.price))
      end

      it "and only its order items" do
        expect(@order.total_order_price).to eq(@item.total_item_price)
        expect(@order.total_order_price).to eq(@item.quantity_ordered * @product.price)

        order2 = Order.create
        item2 = OrderItem.create(product_id: @product2.id, order_id: 2, quantity_ordered: 25)
        @order.reload

        expect(@order.total_order_price).to eq(@item.total_item_price)
        expect(@order.total_order_price).to eq(@item.quantity_ordered * @product.price)
      end

      it "can have a price based on a single seller's items" do
        expect(@order.total_order_price(@seller.id)).to eq(@item.total_item_price)

        item2 = OrderItem.create(product_id: @product2.id, order_id: 1, quantity_ordered: 25)

        expect(@order.total_order_price(@seller.id)).to eq(@item.total_item_price)
      end
    end
  end
end
