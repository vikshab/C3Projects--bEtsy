require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def set_seller_test
      set_seller
    end

    def require_seller_login_test
      require_seller_login
    end
  end

  describe "require_seller_login" do
    before :each do
      @seller1 = Seller.create(username: "user1", email: "email1@email.com", password: "password1", password_confirmation: "password1")
      routes.draw { get "require_seller_login_test" => "anonymous#require_seller_login_test" }
    end

    context "seller not logged in" do
      before :each do
        get :require_seller_login_test, session: { seller_id: nil }
      end

      it "sets flash[:errors] to include :not_logged_in" do
        expect(flash[:errors]).to include { :not_logged_in }
      end

      it "redirects to login_path" do
        expect(response).to redirect_to login_path
      end
    end

    context "seller logged in" do
      before :each do
        get :require_seller_login_test, session: { seller_id: @seller1.id }
      end

      it "does not set flash[:errors] to include :not_logged_in" do
        expect(flash[:errors]).to_not include { :not_logged_in }
      end
    end
  end

  describe "set_seller" do
    before :each do
      @seller1 = Seller.create(username: "user1", email: "email1@email.com", password: "password1", password_confirmation: "password1")
      @seller2 = Seller.create(username: "user2", email: "email2@email.com", password: "password2", password_confirmation: "password2")

      session[:seller_id] = @seller1.id
      routes.draw { get "set_seller_test" => "anonymous#set_seller_test" }
    end

    it "assigns @seller to the seller in the session" do
      get :set_seller_test

      expect(assigns(:seller)).to eq @seller1
    end

    context "the logged in seller is the seller we're looking at" do
      it "redirects to dashboard" do
        get :set_seller_test, params: { seller_id: @seller1.id }

        expect(response).to redirect_to dashboard_path(@seller1.id)
      end
    end

    context "the logged in seller is not the seller we're looking at" do
      it "redirects to the logged in seller's dashboard" do
        get :set_seller_test, params: { seller_id: @seller2.id }

        expect(response).to redirect_to dashboard_path(@seller1.id)
      end
    end
  end
end
