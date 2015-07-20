class OrderItemsController < ApplicationController
  before_action :find_item, except: :add_to_cart

  # more increases the quantity of an item in the cart
  def more # OrderItem.more <-- gimme more of this OrderItem
    if @item.product.has_available_stock?
      @item.increment!(:quantity_ordered, 1)
    else
      # !W we should talk about whether this error message should be shown
      # and what it should truly say in production
      flash[:error] = "You cannot increase the quantity of #{ @item.product.name } any further, because there are only #{ @item.quantity_ordered } in stock."
    end

    redirect_to cart_path
  end

  # less decreases the quantity of an item in the cart
  def less # OrderItem.less <-- gimme less of this OrderItem
    if @item.quantity_ordered == 1
      # !W we should talk about whether this error message should be shown
      # and what it should truly say in production
      flash[:error] = "You cannot decrease the quantity of #{ @item.product.name } any further. You must remove it from your cart."
    end

    unless @item.quantity_ordered == 1
      @item.decrement!(:quantity_ordered, 1)
      # session[:cart][:@item.product_id.to_sym] -= 1
    end

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
