require 'rails_helper'

RSpec.describe ProductsController, type: :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #show" do
    before :each do
      @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
    end

    it "returns successfully with an HTTP 200 status code" do
      get :show, id: @product

      expect(response).to be_success
    end

    it "renders the show view" do
      get :show, id: @product

      expect(response).to render_template("show")
    end
  end
end
