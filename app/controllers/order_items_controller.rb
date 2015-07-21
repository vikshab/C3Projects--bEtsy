class OrderItemsController < ApplicationController
  before_action :find_item, except: :add_to_cart

  # more increases the quantity of an item in the cart
  def more # OrderItem.more <-- gimme more of this OrderItem
    @item.more!

    flash[:error] = @item.errors if @item.errors

    redirect_to cart_path
  end

  # less decreases the quantity of an item in the cart
  def less # OrderItem.less <-- gimme less of this OrderItem
    @item.less!

    flash[:error] = @item.errors if @item.errors
    
    redirect_to cart_path
  end

  # removes an item from the cart by destroying the underlying OrderItem object
  def destroy
    @item.destroy

    redirect_to cart_path
  end

  private
    def find_item
      @item = OrderItem.find_by(id: params[:id])
    end
end
