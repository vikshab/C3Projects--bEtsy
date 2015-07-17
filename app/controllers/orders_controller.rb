class OrdersController < ApplicationController
  before_action :find_order
  before_action :redirect_illegal_actions, only: [:cart, :checkout]

  def cart
    session[:order_id] ||= Order.create.id
  end

  def checkout; end # of a particular item in a cart; increases the quantity of an item in the cart

  def update
    # add buyer info to order & change status
    @order.update(checkout_params)

    redirect_to receipt_path
  end

  def receipt
    # guard clauses !W
    if order_mutable?
      redirect_to checkout_path
    elsif (@order.status == "complete") || (@order.status == "cancelled")
      redirect_to root_path
    end

    render :receipt

    # will this work? no?
    reset_session
    # give them a new order_id or reset to nil
  end

  private
    def checkout_params
      order_info = params.permit(order: [:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration])[:order]
      order_info[:status] = "paid"

      return order_info
    end

    def find_order
      @order = Order.find_by(id: session[:order_id])

      # !W this is not final
      redirect_to root_path if @order.nil?
    end

    def redirect_illegal_actions
      redirect_to receipt_path unless order_mutable?
    end

    def order_mutable?
      @order.status == "pending"
    end
end
