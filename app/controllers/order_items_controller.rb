class OrderItemsController < ApplicationController
  before_action :find_order, only: [:update, :destroy]

  def create
    @order = current_order
    @order_item = @order.order_items.create(order_item_params)
    session[:order_id] = @order.id

    if order_item_params[:quantity].to_i > @order_item.product.stock.to_i
      flash[:error] = "Unfortunately we don't have #{order_item_params[:quantity].to_i} #{@order_item.product.name}, only #{@order_item.product.stock.to_i} available"
    end
    redirect_to cart_path
  end

  def update
    if order_item_params[:quantity].to_i <= @order_item.product.stock.to_i
      @order_item.update(order_item_params)
      @order_items = @order.order_items
      redirect_to order_path(@order)
    else
      flash[:error] = "Unfortunately we don't have #{order_item_params[:quantity].to_i} #{@order_item.product.name}, only #{@order_item.product.stock.to_i} available"
      redirect_to cart_path
    end
  end

  def destroy
    @order_item.destroy
    @order_items = @order.order_items
    redirect_to cart_path
  end

  def shipped
    @item = OrderItem.find(params[:id])
    @item.complete_ship
    @item.save
    redirect_to user_orders_path(@item.product.user_id)
  end

private

    def order_item_params
      params.require(:order_item).permit(:quantity, :product_id, :order_id)
    end

    def find_order
      @order = current_order
      @order_item = @order.order_items.find(params[:id])
    end
end
