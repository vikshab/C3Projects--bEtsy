require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  describe "GET #cart" do
    before :each do
      @order = Order.create
      session[:order_id] = @order.id
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

      expect(assigns(:order)).to eq(@order)
    end
  end

  context "GET #checkout" do
    before :each do
      @order = Order.create
      session[:order_id] = @order.id

      seller = Seller.new( { username: "I am a seller name", email: "email@example.com" } )
      seller.password = seller.password_confirmation = "IAmAPassword"
      seller.save

      product = Product.create(name: "I am a product", price: 1000, seller_id: seller.id)
      OrderItem.create(order_id: @order.id, product_id: product.id, quantity_ordered: 5)
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

      expect(assigns(:order)).to eq(@order)
    end
  end

  describe "POST #add_to_cart" do
    before :each do
      @order = Order.create
      session[:order_id] = @order.id

      seller = Seller.new( { username: "I am a seller name", email: "email@example.com" } )
      seller.password = seller.password_confirmation = "IAmAPassword"
      seller.save

      @product = Product.create(name: "I am a product", price: 1000, seller_id: seller.id, stock: 10)
    end

    it "assigns @order" do
      post :add_to_cart, { id: @product.id }

      expect(assigns(:order)).to eq(@order)
    end

    it "assigns @product" do
      post :add_to_cart, { id: @product.id }

      expect(assigns(:product)).to eq(@product)
    end

    it "redirects to product#show" do
      post :add_to_cart, { id: @product.id }

      expect(response).to redirect_to(product_path(@product))
    end

    context "when product is unique in cart" do
      it "creates a new order_item for the current order" do
        expect{ post :add_to_cart, { id: @product.id } }.to change{ OrderItem.count }
      end
    end

    context "when product is already in cart" do
      before :each do
        OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
      end

      it "does not create a new OrderItem" do
        post :add_to_cart, { id: @product.id }

        expect(OrderItem.all.count).to eq(1)
        expect(OrderItem.first.quantity_ordered).to eq(1)
      end

      it "adds an error message" do
        post :add_to_cart, { id: @product.id }

        expect(flash[:error]).to include(:product_not_unique)
      end
    end

    # TODO: anw, this is where you left off.


    # it "assigns @order_items" do
    #   get :checkout
    #
    #   expect(assigns(:order_items)).to eq(OrderItem.all)
    #   expect(assigns(:order_items_count)).to eq(@order_items_count)
    # end

    # it "redirects to receipt page if order status is not pending" do
    #   Order.find(session[:order_id]).update(status: "paid")
    #   Order.find(session[:order_id]).save
    #   Order.find(session[:order_id]).reload
    #
    #   get :checkout
    #
    #   expect(response).to have_http_status(302)
    #   expect(response).to redirect_to(receipt_path)
    # end

    # context "with the current product already part of the current order" do
    #   before :each do
    #     post :add_to_cart, id: 1
    #     products = Order.last.order_items.map { |item| item.product }
    #   end

    #   it "does not create a new order_item" do
    #     5.times do
    #       post :add_to_cart, id: 1
    #       Order.last.reload
    #       products = Order.last.order_items.map { |item| item.product }
    #       expect(products.length).to be(1)
    #     end

    #     Product.create(name: 'b', price: 1, seller_id: 1, stock: 1)

    #     post :add_to_cart, id: 2
    #     Order.last.reload
    #     products = Order.last.order_items.map { |item| item.product }
    #     expect(products.length).to be(2)
    #   end
    # end
  end

  describe "PATCH #update" do
    before :each do
      @order = Order.create
      session[:order_id] = @order.id

      @checkout_buyer_params = { order: {buyer_name: "My name", buyer_email: "my_email@example.com", buyer_address: "123 Example St, Cityville, State 12345", buyer_card_short: 1234, buyer_card_expiration: Time.now } }
    end

    it "assigns @order" do
      patch :update, @checkout_buyer_params

      expect(assigns(:order)).to eq(@order)
    end
  end

  describe "GET receipt" do
    before :each do
      @order = Order.create
      session[:order_id] = @order.id

      # # TODO: FOR LINDEY AND JERI: Commenting this out fixed several tests. Something here has problems.
      #   # NOTE: Ash also changed `'1'` -> `@order.id` on `order_id: ` in OrderItem.create below.
      # @order_items_count = number_of_cart_items_wanted = 10
      # number_of_cart_items_wanted.times do
      #   OrderItem.create(order_id: @order.id, product_id: (1..10).to_a.sample, quantity_ordered: 5)
      # end
    end

    # it "successfully grabs the #receipt action" do
    #   get :checkout
    #   Order.find(session[:order_id]).update(status: "paid").save.reload
    #   get :receipt
    #
    #   # expect(response).to be_success
    #   expect(response).to have_http_status(200)
    # end

    # it "renders the receipt template" do
    #   get :receipt
    #
    #   expect(response).to render_template("receipt")
    # end

    it "assigns @order" do
      get :receipt

      expect(assigns(:order)).to eq(@order)
    end

    # it "assigns @order_items" do
    #   get :receipt
    #
    #   expect(assigns(:order_items)).to eq(OrderItem.all)
    #   expect(assigns(:order_items_count)).to eq(@order_items_count)
    # end

    # context "redirecting to other places based on order status" do
    #   it "redirects to checkout page when order status is pending" do
    #     Order.find(session[:order_id]).update(status: "pending")
    #     Order.find(session[:order_id]).save
    #     Order.find(session[:order_id]).reload
    #
    #     get :receipt
    #
    #     expect(response).to have_http_status(302)
    #     expect(response).to redirect_to(checkout_path)
    #   end
    #
    #   it "redirects to root when order status is complete" do
    #     Order.find(session[:order_id]).update(status: "cancelled")
    #     Order.find(session[:order_id]).save
    #     Order.find(session[:order_id]).reload
    #
    #     get :receipt
    #
    #     expect(response).to have_http_status(302)
    #     expect(response).to redirect_to(root_path)
    #   end
    #
    #   it "redirects to root when order status is cancelled" do
    #     Order.find(session[:order_id]).update(status: "complete")
    #     Order.find(session[:order_id]).save
    #     Order.find(session[:order_id]).reload
    #
    #     get :receipt
    #
    #     expect(response).to have_http_status(302)
    #     expect(response).to redirect_to(root_path)
    #   end
    # end
  end
end
