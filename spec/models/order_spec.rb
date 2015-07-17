require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "database relationships" do
    it "has many order items" do
    end
  end

  describe "model validations" do
    context "requires a status" do
      it "has a default value: 'pending'" do
        order = Order.create
        expect(order.status).to eq("pending")
      end

      it "has only a few valid statuses" do
        valid_statuses = ["pending", "paid", "complete", "cancelled"]
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

  describe "scopes" do
    before :each do
      @statuses = ["pending", "paid", "complete", "cancelled"]

      @statuses.each do |status|
        5.times.do
          Order.create(status: status)
        end
      end
    end

    it "orders can be grabbed based on pending status" do
      expect(Order.count).to eq(20)
      expect(Order.pending.count).to eq(5)
    end

    it "orders can be grabbed based on paid status" do
      expect(Order.count).to eq(20)
      expect(Order.paid.count).to eq(5)
    end

    it "orders can be grabbed based on complete status" do
      expect(Order.count).to eq(20)
      expect(Order.complete.count).to eq(5)
    end

    it "orders can be grabbed based on cancelled status" do
      expect(Order.count).to eq(20)
      expect(Order.cancelled.count).to eq(5)
    end
  end

  describe "methods" do
    it "price" do
      # array_of_totals = order_items.map { |item| item.cost }
      # total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
    end
  end
end
