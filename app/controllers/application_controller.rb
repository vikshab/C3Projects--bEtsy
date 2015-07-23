class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  MESSAGES = {
    successful_signup: { successful_signup: "You have signed up!"}, # used in SellersController's create
    successful_login: { successful_login: "You have logged in!" }, # used in SessionsController's create
    successful_logout: { successful_logout: "You have logged out!" }, # used in SessionController's destroy
    successful_add_to_cart: { successful_add_to_cart: "The item has been added to your cart!" } # used in OrdersController's add_to_cart
  }

  ERRORS = {
    not_logged_in: { not_logged_in: "Please log in to see this page." }, # used in ApplicationController's require_seller_login
    login_error: { login_error: "Try Again!" }, # OPTIMZE this error message? used in SessionsController's create
    no_orders: { no_orders: "You don't have any orders." } # used in OrdersController's index (/sellers/1/orders)
  }

  # TODO: write tests for require_seller_login & set_seller
  def require_seller_login
    redirect_to login_path, flash: { errors: ERRORS[:not_logged_in] } unless session[:seller_id]
  end

  def set_seller # OPTIMIZE: should this be combined with require_seller_login?
    @seller = Seller.find(session[:seller_id])

    # send seller to its own dashboard if it tries to access another seller's stuff
    redirect_to dashboard_path(@seller) unless params[:seller_id].to_i == @seller.id
  end
end
