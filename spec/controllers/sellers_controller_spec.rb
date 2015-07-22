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

      it "redirects to the seller's dashboard page" do
        session[:seller_id]
        post :create, @new_params
        expect(subject).to redirect_to(dashboard_path(@new_params[:id]))
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

      it "assigns flash[:errors]" do
        post :create, @new_params
        expect(flash[:errors]).to include(:username)
      end
    end
  end

  describe "GET #dashboard" do
    context "with authorization" do
      before :each do
        @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
        session[:seller_id] = @seller.id
      end

      it "responds successfully with an HTTP 200 status code" do
        get :dashboard, id: @seller
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the dashboard view" do
        get :dashboard, id: @seller
        expect(response).to render_template("dashboard", session[:seller_id])
      end
    end

    context "without authorization" do
      before :each do
        @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
      end

      it "does not render the dashboard view" do
        get :dashboard, id: @seller
        expect(response).to redirect_to(login_path)
      end

      it "assigns flash[:errors]" do
        get :dashboard, id: @seller
        expect(flash[:errors]).to include("Please log in to see this page.")
      end
    end
  end
end
