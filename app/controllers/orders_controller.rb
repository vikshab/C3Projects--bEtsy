class OrdersController < ApplicationController
  before_action :find_order

  def add
    # code to add item to the cart
    # some kind of handling for users trying to circumvent assigned id
      # eg, checking for pending status & not allowing any changes otherwise

    if session[:order_id] == params[:id]
      OrderItem.create(add_to_cart_params)
      # increment cart view
      # redirect_to product page
    else # not success
      # why would it not be successful?
    end
  end

  def remove_item
    # must prompt before doing this!
    id = params[:order_item][:id]
    @order.order_items.find_by(id: id).destroy
  end

  def update_quantity
    # new_quantity = params(order_item: [:quantity_ordered]) #?
    # handle for zero
    # handle increment
    # handle decrement
  end

  def cart
    # code to view items in cart
    @order_items = Order.order_items.all
  end

  def checkout
    # code to add buyer info
    @order_items = Order.order_items.all
  end

  def receipt
    @order = Order.find_by(session[:order_id])
    @order_items = Order.order_items.all
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
      @order = Order.find_by(session[:order_id]) if session[:order_id] == params[:id]
    end
end
