require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "database relationships" do
    it "has many order items" do
    end
  end

  describe "model validations" do
    context "requires a status" do
      # VALID_STATUS_REGEX = /(pending)|(paid)|(complete)|(cancelled)/
      # validates :status, presence: true, format: { with: VALID_STATUS_REGEX }

      it "has a default value: 'pending'" do
      end

      it "other stuff" do
      end
    end

    context "requires a category_id" do
      # email regex from: http://rails-3-2.railstutorial.org/book/modeling_users#code-validates_format_of_email
      # VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
      # validates :buyer_email, presence: false, format: { with: VALID_EMAIL_REGEX }
      it "does not require an email address" do
      end

      it "only accepts valid email addresses" do
      end
    end
  end

  describe "scopes" do
    # scope :pending, -> { where(status: "pending") }
    # scope :paid, -> { where(status: "paid") }
    # scope :complete, -> { where(status: "complete") }
    # scope :cancelled, -> { where(status: "cancelled") }
    it "pending" do
    end

    it "paid" do
    end

    it "complete" do
    end

    it "cancelled" do
    end
  end

  describe "methods" do
    it "total_price" do
      # array_of_totals = order_items.map { |item| item.cost }
      # total = array_of_totals.reduce(0) { |sum, current_total| sum += current_total }
    end
  end
end
