require "#{ Rails.root }/lib/shipping_api"

class OrdersController < ApplicationController
  before_action :set_order, only: [:cart, :update_shipping, :remove_shipping, :checkout, :add_to_cart, :update, :receipt]
  before_action :set_seller_order, only: [:show]
  before_action :set_product, only: [:add_to_cart]
  before_action :set_seller, only: [:index, :show]
  before_action :require_seller_login, only: [:index, :show]

  def cart; end

  def checkout
    @order.prepare_checkout!
    if all_shipping_params?
      @response = ShippingAPI.call_shipping_api(
        params[:city],
        params[:state],
        params[:zip],
        params[:country]
      )
      if @response.is_a?(Hash)
        flash[:errors] = @response
        @response = nil
      end
    end
    flash[:errors] = @order.errors unless @order.errors.empty?
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

  def update_shipping
    @order.update(shipping_params)
    redirect_to action: :checkout
  end

  def remove_shipping
    @order.update(
      shipping_type: nil,
      shipping_price: 0,
      shipping_estimate: nil
    )
    redirect_to action: :checkout
  end

  def update
    if @order.checkout!(checkout_params)
      ShippingAPI.return_info_to_shipping_api(@order)
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

    def shipping_params
      params.require(:order).permit(:shipping_type, :shipping_price, :shipping_estimate)
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

    def all_shipping_params?
      if params[:city] && params[:state] && params[:country] && params[:zip]
        true
      else
        false
      end
    end
end
