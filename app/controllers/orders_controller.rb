class OrdersController < ApplicationController
  before_action :set_order, only: [:add_to_cart, :cart, :checkout, :update, :receipt]
  before_action :set_seller_order, only: [:show]
  before_action :set_product, only: [:add_to_cart]
  before_action :set_seller, only: [:index, :show]
  before_action :require_seller_login, only: [:index, :show]


  def add_to_cart
    if @order.already_has_product?(@product)
      flash[:errors] = ERRORS[already_in_cart] # TODO: perhaps change this to incrementing the count in the cart?
    else
      OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
    end

    redirect_to product_path(@product)
  end

  def cart; end

  def checkout; end

  def update
    if @order.update(checkout_params)
      redirect_to receipt_path
    else
      flash.now[:errors] = @order.errors
      render :checkout
    end
  end

  def receipt
    if @order.status == "paid"
      render :receipt

      reset_session # FIXME: this will interfere with login
    else
      redirect_to root_path # TODO: redirect to somewhere more logical
    end
  end

  def index
    @orders = @seller.orders
    # raise
    flash.now[:errors] = "You don't have any orders." if @orders.length == 0
  end

  def show
    @items = @order.order_items.select { |item| item.seller.id == @seller.id }
  end

  private
    def checkout_params
      order_info = params.permit(order: [:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration])[:order]
      order_info[:status] = "paid"
      order_into[:buyer_card_expiration] = Date.parse(order_into[:buyer_card_expiration])

      return order_info
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
