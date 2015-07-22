class BuyersController < ApplicationController
  include ApplicationHelper

  def new
    @buyer = Buyer.new
    if logged_in?
      @user = User.find(session[:user_id])
    end
  end

  def create
    @buyer = Buyer.new(buyer_params)
    if @buyer.save
      redirect_to root_path
    else
      render 'new'
    end
  end
  
  private

    def buyer_params
      params.require(:buyer).permit(:name, :email, :address, :city, :state, :zip, :last4cc, :expcc)
    end
end
