require 'rails_helper'

RSpec.describe OrderItem, type: :model do
  describe "database relationships" do
    it "belongs to a product" do
    end

    it "belongs to an order" do
    end
  end

  describe "model validations" do
    context "requires a product_id" do
      # validates :product_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
    end

    context "requires a category_id" do
      # validates :order_id, presence: true, numericality: { only_integer: true, greater_than: 0 }
    end

    context "requires a quantity_ordered" do
      # validates :quantity_ordered, presence: true, numericality: { only_integer: true, greater_than: 0 }
    end
  end

  describe "scopes" do
    it "by_product" do
      # scope :by_product, ->(prod_id) { where(product_id: prod_id) }
    end
  end

  describe "methods" do
    it "cost" do
      # quantity_ordered * product.price
    end

    it "display_name" do
      # name = product.name.capitalize
      # quantity_ordered == 1 ? name.singularize : name.pluralize
    end

    it "remove_prompt_text" do
      # "Are you sure you want to remove this item (#{ quantity_ordered } #{ display_name }) from your cart?"
    end
  end
end
