class SellersController < ApplicationController
  before_action :require_seller_login, only: [:dashboard]

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
      flash[:messages] = MESSAGES[:successful_signup]
      session[:seller_id] = @seller.id
      redirect_to dashboard_path(@seller)
    else
      flash.now[:errors] = @seller.errors
      render :new
    end
  end

  def dashboard
    @seller = Seller.find(params[:id])
    render :dashboard
  end

  private

  def create_params
    params.require(:seller).permit(:username, :email, :password)
  end
end
