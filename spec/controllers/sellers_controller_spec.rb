require 'rails_helper'

RSpec.describe SellersController, type: :controller do
  describe "GET #index" do
    it "responds successfully with an HTTP 200 status code" do
      get :index

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the new view" do
      get :new
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "valid seller params" do
      before :each do
        @new_params = { :seller => { username: 'a', email: 'a@a.com', password: 'a' }, id: 1 }
      end

      it "creates a seller" do
        post :create, @new_params
        expect(Seller.count).to eq 1
      end

      it "redirects to the login page" do
        post :create, @new_params
        expect(subject).to redirect_to(login_path)
      end
    end

    context "invalid seller params" do
      before :each do
        @new_params = { :seller => { username: '', email: 'a@a.com', password: 'a' }, id: 1 }
      end

      it "does not persist invalid records" do
        post :create, @new_params
        expect(Product.count).to eq 0
      end

      it "renders the new page so the record can be fixed" do
        post :create, @new_params
        expect(response).to render_template("new")
      end
    end
  end
end
