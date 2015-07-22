class BuyersController < ApplicationController
  include ApplicationHelper

  def new
    if logged_in?
      @user = User.find(session[:user_id])
    end
  end
  
end
