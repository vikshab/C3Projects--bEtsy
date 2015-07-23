class BuyersController < ApplicationController
  include ApplicationHelper

  def new
    @buyer = Buyer.new
    @buyer.order_id = session[:order_id]
    if logged_in?
      @user = User.find(session[:user_id])
    end
  end

  def create
    @buyer = Buyer.new(buyer_params)
    if @buyer.save
      redirect_to buyer_confirmation_path(@buyer.order_id)
    else
      render 'new'
    end
  end

  def confirmation
    @order = Order.find(session[:order_id])
    @order_items = OrderItem.where("order_id = ?", params[:order_id])
    @total = @order.subtotal
    @order_items.each do |item|
      bought = item.quantity #how many were bought
      product = item.product
      inventory = item.product.stock #inventory
      inventory = inventory - bought
      product.update(stock: inventory)
      item.update(status: 'paid')
    end

    @order.update(status: "paid")
  end

  private

    def buyer_params
      params.require(:buyer).permit(:name, :email, :address, :city, :state, :zip, :credit_card, :cvv, :exp, :order_id)
    end
end
