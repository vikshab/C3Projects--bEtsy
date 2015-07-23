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

  describe "GET #edit" do
    before :each do
      @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
      @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
      session[:seller_id] = @seller.id
    end

    it "renders the edit view" do
      get :edit, id: @product
      expect(response).to render_template("edit", session[:seller_id])
    end
  end

  describe "PUT #update" do
    context "valid product params" do
      before :each do
        @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
        @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
        @new_params = { :product => { name: 'b' }, id: 1 }
        session[:seller_id] = @seller.id
      end

      it "updates a product" do
        put :update, @new_params
        expect(Product.find(1).name).to eq 'b'
      end

      it "redirects to sellers products view" do
        put :update, @new_params
        @product.reload
        expect(response).to redirect_to(seller_products_path(@product.seller_id))
      end
    end

    context "invalid product params" do
      before :each do
        @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
        @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
        @new_params = { :product => { name: '' }, id: 1 }
        session[:seller_id] = @seller.id
      end

      it "does not update the product" do
        put :update, @new_params
        @product.reload
        expect(@product.name).to eq 'a'
      end

      it "renders the edit page so the record can be fixed" do
        put :update, @new_params
        @product.reload
        expect(response).to render_template("edit", session[:seller_id])
      end

      it "assigns flash[:errors]" do
        put :update, @new_params
        expect(flash[:errors]).to include(:name)
      end
    end
  end

  describe "GET #new" do
    before :each do
      @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
      session[:seller_id] = @seller.id
    end

    it "responds successfully with an HTTP 200 status code" do
      get :new, seller_id: @seller
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the new view" do
      get :new, seller_id: @seller
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "valid product params" do
      before :each do
        @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
        @new_params = { :product => { name: 'a', price: 1, seller_id: 1, stock: 1 }, seller_id: 1 }
        session[:seller_id] = @seller.id
      end

      it "creates a product" do
        post :create, @new_params
        expect(Product.count).to eq 1
      end

      it "redirects to the product show page" do
        post :create, @new_params
        expect(subject).to redirect_to(product_path(Product.last))
      end
    end

    context "invalid product params" do
      before :each do
        @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
        @new_params = { :product => { name: '', price: 1, seller_id: 1, stock: 1 }, seller_id: 1 }
        session[:seller_id] = @seller.id
      end

      it "does not persist invalid records" do
        post :create, @new_params
        expect(Product.count).to eq 0
      end

      it "renders the new page so the record can be fixed" do
        post :create, @new_params
        expect(response).to render_template("new", session[:seller_id])
      end

      it "assigns flash[:errors]" do
        post :create, @new_params
        expect(flash[:errors]).to include(:name)
      end
    end
  end

  describe "GET #seller" do
    before :each do
      @seller = Seller.create(username: "user1", email: "email1@email.com", password_digest: "password1")
      session[:seller_id] = @seller.id
    end

    it "renders the sellers products view" do
      get :seller, seller_id: @seller
      expect(response).to render_template("seller", session[:seller_id])
    end
  end
end
