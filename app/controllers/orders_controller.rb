class OrdersController < ApplicationController
  before_action :find_order

  def add # to cart
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

  def remove # from cart
    # must prompt before doing this!
    id = params[:order_item][:id]
    @order.order_items.find_by(id: id).destroy
  end

  def cart
    # code to view items in cart
  end

  def checkout
    # code to add buyer info
  end

  def receipt
    # code to display finalized order
  end

  # def more_item
  #   item = OrderItem.find_by(id: params[:id])
  #   item.increase!
  # end
  #
  # def less_item
  #   item = OrderItem.find_by(id: params[:id])
  #
  #   unless item.decrease!
  #     flash[:error] = "You cannot decrease the quantity any further. You must remove this item from your cart."
  #   end
  #
  #   redirect_to cart_path
  # end

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
      @order = Order.second
      @order_items = @order.order_items.all
      @order_items_count = @order_items.count
    end
end
