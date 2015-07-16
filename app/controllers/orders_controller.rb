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
    def add_to_cart_params
      # t.integer :product_id
      # t.integer :order_id
      # t.integer :quantity_ordered
      params.permit(order_item: [:product_id, :order_id, :quantity_ordered])[:order_item]
    end

    def find_order
      # note: not using params :id yet! >_>
      # @order = Order.find_by(id: session[:order_id]) if session[:order_id] == params[:order_id] || session[:order_id] == params[:id]
      @order = Order.first
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
