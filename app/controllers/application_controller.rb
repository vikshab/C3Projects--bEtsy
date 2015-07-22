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
    # if someone's adding a 2nd item, finds the session already created
    if session[:order_id]
      Order.find(session[:order_id])
    else
    # if someone adds to cart initially, creates a session tied to order
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
