require 'rails_helper'

RSpec.describe OrdersController, type: :controller do
  before :each do
    @order = Order.create(status: "pending")
    @order_items_count = number_of_cart_items_wanted = 10

    # order_items are dependent on a lot of other things:
    # Seller.create(
    #   username: "birdman", email: "birdman@bird.bird",
    #   password: "put_a_bird_on_it", password_confirmation: "put_a_bird_on_it"
    # )

    ["raven", "crow", "seagull", "wren", "robin", "finch", "heron", "egret"].each do |bird|
      Product.create(name: bird, seller_id: 1, price: 1_000, stock: 50)
    end

    @order_items = []

    number_of_cart_items_wanted.times do
      item = OrderItem.create(order_id: 1, product_id: (1..8).to_a.sample, quantity_ordered: 5)
      @order_items.push(item)
    end
  end

  describe "GET cart" do
    it "renders the cart template" do
      get :cart

      expect(response).to be_success
      expect(response).to have_http_status(200)
    end

    it "assigns @order" do
      get :cart

      expect(assigns(:order)).to eq(@order)
    end

    it "assigns @order_items" do
      get cart_path

      expect(assigns(:order_items)).to eq(@order_items)
      expect(assigns(:order_items_count)).to eq(@order_items_count)
    end

    it "renders the index template" do
      get cart_path

      expect(response).to render_template("cart")
    end

    it "redirects to receipt page if order status is not pending" do
      @order.update(status: "paid")
      @order.reload

      get cart_path

      expect(response).to redirect_to(receipt_path)
    end
  end

  # context "sellers can only see their own sales" do
  #   before :each do
  #     Seller.create(
  #       username: "blackbirds", email: "blackbirds@bird.bird",
  #       password: "put_a_blackbird_on_it", password_confirmation: "put_a_blackbird_on_it"
  #     )
  #     ["raven", "crow"].each do |bird|
  #       Product.create(name: bird, price: 100_00, seller_id: 2, stock: 9_001)
  #     end
  #   end
  # end
end
