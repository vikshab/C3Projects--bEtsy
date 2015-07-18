class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  # def index
  #   @users = User.all
  # end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(create_params)
    if @user.save
      flash.now[:success] = "Welcome to Bitsy, #{@user.name}!"
      redirect_to user_path(@user)
    else
      render 'new'
    end
  end

  private

    def create_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def require_login
      unless session[:user_id]
        flash[:error] = "You must be logged in to access this section"
     redirect_to login_path
    end
  end
end
