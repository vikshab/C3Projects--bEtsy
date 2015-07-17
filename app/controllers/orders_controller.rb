class OrdersController < ApplicationController
  before_action :find_order, only: [:cart, :checkout, :update, :receipt]
  before_action :check_access, only: [:cart, :checkout, :receipt]


  def cart; end

  def checkout; end # of a particular item in a cart; increases the quantity of an item in the cart

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
      reset_session
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

    def find_order
      @order = Order.find_by(id: session[:order_id])

      # !W this is not final
      redirect_to root_path if @order.nil?
    end

    def check_access
      redirect_to root_path if @order.nil?
    end
end
