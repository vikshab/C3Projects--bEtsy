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

    context "adjusting order item quantities" do
      before :each do
        @order = Order.create
        @product = Product.create(name: "34234ujoiujhe", stock: 1, price: 1, seller_id: 1)
        @item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 5)
        session[:order_id] = @order.id
      end

      it "adjusts order item quantities as needed to match available stock" do
        get :checkout
        @item.reload

        expect(@item.quantity_ordered).to eq(1)
      end

      it "flashes an error message so the user will understand altered values" do
        get :checkout
        @item.reload

        expect(flash[:errors].keys).to include(:product_stock)
      end
    end

    context "shipping" do
      before :each do
        @order = Order.create
        @product = Product.create(name: "oiajga", stock: 1, price: 1, seller_id: 1)
        @item = OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
        session[:order_id] = @order.id
      end

      context "receiving shipping estimates" do
        let(:params) {
          {
            city: "Seattle",
            state: "WA",
            country: "US",
            zip: "98101"
          }
        }

        before :each do
          VCR.use_cassette("getting shipping quotes") do
            get :checkout, params
          end
        end

        it "assigns @response" do
          expect(assigns(:response)).to_not be_empty
          expect(assigns(:response).first.count).to be 3
          expect(assigns(:response).count).to be > 0
        end

        it "assigns @response specific response" do
          saved_vcr_response = [
            ["USPS Library Mail Parcel", 259, nil],
            ["USPS Media Mail Parcel", 272, nil],
            ["USPS First-Class Mail Parcel", 274, nil],
            ["USPS Priority Mail 1-Day", 575, nil],
            ["UPS Ground", 1125, nil],
            ["UPS Three-Day Select", 1493, "2015-08-26"],
            ["USPS Priority Mail Express 1-Day Hold For Pickup", 1695, nil],
            ["USPS Priority Mail Express 1-Day", 1695, nil],
            ["UPS Second Day Air", 1980, "2015-08-25"],
            ["UPS Next Day Air Saver", 3252, "2015-08-24"],
            ["UPS Next Day Air", 3588, "2015-08-24"],
            ["UPS Next Day Air Early A.M.", 6730, "2015-08-24"]
          ]
          expect(assigns(:response)).to eq(saved_vcr_response)
        end
      end

      # # UNSURE HOW TO TEST A TIMEOUT
      # # HERE: lib/shipping_api.rb --> #call_api_for
      # context "timeout when receiving shipping estimates" do
      #   let(:params) {
      #     {
      #       city: "Seattle",
      #       state: "WA",
      #       country: "US",
      #       zip: "98101"
      #     }
      #   }
      #   before :each do
      #     VCR.use_cassette("getting shipping quotes timeout") do
      #       get :checkout, params
      #     end
      #   end
      #
      #   it "assigns @response" do
      #     expect(assigns(:response)).to be nil
      #   end
      #
      #   it "raises a flash error" do
      #     expect(flash[:errors]).to include(:timeout)
      #   end
      # end

      context "receiving shipping estimates with invalid address" do
        let(:params) {
          {
            city: "Seattle",
            state: "WA",
            country: "US",
            zip: "55555"
          }
        }

        before :each do
          VCR.use_cassette("getting shipping quotes invalid") do
            get :checkout, params
          end
        end

        it "assigns @response" do
          expect(assigns(:response)).to be nil
        end

        it "raises a flash error" do
          expect(flash[:errors]).to include("Invalid address")
        end
      end
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

  describe "PATCH #update_shipping" do
    let(:shipping_params) {
      {
        order: {
          shipping_type: "UPS Ground",
          shipping_price: "1000",
          shipping_estimate: ""
        }
      }
    }

    before :each do
      session[:order_id] = test_order.id
      patch :update_shipping, shipping_params
    end

    it "updates the order" do
      expect(Order.find(session[:order_id]).shipping_type).to eq "UPS Ground"
      expect(Order.find(session[:order_id]).shipping_price).to eq 1000
      expect(Order.find(session[:order_id]).shipping_estimate).to eq nil
    end

    it "redirects to #checkout" do
      expect(subject).to redirect_to checkout_path
    end
  end

  describe "PATCH #remove_shipping" do
    before :each do
      session[:order_id] = test_order.id
      Order.find(session[:order_id]).update(
        shipping_type: "UPS Ground",
        shipping_price: 1000,
        shipping_estimate: nil
      )
      patch :remove_shipping
    end

    it "updates the order" do
      the_order = Order.find(session[:order_id])
      expect(the_order.shipping_type).to eq nil
      expect(the_order.shipping_price).to eq 0
      expect(the_order.shipping_estimate).to eq nil
    end

    it "redirects to #checkout" do
      expect(subject).to redirect_to checkout_path
    end
  end

  describe "PATCH #update" do
    before :each do
      session[:order_id] = test_order.id
    end

    let(:checkout_buyer_params) { {
      order: {
        buyer_name: "My name", buyer_email: "my_email@example.com",
        buyer_address: "123 Example St, Cityville, State 12345",
        buyer_card_short: "1234", buyer_card_expiration: future_date,
        shipping_type: "USPS", shipping_price: 1000,
        shipping_estimate: Time.new(2015, 1, 1)
      }
    } }
    let(:invalid_checkout_buyer_params) { { order: { buyer_card_short: "words" } } }
    let(:action) {
      VCR.use_cassette("shipping API") do
        patch :update, checkout_buyer_params
      end
    }

    it "assigns @order" do
      action

      expect(assigns(:order)).to eq(test_order)
    end

    context "when input is valid" do
      it "updates order.status to paid" do
        action
        test_order.reload
        expect(test_order.status).to eq("paid")
      end

      it "updates the order.buyer_name" do
        old_name = test_order.buyer_name
        action
        test_order.reload
        expect(test_order.buyer_name).not_to eq(old_name)
      end

      it "updates the order.buyer_email" do
        old_email = test_order.buyer_email
        action
        test_order.reload
        expect(test_order.buyer_email).not_to eq(old_email)
      end

      it "updates the order.buyer_address" do
        old_address = test_order.buyer_address
        action
        test_order.reload
        expect(test_order.buyer_address).not_to eq(old_address)
      end

      it "updates the order.buyer_card_short" do
        old_card_short = test_order.buyer_card_short
        action
        test_order.reload
        expect(test_order.buyer_card_short).not_to eq(old_card_short)
      end

      it "updates the order.buyer_card_expiration" do
        old_card_expiration = test_order.buyer_card_expiration
        action
        test_order.reload
        expect(test_order.buyer_card_expiration).not_to eq(old_card_expiration)
      end

      it "redirects to receipt_path" do
        action

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

        expect(flash[:errors].keys).to include(:buyer_card_short)
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

    it "assigns @order_items" do
      get :show, seller_id: @seller.id, id: @order.id

      expect(assigns(:order_items)).to include(@item1)
      expect(assigns(:order_items)).to include(@item2)
    end
  end
end
