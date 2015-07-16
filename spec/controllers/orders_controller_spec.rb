require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe "GET cart" do
    before :each do
      @order = Order.create(status: "pending")

      @order_items_count = number_of_cart_items_wanted = 10
      number_of_cart_items_wanted.times do
        OrderItem.create(order_id: 1, product_id: (1..10).to_a.sample, quantity_ordered: 5)
      end
    end

    it "successfully grabs the #cart action" do
      get :cart

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the cart template" do
      get :cart

      expect(response).to render_template("cart")
    end

    it "assigns @order" do
      get :cart

      expect(assigns(:order)).to eq(@order)
    end

    it "assigns @order_items" do
      get :cart

      expect(assigns(:order_items)).to eq(OrderItem.all)
      expect(assigns(:order_items_count)).to eq(@order_items_count)
    end

    it "redirects to receipt page if order status is not pending" do
      @order.update(status: "paid")
      @order.save
      @order.reload

      get :cart

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(receipt_path)
    end
  end

  context "GET checkout" do
    before :each do
      @order = Order.create(status: "pending")

      @order_items_count = number_of_cart_items_wanted = 10
      number_of_cart_items_wanted.times do
        OrderItem.create(order_id: 1, product_id: (1..10).to_a.sample, quantity_ordered: 5)
      end
    end

    it "successfully grabs the #cart action" do
      get :checkout

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the checkout template" do
      get :checkout

      expect(response).to render_template("checkout")
    end

    it "assigns @order" do
      get :checkout

      expect(assigns(:order)).to eq(@order)
    end

    it "assigns @order_items" do
      get :checkout

      expect(assigns(:order_items)).to eq(OrderItem.all)
      expect(assigns(:order_items_count)).to eq(@order_items_count)
    end

    it "redirects to receipt page if order status is not pending" do
      @order.update(status: "paid")
      @order.save
      @order.reload

      get :checkout

      expect(response).to have_http_status(302)
      expect(response).to redirect_to(receipt_path)
    end
  end

  describe "GET receipt" do
    before :each do
      @order = Order.create(status: "paid")

      @order_items_count = number_of_cart_items_wanted = 10
      number_of_cart_items_wanted.times do
        OrderItem.create(order_id: 1, product_id: (1..10).to_a.sample, quantity_ordered: 5)
      end
    end

    it "successfully grabs the #receipt action" do
      get :receipt

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the receipt template" do
      get :receipt

      expect(response).to render_template("receipt")
    end

    it "assigns @order" do
      get :receipt

      expect(assigns(:order)).to eq(@order)
    end

    it "assigns @order_items" do
      get :receipt

      expect(assigns(:order_items)).to eq(OrderItem.all)
      expect(assigns(:order_items_count)).to eq(@order_items_count)
    end

    context "redirecting to other places based on order status" do
      it "redirects to checkout page when order status is pending" do
        @order.update(status: "pending")
        @order.save
        @order.reload

        get :receipt

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(checkout_path)
      end

      it "redirects to root when order status is complete" do
        @order.update(status: "cancelled")
        @order.save
        @order.reload

        get :receipt

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end

      it "redirects to root when order status is cancelled" do
        @order.update(status: "complete")
        @order.save
        @order.reload

        get :receipt

        expect(response).to have_http_status(302)
        expect(response).to redirect_to(root_path)
      end
    end
  end
end
