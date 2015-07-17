class OrdersController < ApplicationController
  before_action :find_order
  before_action :redirect_illegal_actions, only: [:cart, :add, :remove, :checkout]

  def cart; end

  def checkout; end

  def receipt
    # guard clauses
    redirect_to checkout_path if order_mutable?
    redirect_to root_path if (@order.status == "complete") || (@order.status == "cancelled")

    # code to display finalized order
  end

  private
    def find_order
      # note: not using params :id yet! >_>
      # @order = Order.find_by(id: session[:order_id]) if session[:order_id] == params[:order_id] || session[:order_id] == params[:id]
      @order = Order.find_by(id: session[:order_id])
      @order_items = @order.order_items
      @order_items_count = @order_items.count
    end

    def redirect_illegal_actions
      redirect_to receipt_path unless order_mutable?
    end

    def order_mutable?
      @order.status == "pending"
    end
end
