class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:more, :less, :destroy]

  def more # increases the item quantity in the cart by 1
    @order_item.more!

    flash[:errors] = @order_item.errors if @order_item.errors

    redirect_to cart_path
  end

  def less # decreases the item quantity in the cart by 1
    @order_item.less!

    flash[:errors] = @order_item.errors if @order_item.errors

    redirect_to cart_path
  end

  def destroy
    @order_item.destroy

    redirect_to cart_path
  end

  private
    def set_order_item
      @order_item = OrderItem.find_by(id: params[:id])
    end
end
