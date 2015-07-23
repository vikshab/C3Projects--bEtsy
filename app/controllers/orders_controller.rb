class OrdersController < ApplicationController
  before_action :find_order, only: [:update, :destroy]
  before_action :empty_cart?, only: [:cart]

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
    render :cart
  end

  def destroy
    @order.destroy
  end

  def index
    #don't know if we need this one, might for the merchants order page
    @merchant = User.find(params[:user_id])
    # my_products = Product.where("user_id = ?", params[:user_id])
    @all_items = @merchant.order_items
  end

  def cart
    # calls the items from the Order associated with a session
    @order_items = current_order.order_items
  end

  def show
    @buyer =  Buyer.find(params[:id])
  end


  def shipped

  end

  private

    def order_params
      params.require(:order).permit(:id)
    end

    def find_order
      @order = Order.find(id: order_params[:id])
    end

    def empty_cart?
      if session[:order_id].nil?
          render :empty
      elsif session[:order_id].nil? == false
        @order = Order.find(session[:order_id])
        if @order.order_items.count == 0
          render :empty
        end
      end
    end
end
