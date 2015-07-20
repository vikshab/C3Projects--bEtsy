require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "model validations" do
    describe "name validations" do
      it "requires a name" do
        product = Product.new

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:name)
      end

      it "requires the name to be unique" do
        product = Product.create(name: "a", price: 1, seller_id: 1, stock: 1)
        product2 = Product.create(name: "a", price: 1, seller_id: 1, stock: 1)

        expect(product2.errors.keys).to include(:name)
        expect(product2.errors.messages[:name]).to include "has already been taken"
      end
    end

    describe "price validations" do
      it "requires a price" do
        product = Product.new

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:price)
      end

      it "requires price to be a number" do
        product = Product.new(price: "a")

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:price)
        expect(product.errors.messages[:price]).to include "is not a number"
      end

      it "requires price to be greater than 0" do
        product = Product.new(price: 0)

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:price)
        expect(product.errors.messages[:price]).to include "must be greater than 0"
      end
    end

    describe "seller_id validations" do
      it "requires a seller_id" do
        product = Product.new

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:seller_id)
      end

      it "requires seller_id to be an integer" do
        product = Product.new(seller_id: "a")

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:seller_id)
        expect(product.errors.messages[:seller_id]).to include "is not a number"
      end
    end

    describe "stock validations" do
      it "requires stock" do
        product = Product.new

        expect(product.errors.keys).to_not include(:stock)
      end

      it "requires stock to be an integer" do
        product = Product.new(stock: "a")

        expect(product).to_not be_valid
        expect(product.errors.keys).to include(:stock)
        expect(product.errors.messages[:stock]).to include "is not a number"
      end
    end
  end

  describe "#average_rating" do
    it "returns an average rating for a product" do
      product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
      review = Review.create(rating: 1, product_id: 1)
      review2 = Review.create(rating: 3, product_id: 1)

      expect(product.average_rating).to eq 2
    end

    it "returns a message if no ratings" do
      product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)

      expect(product.average_rating).to eq "No reviews"
    end
  end

  describe "has_available_stock?" do
    # code to test this goes here
  end
end
