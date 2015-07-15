class SellersController < ApplicationController
  def index
    @sellers = Seller.all
  end

  def show

  end
end
