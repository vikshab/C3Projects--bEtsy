class OrdersController < ApplicationController
  before_action :find_order
  before_action :redirect_illegal_actions, only: [:cart, :checkout]

  def cart
    # session[:order_id] = nil
  end

  def checkout; end

  def update
    # add buyer info to order & change status
    @order.update(checkout_params)

    redirect_to receipt_path
  end

  def receipt
    # guard clauses
    if order_mutable?
      redirect_to checkout_path
    elsif (@order.status == "complete") || (@order.status == "cancelled")
      redirect_to root_path
    end

    render :receipt

    # will this work? no?
    reset_session
  end

  private
    def checkout_params
      order_info = params.permit(order: [:buyer_name, :buyer_email, :buyer_address, :buyer_card_short, :buyer_card_expiration])[:order]
      order_info[:status] = "paid"

      return order_info
    end

    def find_order
      @order = Order.find_by(id: session[:order_id])
    end

    def redirect_illegal_actions
      redirect_to receipt_path unless order_mutable?
    end

    def order_mutable?
      @order.status == "pending"
    end
end
