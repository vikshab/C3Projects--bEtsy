class SessionsController < ApplicationController
  before_action :find_user

  def new

  end

  def create
    # login using email address
    find_user

        if @user && @user.authenticate(params[:session][:password]) # user was found
          session[:user_id] = @user.id # setting session to the user.id
          redirect_to root_path
        else # user wasn't found
          flash.now[:error] = "Try Again Matey" #@user.errors.messages
          render "new"
        end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

end


  private

  def find_user
    @user = User.find_by(email: session_params(:email))
  end

  def session_params
    params.require(:session).permit(:email, :password, :user_id)

  end
