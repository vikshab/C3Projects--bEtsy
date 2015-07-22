class OrdersController < ApplicationController
  before_action :find_order, only: [:update, :destroy]

  def new
    @order = Order.new
  end

  def create
    @order = Order.create(order_params)
    if @order.save
      redirect_to root_path #need to change this when we have other views
    else
      render :new
    end
  end

  def update
    @order.update(order_params)
    render :show
  end

  def destroy
    @order.destroy
  end

  def index
    #don't know if we need this one, might for the merchants order page
    merchant = User.find(params[:user_id])
    # my_products = Product.where("user_id = ?", params[:user_id])
    @all_items = merchant.order_items
    # @my_items = all_items.product_id.where("user_id = ?", params[:user_id])
  end

  def show
    # calls the items from the Order associated with a session
    @order_items = current_order.order_items
  end

  private

    def order_params
      params.require(:order).permit(:id)
    end

    def find_order
      @order = Order.find(id: order_params[:id])
    end
end
