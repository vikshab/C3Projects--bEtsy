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
    if order_item_params[:quantity].to_i <= @order_item.product.stock.to_i
      @order_item.update(order_item_params)
      @order_items = @order.order_items
      redirect_to order_path(@order)
    else
      flash[:error] = "Unfortunatelly we don't have #{order_item_params[:quantity].to_i} #{@order_item.product.name}, only #{@order_item.product.stock.to_i} available"
      redirect_to cart_path
    end
  end

  def destroy
    @order = current_order
    @order_item = @order.order_items.find(params[:id])
    @order_item.destroy
    @order_items = @order.order_items
    redirect_to cart_path
  end

private

    def order_item_params
      params.require(:order_item).permit(:quantity, :product_id, :order_id)
    end
end
