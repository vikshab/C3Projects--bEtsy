class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  MESSAGES = {
    successful_login: "You have logged in!", # used in SessionsController's create
    successful_logout: "You have logged out!" # used in SessionController's destroy
  }

  ERRORS = {
    not_logged_in: "Please log in to see this page.", # used in ApplicationController's require_seller_login
    already_in_cart: "This item is already in your cart!", # used in OrderController's add_to_cart
    login_error: "Try Again!" # OPTIMZE this error message? used in SessionsController's create
  }

  def require_seller_login
    redirect_to login_path, flash: { errors: ERRORS[:not_logged_in] } unless session[:seller_id]
  end
end
