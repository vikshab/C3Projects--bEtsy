class OrderItemsController < ApplicationController
  before_action :find_item, except: :add

  # # I think this is leftover from the conversion of adding a cart item to the cart to the products controller.
  # def add
  #   item = OrderItem.create(create_params)
  #
  #   flash[:error] = item.errors.messages if item.errors.messages
  #
  #   redirect_to root
  # end

  def more # of a particular item in a cart; increases the quantity of an item in the cart
    stock = @item.product.stock
    current_quantity = @item.quantity_ordered

    if current_quantity < stock
      orders = Order.pending

      # this belongs in the model
      # iterate through product.order_items to count the other pending items
      # remove the scope in order_item model after rewriting this.
      # pls to stop reinventing wheels!
      orders_with_matching_items = orders.select do |order|
        order.order_items.by_product(1).count > 0
      end

      matching_order_sums = orders_with_matching_items.map do |order|
        order.order_items.by_product(1).reduce(0) do |sum, item|
          sum += item.quantity_ordered
        end
      end

      also_pending = matching_order_sums.reduce(0) do |initial_sum, current_sum|
        initial_sum += current_sum
      end

      also_pending -= current_quantity

      stock -= also_pending

      if current_quantity < stock
        @item.increment!(:quantity_ordered, 1)
      else
        flash_more_error
      end
    else
      flash_more_error
    end

    redirect_to cart_path
  end

  def less # of a particular item in a cart; decreases the quantity of an item in the cart
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
    # def create_params #leftover from add
    #   params.permit(item: [:product_id, :category_id, :quantity_ordered])[:item]
    # end

    def find_item
      @item = OrderItem.find_by(id: params[:id])
    end

    def flash_more_error # we should talk about whether or not this error message should be displayed & what it should truly say in production
      flash[:error] = "You cannot increase the quantity of #{ @item.display_name } any further, because there are only #{ @item.quantity_ordered } in stock."
    end
end
