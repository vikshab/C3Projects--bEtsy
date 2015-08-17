require 'rails_helper'

RSpec.describe Buyer, type: :model do

  describe "model validations " do
    it "requires a name" do
      buyer = build :buyer, name: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:name) #testing that it's failing b/c title is required
    end

    it "requires an email" do
      buyer = build :buyer, email: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:email) #testing that it's failing b/c title is required
    end

    it "requires an address" do
      buyer = build :buyer, address: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:address) #testing that it's failing b/c title is required
    end

    it "requires a zip" do
      buyer = build :buyer, zip: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:zip) #testing that it's failing b/c title is required
    end

    it "requires a state" do
      buyer = build :buyer, state: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:state) #testing that it's failing b/c title is required
    end

    it "requires a city" do
      buyer = build :buyer, city: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:city) #testing that it's failing b/c title is required
    end

    it "requires an exp" do
      buyer = build :buyer, exp: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:exp) #testing that it's failing b/c title is required
    end

    it "requires a credit_card" do
      buyer = build :buyer, credit_card: nil

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:credit_card) #testing that it's failing b/c title is required
    end

    it "doesn't validate some word for zip" do
      buyer = build :buyer, zip: "some word"
      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:zip)
    end

    it "doesn't validate WAA for state" do
      buyer = build :buyer, state: "WAA"
      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:state)
    end

    it "doesn't validate 'some word' for credit card" do
      buyer = build :buyer, credit_card: "some word"
      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:credit_card)
    end

    it "email needs an @ sign, all the time" do
      buyer = build :buyer, email: "buyeremail.com"

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:email) #testing that it's failing b/c title is required
    end
  end
end
