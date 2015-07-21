class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]
  before_action :correct_user, except: [:new, :create]
  # need this so it can see the helper methods
  include ApplicationHelper
  # def index
  #   @users = User.all
  # end

  def show
    @user = User.find(params[:id])
    @products = @user.products
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

    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

  private

    def create_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end


end
