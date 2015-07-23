require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "require_seller_login" do
    context "seller not logged in" do
      it "sets flash[:errors] to include :not_logged_in" do

      end

      it "redirects to login_path" do

      end
    end

    context "seller logged in" do
      it "does not set flash[:errors] to include :not_logged_in" do

      end

      it "does not redirect to login_path" do

      end
    end
  end

  describe "set_seller" do
    before :each do
      @seller1 = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
      @seller2 = Seller.create(username: "user2", email: "email2@email.com", password_digest: "password2")

      session[:seller_id] = @seller1.id
    end

    it "assigns @seller to the seller in the session" do
      subject.set_seller
      expect(assigns(:seller)).to eq @seller1
    end

    context "the logged in seller is the seller we're looking at" do
      it "does not redirect to dashboard" do

      end
    end

    context "the logged in seller is not the seller we're looking at" do
      it "redirects to the logged in seller's dashboard" do

      end
    end
  end
end
