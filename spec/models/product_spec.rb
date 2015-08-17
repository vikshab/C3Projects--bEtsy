require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "model validations" do
    it "requires a name" do
      product = build :product, name: nil

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:name)
    end

    it "requires a user_id" do
      product = build :product, user_id: nil

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:user_id)
    end

    it "requires a price" do
      product = build :product, price: nil

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:price)
    end

    it "excludes duplicate names" do
      product1 = create :product
      product2 = build :product, price: 5
      product3 = build :product, price: 10

      expect(Product.count).to eq 1
    end

    it "doesn't validate 'some word' for price" do
      product = build :product, price: "some word"

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:price)
    end

    it "doesn't validate negative quantity for a product" do
      product = build :product, stock: -1

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:stock)
    end
  end

  it "retire_toggle the products" do
    product = create :product
    product = product.retire_toggle!

    expect(product).to eq(true)
  end
end
