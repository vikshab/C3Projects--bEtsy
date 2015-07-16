require 'rails_helper'

RSpec.describe SellersController, type: :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe "calculate_num_products(seller)" do
    before :all do
      @seller = Seller.new(username: "Harry", email: "harry.potter@email.com")
      @seller.password = "test"
      @seller.password_confirmation = "test"
      @seller.save
      10.times do
        Product.create(name: "new", price: 10, seller_id: @seller.id)
      end
    end

    it "returns the total number of products for a specific seller" do
      expect(calculate_num_products(@seller)).to eq 7
    end
  end
end
