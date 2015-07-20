require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "database relationships" do
    it "has order items" do
      order = Order.create
      product = Product.create(name: "asdkhjadsf", seller_id: 1, stock: 1, price: 1)
      OrderItem.create(order_id: order.id, product_id: product.id, quantity_ordered: 1)

      expect(order.order_items.count).to eq(1)
    end

    it "has_many :products, through: :order_items"
  end

  describe "model validations" do
    context "requires a status" do
      it "has a default value: 'pending'" do
        order = Order.create
        expect(order.status).to eq("pending")
      end

      it "has only a few valid statuses" do
        valid_statuses = ["pending", "paid", "complete", "canceled"]
        invalid_statuses = ["", "shipped", "PAID", "done", "returned"]

        valid_statuses.each do |status|
          order = Order.create(status: status)
          expect(order.errors.keys).to_not include(:status)
        end

        invalid_statuses.each do |status|
          order = Order.create(status: status)
          expect(order.errors.keys).to include(:status)
        end
      end

      # data validations
      it "validates :status, presence: true, format: { with: VALID_STATUS_REGEX }" do
        # TODO
      end

      it "validates_presence_of :buyer_email, unless: :pending?" do
        # TODO
      end

      it "validates_format_of :buyer_email, with: VALID_EMAIL_REGEX, unless: :pending?" do
        # TODO
      end

      it "validates_presence_of :buyer_name, unless: :pending?" do
        # TODO
      end

      it "validates_presence_of :buyer_address, unless: :pending?" do
        # TODO
      end

      it "validates_presence_of :buyer_card_short, unless: :pending?" do
        # TODO
      end

      it "validates_numericality_of :buyer_card_short, only_integer: true, greater_than: 999, less_than: 10_000, unless: :pending?" do
        # TODO
      end

      it "validates_presence_of :buyer_card_expiration, unless: :pending?" do
        # TODO
      end
    end

    context "buyer_info" do
      it "does not require any buyer info" do
        # !W !I !R NOTE: this is screaming for a more complicated validation.
        # if the status is not pending, we will definitely need all the buyer info!
        order = Order.create

        buyer_fields = [:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration]

        buyer_fields.each do |field|
          expect(order.errors.keys).to_not include(field)
        end
      end

      # it "only accepts valid email addresses" do
      #   # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
      #   # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      #   # validates :buyer_email, presence: false, format: { with: VALID_EMAIL_REGEX }
      # end
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

    context "order_price" do
      before :each do
        @product = Product.create(name: "astronaut", price: 4_000, seller_id: 1, stock: 5)
        @product2 = Product.create(name: "dsafkhlaer", price: 125, seller_id: 1, stock: 25)
        @order = Order.create
        @item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 2)
      end

      it "has a price based on its order items" do
        expect(@order.order_price).to eq(@item.item_price)
        expect(@order.order_price).to eq(@item.quantity_ordered * @product.price)


        item2 = OrderItem.create(product_id: @product2.id, order_id: @order.id, quantity_ordered: 2)
        @order.reload
        expect(@order.order_price).to eq(@item.item_price + item2.item_price)
        expect(@order.order_price).to eq((@item.quantity_ordered * @product.price) + (item2.quantity_ordered * @product2.price))
      end

      it "and only its order items" do
        expect(@order.order_price).to eq(@item.item_price)
        expect(@order.order_price).to eq(@item.quantity_ordered * @product.price)

        item2 = OrderItem.create(product_id: @product2, order_id: 2, quantity_ordered: 25)
        @order.reload
        expect(@order.order_price).to eq(@item.item_price)
        expect(@order.order_price).to eq(@item.quantity_ordered * @product.price)
      end
    end
  end
end
