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

  describe "POST #add_to_cart" do
    before :each do
      @product = Product.create(name: 'a', price: 1, seller_id: 1, stock: 1)
    end

    it "redirects to the product #show page after save" do
      # OrderItem.create(product_id: @product.id, order_id: session[:order_id], quantity_ordered: 1)
      post :add_to_cart, id: 1

      expect(response).to redirect_to(product_path(@product))
    end

    it "creates a new order_item for the current order" do
      post :add_to_cart, id: 1
      Order.last.reload

      # # !Q why are the object_ids different?
      # puts Order.last.id
      # puts OrderItem.last.order_id
      # puts Order.last.object_id
      # puts OrderItem.last.order.object_id
      # puts Order.last.status
      # puts OrderItem.last.order.status
      # Order.find(OrderItem.last.order_id).update(status: "paid")
      # Order.find(OrderItem.last.order_id).reload
      # puts Order.last.id
      # puts OrderItem.last.order_id
      # puts Order.last.object_id
      # puts OrderItem.last.order.object_id
      # puts Order.last.status
      # puts OrderItem.last.order.status

      expect(Order.last.order_items.first.product).to eq(@product)
    end

    context "with the current product already part of the current order" do
      before :each do
        post :add_to_cart, id: 1
        products = Order.last.order_items.map { |item| item.product }
      end

      it "does not create a new order_item" do
        5.times do
          post :add_to_cart, id: 1
          Order.last.reload
          products = Order.last.order_items.map { |item| item.product }
          expect(products.length).to be(1)
        end

        Product.create(name: 'b', price: 1, seller_id: 1, stock: 1)

        post :add_to_cart, id: 2
        Order.last.reload
        products = Order.last.order_items.map { |item| item.product }
        expect(products.length).to be(2)
      end
    end
  end
end
