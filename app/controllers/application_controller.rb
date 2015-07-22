class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  MESSAGES = {
    not_logged_in: "Please log in to see this page."
  }

  def require_seller_login
    redirect_to login_path, flash: { errors: MESSAGES[:not_logged_in] } unless session[:seller_id]
  end
end
