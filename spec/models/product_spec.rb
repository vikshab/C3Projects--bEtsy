require 'rails_helper'

RSpec.describe Product, type: :model do
  describe "model validations" do
    describe "retired" do
      it "isn't required to be valid" do
        product = Product.new
        expect(product.errors.keys).not_to include(:retired)
      end

      it "has a default value" do
        product = Product.new
        expect(product.retired).to eq(false)
      end
    end

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

  describe "scopes" do
    context "has_stock" do
      it "returns only those products with available stock" do
        product1 = Product.create(name: 'afsbfdsf', price: 1, seller_id: 1, stock: 1)
        product2 = Product.create(name: 'asdfbsdfba', price: 1, seller_id: 1, stock: 0)

        expect(Product.has_stock).to include(product1)
        expect(Product.has_stock).not_to include(product2)
      end

      it "returns only unretired products" do
        product1 = Product.create(name: 'afsbfdsf', price: 1, seller_id: 1, stock: 10)
        product2 = Product.create(name: 'asdfbsdfba', price: 1, seller_id: 1, stock: 10, retired: true)

        expect(Product.has_stock).to include(product1)
        expect(Product.has_stock).not_to include(product2)
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

  describe "#stock?" do
    it "returns true if stock is present" do
      product = Product.create(stock: 1, price: 1, seller_id: 1, name: "z4$asdf")
      expect(product.stock?).to eq(true)
    end

    it "returns false if no stock is present" do
      product = Product.create(stock: 0, price: 1, seller_id: 1, name: "z4$asdf")
      expect(product.stock?).to eq(false)
    end
  end

  describe "#retire!" do
    it "changes value of retired from true to false" do
      product = Product.create(stock: 1, price: 1, seller_id: 1, name: "z4ssdfg$%fds", retired: true)
      product.retire!
      expect(product.retired).to eq(false)
    end

    it "also changes value of retired from false to true" do
      product = Product.create(stock: 1, price: 1, seller_id: 1, name: "z4$%fdsasdf", retired: false)
      product.retire!
      expect(product.retired).to eq(true)
    end

    it "basically swaps between true and false, ok?" do
      product = Product.create(stock: 1, price: 1, seller_id: 1, name: "z4$%fasdfasdfds", retired: false)
      10.times do |count|
        product.retire!
        result = count.even? ? true : false

        expect(product.retired).to eq(result)
      end
    end
  end

  describe "adding & removing product stock" do
    context "#add_stock!" do
      before :each do
        @product = Product.create(stock: 1, price: 1, seller_id: 1, name: "z4$")
      end

      it "does not update when fed negative or zero amounts" do
        @product.add_stock!(-30)
        expect(@product.errors.keys).to include(:add_stock)
        expect(@product.stock).to eq(1)

        @product.add_stock!(0)
        expect(@product.errors.keys).to include(:add_stock)
        expect(@product.stock).to eq(1)
      end

      it "updates the product's stock" do
        @product.add_stock!(30)
        expect(@product.errors.keys).not_to include(:add_stock)
        expect(@product.stock).to eq(31)
      end
    end

    context "#remove_stock!" do
      before :each do
        @product = Product.create(stock: 30, price: 1, seller_id: 1, name: "z4$4")
      end

      it "does not update when fed negative or zero amounts" do
        @product.remove_stock!(-30)
        expect(@product.errors.keys).to include(:remove_stock)
        expect(@product.stock).to eq(30)

        @product.remove_stock!(0)
        expect(@product.errors.keys).to include(:remove_stock)
        expect(@product.stock).to eq(30)
      end

      it "updates the product's stock" do
        @product.remove_stock!(30)
        expect(@product.errors.keys).not_to include(:remove_stock)
        expect(@product.stock).to eq(0)
      end
    end
  end

  describe "#top_products" do
    before :each do
      @product1 = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
      @product2 = Product.create(name: 'b', price: 1, seller_id: 1, stock: 1)
      @product3 = Product.create(name: 'c', price: 1, seller_id: 1, stock: 1)
      product4 = Product.create(name: 'd', price: 1, seller_id: 1, stock: 1)
      product5 = Product.create(name: 'e', price: 1, seller_id: 1, stock: 1)
      product6 = Product.create(name: 'f', price: 1, seller_id: 1, stock: 1)
      product7 = Product.create(name: 'g', price: 1, seller_id: 1, stock: 1)
      product8 = Product.create(name: 'h', price: 1, seller_id: 1, stock: 1)
      product9 = Product.create(name: 'i', price: 1, seller_id: 1, stock: 1)
      product10 = Product.create(name: 'j', price: 1, seller_id: 1, stock: 1)
      product11 = Product.create(name: 'k', price: 1, seller_id: 1, stock: 1)
      product12 = Product.create(name: 'l', price: 1, seller_id: 1, stock: 1)
      @worst_rated = Product.create(name: 'm', price: 1, seller_id: 1, stock: 1)

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
      review = Review.create(rating: 2, product_id: 12)
      review = Review.create(rating: 1, product_id: 13)

      @expected_array = [@product1, @product2, @product3, product4, product5,
        product6, product7, product8, product9, product10, product11, product12]
    end

    it "returns the top_products" do
      expect(Product.top_products).to eq(@expected_array)
    end

    it "does not return products that are retired" do
      @product1.update(retired: true)

      expect(Product.top_products).to include(@product2)
      expect(Product.top_products).to include(@worst_rated)
      expect(Product.top_products).not_to include(@product1)
    end

    it "does not return products that have no stock" do
      @product1.update(stock: 0)

      expect(Product.top_products).to include(@product2)
      expect(Product.top_products).to include(@worst_rated)
      expect(Product.top_products).not_to include(@product1)
    end
  end
end
