class SessionsController < ApplicationController
  before_action :set_seller, only: [:create]

  def new
  end

  def create
    if @seller && @seller.authenticate(params[:session][:password])
      session[:seller_id] = @seller.id
      flash[:messages] = MESSAGES[:successful_login]
      redirect_to dashboard_path(@seller)
    else
      flash.now[:errors] = ERRORS[login_error] # NOTE: in specs, can test this with: `@sellers.errors.messages`
      render :new
    end
  end

  def destroy
    session[:seller_id] = nil
    flash[:messages] = MESSAGES[:successful_logout]
    redirect_to root_path
  end

  private
    def set_seller
      @seller = Seller.find_by(username: params[:session][:username])
    end
end
