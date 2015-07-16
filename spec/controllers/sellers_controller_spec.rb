require 'rails_helper'

RSpec.describe SellersController, type: :controller do
  describe "GET #index" do
    before :each do
      seller = Seller.new(username: "Harry", email: "harry.potter@email.com")
      seller.password = "test"
      seller.password_confirmation = "test"
      seller.save
      @seller_id = seller.id

      Product.create(name: "new", price: 10, seller_id: @seller_id, stock: 1)
      Product.create(name: "newer", price: 20, seller_id: @seller_id, stock: 2)
    end

    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "knows the number of products a seller has in stock" do
      get :index
      expected_result = { @seller_id => 3 }

      expect(assigns(:num_products_for_sellers)).to eq expected_result
    end
  end
end
