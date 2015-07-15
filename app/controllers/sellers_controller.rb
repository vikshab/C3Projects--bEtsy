class SellersController < ApplicationController
  def index
    @sellers = Seller.all
  end

  def show
    @seller = Seller.find(params[:id])
  end
end
