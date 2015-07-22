require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
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

      context "when a cateogry has no products" do
        # TODO: what do we want to have happen when there are no products?
      end
    end
  end
end
