class OrderItemsController < ApplicationController
  before_action :set_order_item, only: [:more, :less, :update, :destroy]

  def more # increases the item quantity in the cart by 1
    @order_item.more!

    flash[:errors] = @order_item.errors unless @order_item.errors.empty?

    redirect_to cart_path
  end

  def less # decreases the item quantity in the cart by 1
    @order_item.less!

    flash[:errors] = @order_item.errors unless @order_item.errors.empty?

    redirect_to cart_path
  end

  def update
    if params[:ship] == "true"
      @order_item.mark_shipped
    elsif params[:cancel] == "true"
      @order_item.mark_canceled
    end

    redirect_to :back
  end

  def destroy
    @order_item.destroy

    redirect_to cart_path
  end

  private
    def set_order_item
      @order_item = OrderItem.find(params[:id])
    end
end
