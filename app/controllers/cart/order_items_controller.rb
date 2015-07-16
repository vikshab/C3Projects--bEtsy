class Cart::OrderItemsController < ApplicationController
  before_action :find_item, except: :add

  def add
    item = OrderItem.create(create_params)

    flash[:error] = item.errors.messages if item.errors.messages

    redirect_to root
  end

  def more
    max_limit = 0

    Orders.all.select do |order|
      order.status == "pending" && order.order_items.select do |item|
        # item.product.id ==
      end
    end

    @item.increment!(:quantity_ordered, 1) unless @item.product.stock == @item.quantity_ordered

    redirect_to cart_path
  end

  def less
    if @item.quantity_ordered == 1
      flash[:error] = "You cannot decrease the quantity of #{ @item.display_name } any further. You must remove it from your cart."
    end

    @item.decrement!(:quantity_ordered, 1) unless @item.quantity_ordered == 1

    redirect_to cart_path
  end

  def destroy
    @item.destroy

    redirect_to cart_path
  end

  private
    def create_params
      params.permit(item: [:product_id, :category_id, :quantity_ordered])[:item]
    end

    def find_item
      @item = OrderItem.find_by(id: params[:id])
    end
end
