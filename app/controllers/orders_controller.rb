class OrdersController < ApplicationController

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

  def destroy
    @order = Order.find(id: order_params[:id])
    @order.destroy

  end

  def index
    @all_orders = Order.all
  end

  private

  def order_params
    params.require(:order).permit(:buyer_name,
                                  :buyer_email,
                                  :buyer_zip,
                                  :buyer_state,
                                  :buyer_address,
                                  :buyer_city,
                                  :buyer_expcc,
                                  :buyer_last4cc)
  end



end
