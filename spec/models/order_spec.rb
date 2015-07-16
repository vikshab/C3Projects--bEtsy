require 'rails_helper'

RSpec.describe Order, type: :model do

  describe "model validations " do
    fields = [:buyer_name, :buyer_zip, :buyer_city, :buyer_email, :buyer_state, :buyer_expcc, :buyer_last4cc, :buyer_address]

    fields.each do |field|
      it "requires a #{field}, all the time" do
        order = Order.new

        expect(order).to_not be_valid
        expect(order.errors.keys).to include(field) #testing that it's failing b/c title is required
      end
    end

    it "email needs an @ sign, all the time" do
      order = Order.new(buyer_email: "bloey")

      expect(order).to_not be_valid
      expect(order.errors.keys).to include(:buyer_email) #testing that it's failing b/c title is required
    end
  end



end # describe Order
