class SessionsController < ApplicationController
  before_action :find_user, only: [:create]

  def new; end

  def create
    # login using email address
    if @user && @user.authenticate(params[:session][:password]) # user was found
      session[:user_id] = @user.id # setting session to the user.id
      redirect_to user_path(@user.id)
    else # user wasn't found
      flash.now[:error] = "Please try again. Bitsy loves you!"
      render "new"
    end
  end

  def destroy
    # session[:user_id] = @user.id
    session[:user_id] = nil
    session[:order_id] = nil
    redirect_to root_path
  end

  private

    def find_user
      @user = User.find_by(email: params[:session][:email])
    end

    def session_params
      params.require(:session).permit(:email, :password, :user_id)
    end
end
