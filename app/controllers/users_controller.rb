class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
    else
      render 'new'
    end
  end

  private

  def create_params
    params.permit(user: [:name, :email, :password_digest])
  end


end
