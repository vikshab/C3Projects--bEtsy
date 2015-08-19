class OrdersController < ApplicationController
  before_action :set_order, only: [:cart, :shipping_estimate, :checkout, :add_to_cart, :update, :receipt]
  before_action :set_seller_order, only: [:show]
  before_action :set_product, only: [:add_to_cart]
  before_action :set_seller, only: [:index, :show]
  before_action :require_seller_login, only: [:index, :show]

  def cart
    @shipping = params[:ship] # NOTE: WRITE TEST
  end

  def checkout
    @order.prepare_checkout!
    flash[:errors] = @order.errors unless @order.errors.empty?
  end

  def shipping_estimate # NOTE: WRITE TEST
    # HTTParty
    response = [["UPS Test", 2034, Time.now],["UPSP Test", 4636, Time.now],["UPSS Test", 4777, Time.now]]
    hash = {}
    response.each do |option|
      hash[option[0]] = [option[1], option[2]]
    end

    # params does not like an array inside an array
    # :shipping below kept returning nil if it was formatted like
    # [["UPS", 100], ["USPS", 200]]
    redirect_to :controller => 'orders', :action => 'cart', :shipping => hash
  end

  def add_to_cart # OPTIMIZE: consider moving this elsewhere, i.e. ProductsController or OrderItemsController. !!!
    order_item = OrderItem.new(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
    if order_item.save
      flash[:messages] = MESSAGES[:successful_add_to_cart]
    else
      flash[:errors] = order_item.errors
    end

    redirect_to product_path(@product)
  end

  def update
    if @order.checkout!(checkout_params)
      redirect_to receipt_path
    else
      flash.now[:errors] = @order.errors
      @order.attributes = checkout_params
      render :checkout
    end
  end

  def receipt
    if @order.status == "paid"
      render :receipt
      session[:order_id] = nil
    else
      redirect_to root_path
    end
  end

  def index
    @orders = @seller.fetch_orders(params[:status])
    flash.now[:errors] = ERRORS[:no_orders] if @orders.length == 0
  end

  def show
    @order_items = @order.order_items.select { |item| item.seller.id == @seller.id }
  end

  private
    def checkout_params
      params.require(:order).permit(:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration)
    end

    def set_order
      if session[:order_id] && Order.find_by(id: session[:order_id])
        @order = Order.find(session[:order_id])
      else
        @order = Order.create
        session[:order_id] = @order.id
      end
    end

    def set_seller_order
      @order = Order.find(params[:order_id] ? params[:order_id] : params[:id])
    end

    def set_product
      @product = Product.find(params[:id])
    end
end
