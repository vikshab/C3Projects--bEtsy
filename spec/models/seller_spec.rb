require 'rails_helper'

RSpec.describe Seller, type: :model do
  describe "model validations" do
    let(:seller_w_o_username) { Seller.new(email: "email") }
    let(:seller_w_o_email) { Seller.new(username: "name") }
    let(:seller_w_o_password) { Seller.new(username: "name", email: "email") }

    it "doesn't save a seller without a name" do
      seller_w_o_username.password = "hi"
      seller_w_o_username.password_confirmation = "hi"

      expect(seller_w_o_username).to_not be_valid
      expect(seller_w_o_username.errors.keys).to include(:username)
    end

    it "doesn't save a seller without an email" do
      seller_w_o_email.password = "hi"
      seller_w_o_email.password_confirmation = "hi"

      expect(seller_w_o_email).to_not be_valid
      expect(seller_w_o_email.errors.keys).to include(:email)
    end

    it "doesn't save a seller without a password" do
      expect(seller_w_o_password).to_not be_valid
      expect(seller_w_o_password.errors.keys).to include(:password)
    end
  end
end
