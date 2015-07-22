class BuyersController < ApplicationController

  def new
    @user = User.find(session[:user_id])
  end
  
end
