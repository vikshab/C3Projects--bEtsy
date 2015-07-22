class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  MESSAGES = {
    successful_login: "You have logged in!", # used in SessionsController's create
    successful_logout: "You have logged out!", # used in SessionController's destroy
    successful_signup: "You have signed up!",
    successful_add_to_cart: "The item has been added to your cart!"
  }

  ERRORS = {
    not_logged_in: "Please log in to see this page.", # used in ApplicationController's require_seller_login
    login_error: "Try Again!" # OPTIMZE this error message? used in SessionsController's create
  }

  def require_seller_login
    redirect_to login_path, flash: { errors: ERRORS[:not_logged_in] } unless session[:seller_id]
  end
end
