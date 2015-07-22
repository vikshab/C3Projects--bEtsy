require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  let(:test_order) { Order.create }
  let(:test_seller) { Seller.create( { username: "I am a seller name", email: "email@example.com", password: "IAmAPassword", password_confirmation: "IAmAPassword" } ) }
  let(:test_product) { Product.create(name: "I am a product", price: 1000, seller_id: test_seller.id, stock: 10) }
  let(:future_date) { "01/01/2020" }

  describe "GET #cart" do
    before :each do
      session[:order_id] = test_order.id
    end

    it "is a success" do
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

      expect(assigns(:order)).to eq(test_order)
    end
  end

  context "GET #checkout" do
    before :each do
      session[:order_id] = test_order.id
      OrderItem.create(order_id: test_order.id, product_id: test_product.id, quantity_ordered: 5)
    end

    it "is a success" do
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

      expect(assigns(:order)).to eq(test_order)
    end
  end

  describe "POST #add_to_cart" do
    before :each do
      session[:order_id] = test_order.id
    end

    it "assigns @order" do
      post :add_to_cart, { id: test_product.id }

      expect(assigns(:order)).to eq(test_order)
    end

    it "assigns @product" do
      post :add_to_cart, { id: test_product.id }

      expect(assigns(:product)).to eq(test_product)
    end

    it "redirects to product#show" do
      post :add_to_cart, { id: test_product.id }

      expect(response).to redirect_to(product_path(test_product))
    end

    context "when session[:order_id] doesn't exist" do
      before :each do
        session.delete(:order_id)
      end

      it "creates a new order" do
        expect{ post :add_to_cart, { id: test_product.id } }.to change{ Order.count }
      end

      it "creates a new session[:order_id] & assigns correct order id" do
        post :add_to_cart, { id: test_product.id }

        expect(session[:order_id]).to eq(Order.last.id)
      end
    end

    context "when session[:order_id] == nil" do
      before :each do
        session[:order_id] = nil
      end

      it "creates a new order" do
        expect{ post :add_to_cart, { id: test_product.id } }.to change{ Order.count }
      end

      it "creates a new session[:order_id] & assigns correct order id" do
        post :add_to_cart, { id: test_product.id }

        expect(session[:order_id]).to eq(Order.last.id)
      end
    end

    context "when product is unique in cart" do
      it "creates a new order_item for the current order" do
        expect{ post :add_to_cart, { id: test_product.id } }.to change{ OrderItem.count }
      end
    end

    context "when product is already in cart" do
      before :each do
        OrderItem.create(product_id: test_product.id, order_id: test_order.id, quantity_ordered: 1)
      end

      it "does not create a new OrderItem" do
        post :add_to_cart, { id: test_product.id }

        expect(OrderItem.all.count).to eq(1)
        expect(OrderItem.first.quantity_ordered).to eq(1)
      end

      it "adds an error message" do
        post :add_to_cart, { id: test_product.id }

        expect(flash[:errors]).to include(:product_not_unique)
      end
    end
  end

  describe "PATCH #update" do
    before :each do
      session[:order_id] = test_order.id
    end

    let(:checkout_buyer_params) { { order: { buyer_name: "My name", buyer_email: "my_email@example.com", buyer_address: "123 Example St, Cityville, State 12345", buyer_card_short: "1234", buyer_card_expiration: future_date } } }
    let(:invalid_checkout_buyer_params) { { order: { buyer_card_short: "words" } } }

    it "assigns @order" do
      patch :update, checkout_buyer_params

      expect(assigns(:order)).to eq(test_order)
    end

    context "when input is valid" do
      it "updates order.status to paid" do
        patch :update, checkout_buyer_params
        test_order.reload
        expect(test_order.status).to eq("paid")
      end

      it "updates the order.buyer_name" do
        old_name = test_order.buyer_name
        patch :update, checkout_buyer_params
        test_order.reload
        expect(test_order.buyer_name).not_to eq(old_name)
      end

      it "updates the order.buyer_email" do
        old_email = test_order.buyer_email
        patch :update, checkout_buyer_params
        test_order.reload
        expect(test_order.buyer_email).not_to eq(old_email)
      end

      it "updates the order.buyer_address" do
        old_address = test_order.buyer_address
        patch :update, checkout_buyer_params
        test_order.reload
        expect(test_order.buyer_address).not_to eq(old_address)
      end

      it "updates the order.buyer_card_short" do
        old_card_short = test_order.buyer_card_short
        patch :update, checkout_buyer_params
        test_order.reload
        expect(test_order.buyer_card_short).not_to eq(old_card_short)
      end

      it "updates the order.buyer_card_expiration" do
        old_card_expiration = test_order.buyer_card_expiration
        patch :update, checkout_buyer_params
        test_order.reload
        expect(test_order.buyer_card_expiration).not_to eq(old_card_expiration)
      end

      it "redirects to receipt_path" do
        patch :update, checkout_buyer_params

        expect(response).to redirect_to(receipt_path)
      end
    end

    context "when input is invalid" do
      it "resets order.status to pending" do
        patch :update, invalid_checkout_buyer_params
        test_order.reload
        expect(test_order.status).to eq("pending")
      end

      it "renders the checkout view" do
        patch :update, invalid_checkout_buyer_params

        expect(response).to render_template("checkout")
      end

      it "does not update the order.buyer_card_short" do
        old_card_short = test_order.buyer_card_short
        patch :update, invalid_checkout_buyer_params
        test_order.reload
        expect(test_order.buyer_card_short).to eq(old_card_short)
      end

      it "assigns flash[:errors]" do
        old_card_short = test_order.buyer_card_short
        patch :update, invalid_checkout_buyer_params

        expect(flash[:errors]).to include(:buyer_card_short)
      end
    end
  end

  describe "GET receipt" do
    let(:checked_out_order) { Order.create( status: "paid", buyer_name: "My name", buyer_email: "my_email@example.com", buyer_address: "123 Example St, Cityville, State 12345", buyer_card_short: "1234", buyer_card_expiration: future_date ) }

    before :each do
      session[:order_id] = checked_out_order.id

      OrderItem.create(order_id: checked_out_order.id, product_id: test_product.id, quantity_ordered: 2)
    end

    it "assigns @order" do
      get :receipt

      expect(assigns(:order)).to eq(checked_out_order)
    end

    it "is a success" do
      get :receipt

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end
    context "when an order is paid" do
      it "renders the receipt template" do
        get :receipt

        expect(response).to render_template("receipt")
      end

      it "resets session[:order_id]" do
        get :receipt

        expect(session[:order_id]).to eq(nil)
      end
    end

    context "when an order is not paid" do
      let(:test_order_pending) { Order.create( status: "pending", buyer_name: "My name", buyer_email: "my_email@example.com", buyer_address: "123 Example St, Cityville, State 12345", buyer_card_short: "1234", buyer_card_expiration: future_date ) }
      let(:test_order_complete) { Order.create( status: "complete", buyer_name: "My name", buyer_email: "my_email@example.com", buyer_address: "123 Example St, Cityville, State 12345", buyer_card_short: "1234", buyer_card_expiration: future_date ) }
      let(:test_order_canceled) { Order.create( status: "canceled", buyer_name: "My name", buyer_email: "my_email@example.com", buyer_address: "123 Example St, Cityville, State 12345", buyer_card_short: "1234", buyer_card_expiration: future_date ) }


      it "redirects to root when 'pending'" do
        session[:order_id] = test_order_pending.id
        get :receipt

        expect(response).to redirect_to(root_path)
      end

      it "redirects to root when 'complete'" do
        session[:order_id] = test_order_complete.id
        get :receipt

        expect(response).to redirect_to(root_path)
      end

      it "redirects to root when 'canceled'" do
        session[:order_id] = test_order_canceled.id
        get :receipt

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "GET #index" do
    before :each do
      @seller = Seller.new(username: "a", email: "bob@bob.bob")
      @seller.password = @seller.password_confirmation = "password"
      @seller.save

      @product1 = Product.create(name: "astronaut", price: 4_000, seller_id: @seller.id, stock: 5)
      @product2 = Product.create(name: "dsafkhlaer", price: 125, seller_id: @seller.id, stock: 25)
      @order = Order.create(status: "paid", buyer_name: "bob", buyer_email: "bob@bob.bob",
        buyer_address: "1234 fake st", buyer_card_short: "4567",
        buyer_card_expiration: Date.parse("June 5 2086"))
      @item1 = OrderItem.create(product_id: @product1.id, order_id: @order.id, quantity_ordered: 2)
      @item2 = OrderItem.create(product_id: @product2.id, order_id: @order.id, quantity_ordered: 2)

      session[:seller_id] = @seller.id
    end

    it "is a success" do
      get :index, seller_id: @seller.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the index template" do
      get :index, seller_id: @seller.id

      expect(response).to render_template("index")
    end

    it "assigns @seller" do
      get :index, seller_id: @seller.id

      expect(assigns(:seller)).to eq(@seller)
    end

    it "assigns @orders" do
      get :index, seller_id: @seller.id

      expect(assigns(:orders)).to include(@order)
    end
  end

  describe "GET #show" do
    before :each do
      @seller = Seller.new(username: "a", email: "bob@bob.bob")
      @seller.password = @seller.password_confirmation = "password"
      @seller.save

      @product1 = Product.create(name: "astronaut", price: 4_000, seller_id: @seller.id, stock: 5)
      @product2 = Product.create(name: "dsafkhlaer", price: 125, seller_id: @seller.id, stock: 25)
      @order = Order.create(status: "paid", buyer_name: "bob", buyer_email: "bob@bob.bob",
        buyer_address: "1234 fake st", buyer_card_short: "4567",
        buyer_card_expiration: Date.parse("June 5 2086"))
      @item1 = OrderItem.create(product_id: @product1.id, order_id: @order.id, quantity_ordered: 2)
      @item2 = OrderItem.create(product_id: @product2.id, order_id: @order.id, quantity_ordered: 2)

      session[:seller_id] = @seller.id
    end

    it "is a success" do
      get :show, seller_id: @seller.id, id: @order.id

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "renders the show template" do
      get :show, seller_id: @seller.id, id: @order.id

      expect(response).to render_template("show")
    end

    it "assigns @seller" do
      get :show, seller_id: @seller.id, id: @order.id

      expect(assigns(:seller)).to eq(@seller)
    end

    it "assigns @order" do
      get :show, seller_id: @seller.id, id: @order.id

      expect(assigns(:order)).to eq(@order)
    end

    it "assigns @items" do
      get :show, seller_id: @seller.id, id: @order.id

      expect(assigns(:items)).to include(@item1)
      expect(assigns(:items)).to include(@item2)
    end
  end
end
