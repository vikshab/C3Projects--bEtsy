require 'rails_helper'

RSpec.describe ReviewsController, type: :controller do
  describe "GET #new" do
    before :each do
      @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
    end

    it "responds successfully with an HTTP 200 status code" do
      get :new, id: @product
      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the new view" do
      get :new, id: @product
      expect(response).to render_template("new")
    end
  end

  describe "POST #create" do
    context "valid review params" do
      before :each do
        @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
      end

      let(:review_params) do
        {
          review: {
            rating: 1,
            product_id: 1
          }
        }
      end

      it "creates a review" do
        post :create, id: @product, review: review_params[:review]
        expect(Review.count).to eq 1
      end

      it "redirects to the product show page" do
        post :create, id: @product, review: review_params[:review]
        expect(subject).to redirect_to(product_path(@product))
      end
    end

    context "invalid review params" do
      before :each do
        @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
      end

      let(:review_params) do
        {
          review: {
            product_id: 1
          }
        }
      end

      it "does not persist invalid records" do
        post :create, id: @product, review: review_params[:review]
        expect(Review.count).to eq 0
      end

      it "renders the new page so the record can be fixed" do
        post :create, id: @product, review: review_params[:review]
        expect(response).to render_template("new")
      end

      it "assigns flash[:errors]" do
        post :create, id: @product, review: review_params[:review]
        expect(flash[:errors]).to include(:rating)
      end
    end
  end
end
