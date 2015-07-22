class OrderItemsController < ApplicationController
  before_action :set_item, only: [:more, :less, :destroy]

  # more increases the quantity of an item in the cart
  def more # OrderItem.more <-- gimme more of this OrderItem
    @item.more!

    flash[:errors] = @item.errors if @item.errors

    redirect_to cart_path
  end

  # less decreases the quantity of an item in the cart
  def less # OrderItem.less <-- gimme less of this OrderItem
    @item.less!

    flash[:errors] = @item.errors if @item.errors

    redirect_to cart_path
  end

  # removes an item from the cart by destroying the underlying OrderItem object
  def destroy
    @item.destroy

    redirect_to cart_path
  end

  private
    def set_item
      @item = OrderItem.find_by(id: params[:id])
    end
end
