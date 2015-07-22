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

    it "returns 0 if no ratings" do
      product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)

      expect(product.average_rating).to eq 0
    end
  end

  describe "has_available_stock?" do
    # code to test this goes here
  end

  describe "#top_products" do
    it "returns the top_products" do
      product1 = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
      product2 = Product.create(name: 'b', price: 1, seller_id: 1, stock: 1)
      product3 = Product.create(name: 'c', price: 1, seller_id: 1, stock: 1)
      product4 = Product.create(name: 'd', price: 1, seller_id: 1, stock: 1)
      product5 = Product.create(name: 'e', price: 1, seller_id: 1, stock: 1)
      product6 = Product.create(name: 'f', price: 1, seller_id: 1, stock: 1)
      product7 = Product.create(name: 'g', price: 1, seller_id: 1, stock: 1)
      product8 = Product.create(name: 'h', price: 1, seller_id: 1, stock: 1)
      product9 = Product.create(name: 'i', price: 1, seller_id: 1, stock: 1)
      product10 = Product.create(name: 'j', price: 1, seller_id: 1, stock: 1)
      product11 = Product.create(name: 'k', price: 1, seller_id: 1, stock: 1)
      product12 = Product.create(name: 'l', price: 1, seller_id: 1, stock: 1)
      product13 = Product.create(name: 'm', price: 1, seller_id: 1, stock: 1)

      review = Review.create(rating: 5, product_id: 1)
      review = Review.create(rating: 5, product_id: 2)
      review = Review.create(rating: 5, product_id: 3)
      review = Review.create(rating: 4, product_id: 4)
      review = Review.create(rating: 4, product_id: 5)
      review = Review.create(rating: 4, product_id: 6)
      review = Review.create(rating: 3, product_id: 7)
      review = Review.create(rating: 3, product_id: 8)
      review = Review.create(rating: 3, product_id: 9)
      review = Review.create(rating: 2, product_id: 10)
      review = Review.create(rating: 2, product_id: 11)
      review = Review.create(rating: 1, product_id: 12)
      review = Review.create(rating: 1, product_id: 13)


      expected_array = [product1, product2, product3, product4, product5, product6,
                        product7, product8, product9, product10, product11, product12]
      expect(Product.top_products).to eq expected_array
    end
  end
end
