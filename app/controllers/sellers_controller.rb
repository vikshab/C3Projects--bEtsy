class SellersController < ApplicationController
  def index
    @sellers = Seller.all
  end

  def show
    @seller = Seller.find(params[:id])
  end

  def new
    @seller = Seller.new
  end

  def create
    @seller = Seller.new(create_params)
    if @seller.save
      redirect_to login_path
    else
      render :new
    end
  end

  private

  def create_params
    params.require(:seller).permit(:username, :email, :password)
  end
end
