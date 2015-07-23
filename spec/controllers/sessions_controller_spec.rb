require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  describe "GET #new" do
    it "responds successfully with an HTTP 200 status code" do
      get :new

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
  end

  describe "POST #create" do

    it "without login, session[:seller_id] is nil" do
      Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")

      expect(session[:seller_id]).to be nil
    end

    context "valid seller" do
      let(:seller_login_params) { { session: { username: "user1", password: "password1" } } }

      before :each do
        @seller = Seller.new(username: "user1", email: "email@email.com")
        @seller.password, @seller.password_confirmation = "password1"
        @seller.save

        post :create, seller_login_params
      end

      it "sets the seller" do
        expect(assigns(:seller)).to eq @seller
      end

      it "sets session[:seller_id] to the seller's id" do
        expect(session[:seller_id]).to eq @seller.id
      end

      it "updates the flash[:messages] to include successful login" do
        expect(flash[:messages]).to include { :successful_login }
      end

      it "redirects to the seller's dashboard" do
        expect(response).to redirect_to(dashboard_path(@seller.id))
        expect(response).to have_http_status(302)
      end
    end

    context "invalid seller" do
      let(:seller_login_params) { { session: { username: "user43", password: "password43" } } }

      before :each do
        post :create, seller_login_params
      end

      it "does not set session[:seller_id]" do
        expect(session[:seller_id]).to be nil
      end

      it "updates flash[:errors] to include a login error" do
        expect(flash[:errors]).to include { :login_error }
      end

      it "renders the :new view" do
        expect(response).to render_template :new
      end
    end
  end
end
