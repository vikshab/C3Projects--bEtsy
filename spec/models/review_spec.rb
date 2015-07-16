require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "model validations" do
    describe "rating validations" do
      it "requires a rating" do
        review = Review.new

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:rating)
      end

      it "requires rating to be a number" do
          review = Review.new(rating: "a")

          expect(review).to_not be_valid
          expect(review.errors.keys).to include(:rating)
          expect(review.errors.messages[:rating]).to include "is not a number"
      end

      it "requires rating to be an integer" do
        review = Review.new(rating: 3.4)

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:rating)
      end

      it "requires rating to be between 1 and 5" do
        review = Review.new(rating: 6, product_id: 3)
        review2 = Review.new(rating: 0, product_id: 3)

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:rating)

        expect(review2).to_not be_valid
        expect(review2.errors.keys).to include(:rating)
      end
    end

    describe "product_id validations" do
      it "requires product_id" do
        review = Review.new

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:product_id)
      end

      it "requires product_id to be a number" do
        review = Review.new(rating: 2, product_id: "a")

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:product_id)
        expect(review.errors.messages[:product_id]).to include "is not a number"
      end

      it "requires product_id to be an integer" do
        review = Review.new(rating: 4, product_id: 3.4)

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:product_id)
      end
    end
  end
end
