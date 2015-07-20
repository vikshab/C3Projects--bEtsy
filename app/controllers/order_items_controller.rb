require 'pry'
class OrderItemsController < ApplicationController

  def create
    @order = current_order
    @order_item = @order.order_items.create(order_item_params)
    session[:order_id] = @order.id

    redirect_to product_path(@order_item.product_id)
  end

  def update
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.update(order_item_params)
    @order_items = @order.order_items
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
  end

private

    def order_item_params
      params.require(:order_item).permit(:quantity, :product_id, :order_id)
    end
end
