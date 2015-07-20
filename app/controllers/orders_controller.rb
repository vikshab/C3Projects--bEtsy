class OrdersController < ApplicationController
  before_action :set_order, only: [:add_to_cart, :cart, :checkout, :update, :receipt]
  before_action :check_access, only: [:cart, :checkout, :receipt]

  def add_to_cart
    product = Product.find(params[:id])

    if Order.find(session[:order_id]).already_has_product? product
      flash[:error] = "This item is already in your cart!"
    else
      OrderItem.create(product_id: product.id, order_id: session[:order_id], quantity_ordered: 1)
    end

    redirect_to product_path(product)
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

    def check_access
      redirect_to root_path if @order.nil? # I'm pretty sure this will never be true -J
    end
end
