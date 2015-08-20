require 'HTTParty'

class OrdersController < ApplicationController
  before_action :set_order, only: [:cart, :update_shipping, :remove_shipping, :checkout, :add_to_cart, :update, :receipt]
  before_action :set_seller_order, only: [:show]
  before_action :set_product, only: [:add_to_cart]
  before_action :set_seller, only: [:index, :show]
  before_action :require_seller_login, only: [:index, :show]

  SHIPPING_URL = Rails.env.production? ? "PLACEHOLDER" : "http://localhost:3000/shipping/"
  LOGGING_URL  = Rails.env.production? ? "PLACEHOLDER" : "http://localhost:3000/log/"

  def cart; end

  def checkout
    @order.prepare_checkout!
    if all_shipping_params?
      begin
        @response = call_shipping_api
      rescue
        flash[:errors] = ERRORS[:invalid_shipping_address]
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
      return_info_to_shipping_api
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

    def call_shipping_api
      query = "?origin_address1=1215%205th%20Ave&origin_zip=98121&origin_country=US&origin_state=WA&destination_city=#{params[:city]}&destination_zip=#{params[:zip]}&destination_country=#{params[:country]}&destination_state=#{params[:state]}"

      ups_response = HTTParty.get(SHIPPING_URL + "ups" + query)
      usps_response = HTTParty.get(SHIPPING_URL + "usps" + query)
      return (ups_response.parsed_response["data"] + usps_response.parsed_response["data"])
    end

    def return_info_to_shipping_api
      query = "tux?order=#{@order.id}&provider=#{@order.shipping_type}&cost=#{@order.shipping_price}&estimate=#{@order.shipping_estimate}&purchase_time=#{@order.updated_at}"

      HTTParty.post(LOGGING_URL + query)
    end
end
