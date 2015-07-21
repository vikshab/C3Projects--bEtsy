class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :find_categories
  before_action :find_merchants
  helper_method :current_order

  def find_categories
    @categories = Category.all
  end

  def find_merchants
    @merchants = User.all
  end

  def current_order
    reset_session
    if session[:order_id]
      Order.find(session[:order_id])
    else
      Order.create
    end
  end

  def require_login
    unless session[:user_id]
      flash[:error] = "You must be logged in to access this section"
   redirect_to login_path
    end
  end
end
