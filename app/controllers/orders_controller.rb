class OrdersController < ApplicationController
  before_action :set_order, only: [:add_to_cart, :cart, :checkout, :update, :receipt]
  before_action :set_product, only: [:add_to_cart]
  before_action :set_seller, only [:index]
  before_action :require_seller_login, only: [:index]


  def add_to_cart
    if @order.already_has_product?(@product)
      flash[:error] = "This item is already in your cart!" # TODO: perhaps change this to incrementing the count in the cart?
    else
      OrderItem.create(product_id: @product.id, order_id: @order.id, quantity_ordered: 1)
    end

    redirect_to product_path(@product)
  end

  def cart; end

  def checkout; end

  def update
    # add buyer info to order & change status
    # handling for error messages / bad input if/else type thing
    @order.update(checkout_params)

    redirect_to receipt_path
  end

  def receipt
    if @order.status == "paid"
      render :receipt

      # will this work? no?
      reset_session # it does!
    else
      # redirect to somewhere more logical
      redirect_to root_path
    end
  end

  def index
    @orders = @seller.orders
  end

  private
    def checkout_params
      order_info = params.permit(order: [:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration])[:order]
      order_info[:status] = "paid"

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

    def set_product
      @product = Product.find(params[:id])
    end

    def set_seller
      @seller = Seller.find(params[:id])

      if (params[:seller_id] && (params[:seller_id] != @seller.id)) || params[:id] != @seller.id
        redirect_to seller_path(@seller)
      end
    end
end
