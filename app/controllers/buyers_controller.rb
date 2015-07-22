class BuyersController < ApplicationController

  def new
    if session[:user_id]
      @user = User.find(session[:user_id])
    else
      @user = ""
    end

  end
  
end
