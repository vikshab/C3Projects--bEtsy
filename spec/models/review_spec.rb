require 'rails_helper'

RSpec.describe Review, type: :model do
  describe "model validations" do
    it "requires a rating to be present" do
      review = Review.new

      expect(review).to be_invalid
      expect(review.errors.keys).to include(:rating)
    end

    (1..5).each do |valid_rating|
      it "validates #{valid_rating} as a rating" do
        review = Review.create(rating: valid_rating)

        expect(review).to be_valid
      end
    end

    ["hahaha", 10.0, 3.5, 95].each do |invalid_rating|
      it "doesn't validate #{invalid_rating} as a rating" do
        review = Review.new(rating: invalid_rating)

        expect(review).to_not be_valid
        expect(review.errors.keys).to include(:rating)
      end
    end
  end
end