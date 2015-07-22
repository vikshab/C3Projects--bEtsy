require 'rails_helper'

RSpec.describe Product, type: :model do

  describe "model validations" do
    it "requires a name all the time" do
      product = Product.new

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:name)
    end

    it "requires a user_id all the time" do
      product = Product.new(name: "cat", price: 9)

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:user_id)
    end

    it "requires a price all the time" do
      product = Product.new

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:price)
    end

    it "excludes dublicate names" do
      product1 = Product.create(name: "box", price: 3, user_id: 1, stock: 1)
      product2 = Product.create(name: "box", price: 5, user_id: 1, stock: 1)
      product3 = Product.create(name: "box", price: 10, user_id: 1, stock: 1)

      expect(Product.count).to eq 1
    end

    ["some word", -1].each do |invalid_price|
      it "doesn't validate #{invalid_price} for price" do
        product = Product.new(name: "new product", price: invalid_price)

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:price)
      end
    end

    it "doesn't validate negative quantity for a product" do
      product = Product.new(name: "product", price: 8, stock: -1)

      expect(product).to_not be_valid
      expect(product.errors.keys).to include(:stock)
    end
  end
end
