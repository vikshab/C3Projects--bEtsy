require 'rails_helper'

RSpec.describe Buyer, type: :model do

  describe "model validations " do
    fields = [:name, :email, :address, :zip, :state, :city, :exp, :credit_card]

    fields.each do |field|
      it "requires a #{field}, all the time" do
        buyer = Buyer.new

        expect(buyer).to_not be_valid
        expect(buyer.errors.keys).to include(field) #testing that it's failing b/c title is required
      end
    end

    ["some word", 1234].each do |invalid_zip|
      it "doesn't validate #{invalid_zip} for zip" do
        buyer = Buyer.new(name: "new buyer", email: "buyer@email.com", address: "address", zip: "#{invalid_zip}", state: "WA", city: "Seattle", exp: "exp", credit_card: 1234)

        expect(buyer).to_not be_valid
        expect(buyer.errors.keys).to include(:zip)
      end
    end

    it "doesn't validate WAA for state" do
      buyer = Buyer.new(name: "new buyer", email: "buyer@email.com", address: "address", zip: 98106, state: "WAA", city: "Seattle", exp: "exp", credit_card: 1234)

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:state)
    end

    it "doesn't validate 'some word' for credit card" do
      buyer = Buyer.new(name: "new buyer", email: "buyer@email.com", address: "address", zip: 98106, state: "WA", city: "Seattle", exp: "exp", credit_card: "some word")

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:credit_card)
    end

    it "email needs an @ sign, all the time" do
      buyer = Buyer.new(name: "new buyer", email: "buyer.email.com", address: "address", zip: 98106, state: "WA", city: "Seattle", exp: "exp", credit_card: 1234)

      expect(buyer).to_not be_valid
      expect(buyer.errors.keys).to include(:email) #testing that it's failing b/c title is required
    end

  end
end
