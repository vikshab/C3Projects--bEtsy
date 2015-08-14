require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:seller) { Seller.create(username: "user1", email: "email1@email.com", password: "password1",
    password_confirmation: "password1") }
  let(:valid_params) { { :category => { name: 'a' }, seller_id: 1 } }
  let(:invalid_params) { { :category => { name: '' }, seller_id: 1} }
  let(:category) { Category.create( { name: "I am a category" } ) }
  let(:create_11_categories) {
    Category.create( { name: "Grocery" } )
    Category.create( { name: "Animals" } )
    Category.create( { name: "Home and Garden" } )
    Category.create( { name: "Toys" } )
    Category.create( { name: "Clothing" } )
    Category.create( { name: "Health and Beauty" } )
    Category.create( { name: "Sports and Outdoors" } )
    Category.create( { name: "Automotive" } )
    Category.create( { name: "Books" } )
    Category.create( { name: "Movies" } )
    Category.create( { name: "Electronic" } )
  }

  let(:create_4_products) {
    Product.create( { name: "books", price: "600", seller_id: "7", stock: "2" } )
    Product.create( { name: "sunglasses", price: "10000", seller_id: "1", stock: "9" } )
    Product.create( { name: "coffee", price: "1000", seller_id: "6", stock: "4" } )
    Product.create( { name: "t-shirts", price: "1300", seller_id: "9", stock: "15" } )
  }

  describe "private methods" do
    describe "@set_category" do
      it "finds category and sets it to @category" do
        params = {}
        allow(controller).to receive(:params).and_return(id: category.id)
        expect(controller.send(:set_category)).to eq(category)
      end

      context "when category does not exist" do
        # TODO: What do we want to have happen if someone goes to a URL that doesn't exist?
      end
    end
  end

  describe "Actions" do
    describe "GET #index" do
      it "renders the index template" do
        get :index
        expect(response).to render_template("index")
      end

      it "assigns @categories" do
        create_11_categories

        get :index
        expected_array = Category.all.sort_by { |category| category.name }
        expect(assigns(:categories)).to eq expected_array
        expect(assigns(:categories).count).to eq(11)
      end
    end

    describe "GET #show" do
      it "renders the show template" do
        get :show, { id: category.id }
        expect(response).to render_template("show")
      end

      it "assigns @category (through before_action)" do
        get :show, { id: category.id }
        expect(assigns(:category)).to eq(category)
      end

      it "assigns @products for the given @category" do # TODO: the wording here seems odd
        create_4_products
        category.products << Product.all

        get :show, { id: category.id }
        expect(assigns(:products)).to eq(Product.all)
        expect(assigns(:products).count).to eq(4)
      end

      it "only includes active / not retired products" do
        product = Product.create(name: "blaglagolag", price: 1, seller_id: 1,
          stock: 1, retired: true)
        category.products << product

        get :show, { id: category.id }
        expect(assigns(:products)).not_to include(product)
      end

      context "when a cateogry has no products" do
        # TODO: what do we want to have happen when there are no products?
      end
    end

    describe "GET #new" do
      it "responds successfully with an HTTP 200 status code" do
        seller
        session[:seller_id] = seller.id

        get :new, seller_id: seller
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end

      it "renders the new view" do
        seller
        session[:seller_id] = seller.id

        get :new, seller_id: seller
        expect(response).to render_template("new")
      end

      it "only lets a logged in seller create a category" do
        seller

        get :new
        expect(response).to redirect_to(login_path)
      end
    end

    describe "POST #create" do
      context "valid category params" do
        before :each do
          session[:seller_id] = seller.id
          post :create, valid_params
        end
        
        it "creates a category" do
          expect(Category.count).to eq 1
        end

        it "redirects to the product show page" do
          expect(subject).to redirect_to(seller_products_path(seller))
        end
      end

      context "invalid category params" do
        before :each do
          session[:seller_id] = seller.id
          post :create, invalid_params
        end
        
        it "does not persist invalid records" do
          expect(Product.count).to eq 0
        end

        it "renders the new page so the record can be fixed" do
          expect(response).to render_template("new", session[:seller_id])
        end

        it "assigns flash[:errors]" do
          expect(flash[:errors]).to include(:name)
        end
      end
    end
  end
end
